#!/usr/bin/env python3
"""
Stock watcher for Casio product page.

Features:
- Detects "Sold out" vs available state.
- Sends email alert via Gmail SMTP.
- Optional Telegram alert.
- Optional WhatsApp alert via CallMeBot API.
- Persists last known state to avoid duplicate notifications.
"""

from __future__ import annotations

import json
import os
import re
import smtplib
import ssl
import subprocess
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from email.message import EmailMessage
from pathlib import Path
from typing import Optional
from urllib.error import HTTPError, URLError
from urllib.parse import quote_plus
from urllib.request import Request, urlopen


STATE_FILE = Path(
    os.getenv(
        "STATE_FILE_PATH",
        str(Path(__file__).with_name(".casio_stock_state.json")),
    )
)
DEFAULT_PRODUCT_URLS = [
    "https://casiostore.bhawar.com/products/casio-youth-ae-1200whl-5avdf-watch",
    "https://casiostore.bhawar.com/products/casio-ae-1200whd-1avdf-black-digital-unisex-watch",
    "https://casiostore.bhawar.com/products/casio-ae-1200wh-1avdf-black-digital-unisex-watch",
]
DEFAULT_KEYCHAIN_SERVICE = "recrip.casio.stock.gmail"


@dataclass
class Config:
    product_urls: list[str]
    gmail_user: str
    gmail_app_password: str
    notify_email_to: str
    telegram_bot_token: Optional[str]
    telegram_chat_id: Optional[str]
    whatsapp_number_e164: Optional[str]
    whatsapp_apikey: Optional[str]

    def has_gmail(self) -> bool:
        return bool(self.gmail_user and self.gmail_app_password and self.notify_email_to)

    def has_telegram(self) -> bool:
        return bool(self.telegram_bot_token and self.telegram_chat_id)

    def has_whatsapp(self) -> bool:
        return bool(self.whatsapp_number_e164 and self.whatsapp_apikey)

    @classmethod
    def from_env(cls) -> "Config":
        gmail_user = os.getenv("GMAIL_USER", "").strip()
        gmail_app_password = os.getenv("GMAIL_APP_PASSWORD", "").strip()
        keychain_service = os.getenv("GMAIL_KEYCHAIN_SERVICE", DEFAULT_KEYCHAIN_SERVICE).strip()
        if not gmail_app_password and gmail_user:
            gmail_app_password = read_keychain_password(
                service_name=keychain_service,
                account_name=gmail_user,
            )
        notify_email_to = os.getenv("NOTIFY_EMAIL_TO", "").strip()
        raw_product_urls = os.getenv("PRODUCT_URLS", "").strip()
        if raw_product_urls:
            product_urls = [item.strip() for item in raw_product_urls.split(",") if item.strip()]
        else:
            product_url = os.getenv("PRODUCT_URL", "").strip()
            product_urls = [product_url] if product_url else DEFAULT_PRODUCT_URLS
        telegram_bot_token = os.getenv("TELEGRAM_BOT_TOKEN", "").strip() or None
        telegram_chat_id = os.getenv("TELEGRAM_CHAT_ID", "").strip() or None
        whatsapp_number = os.getenv("WHATSAPP_NUMBER_E164", "").strip() or None
        whatsapp_apikey = os.getenv("WHATSAPP_APIKEY", "").strip() or None

        has_gmail = bool(gmail_user and gmail_app_password and notify_email_to)
        has_telegram = bool(telegram_bot_token and telegram_chat_id)
        has_whatsapp = bool(whatsapp_number and whatsapp_apikey)
        if not (has_gmail or has_telegram or has_whatsapp):
            raise ValueError(
                "No notification channel configured. Configure Gmail (GMAIL_USER, "
                "GMAIL_APP_PASSWORD or Keychain, NOTIFY_EMAIL_TO), or Telegram "
                "(TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID), or WhatsApp "
                "(WHATSAPP_NUMBER_E164, WHATSAPP_APIKEY)."
            )

        return cls(
            product_urls=product_urls,
            gmail_user=gmail_user,
            gmail_app_password=gmail_app_password,
            notify_email_to=notify_email_to,
            telegram_bot_token=telegram_bot_token,
            telegram_chat_id=telegram_chat_id,
            whatsapp_number_e164=whatsapp_number,
            whatsapp_apikey=whatsapp_apikey,
        )


def read_keychain_password(service_name: str, account_name: str) -> str:
    try:
        result = subprocess.run(
            [
                "security",
                "find-generic-password",
                "-s",
                service_name,
                "-a",
                account_name,
                "-w",
            ],
            check=True,
            capture_output=True,
            text=True,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        return ""


def fetch_product_page(url: str) -> str:
    ssl_context = build_ssl_context()
    req = Request(
        url,
        headers={
            "User-Agent": (
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                "AppleWebKit/537.36 (KHTML, like Gecko) "
                "Chrome/122.0.0.0 Safari/537.36"
            )
        },
    )
    with urlopen(req, timeout=30, context=ssl_context) as response:
        return response.read().decode("utf-8", errors="ignore")


def build_ssl_context() -> ssl.SSLContext:
    context = ssl.create_default_context()
    # On some macOS Python environments, default cert store is incomplete.
    # If certifi is installed, prefer that CA bundle.
    try:
        import certifi  # type: ignore

        context.load_verify_locations(cafile=certifi.where())
    except Exception:
        pass
    return context


def is_in_stock(html: str) -> bool:
    # Shopify JSON-LD: prefer this so unrelated "Sold out" blocks (e.g. carousel)
    # do not override the main product.
    if re.search(
        r'"availability"\s*:\s*"https://schema\.org/InStock"',
        html,
        re.IGNORECASE,
    ):
        return True
    if re.search(
        r'"availability"\s*:\s*"https://schema\.org/OutOfStock"',
        html,
        re.IGNORECASE,
    ):
        return False

    lowered = html.lower()
    if "sold out" in lowered:
        return False
    indicators = ("add to cart", "buy now", "check out", "checkout")
    return any(token in lowered for token in indicators)


def load_previous_state() -> dict[str, bool]:
    if not STATE_FILE.exists():
        return {}
    try:
        data = json.loads(STATE_FILE.read_text(encoding="utf-8"))
        # Backward-compatible migration from single-url format.
        if isinstance(data.get("in_stock"), bool):
            return {}
        state_map = data.get("in_stock_by_url", {})
        if isinstance(state_map, dict):
            normalized: dict[str, bool] = {}
            for key, value in state_map.items():
                if isinstance(key, str) and isinstance(value, bool):
                    normalized[key] = value
            return normalized
    except (json.JSONDecodeError, OSError):
        return {}
    return {}


def save_state(in_stock_by_url: dict[str, bool]) -> None:
    payload = {
        "in_stock_by_url": in_stock_by_url,
        "updated_at_utc": datetime.now(timezone.utc).isoformat(),
    }
    STATE_FILE.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def send_gmail_alert(cfg: Config, message: str, subject: str) -> None:
    email = EmailMessage()
    email["Subject"] = subject
    email["From"] = cfg.gmail_user
    email["To"] = cfg.notify_email_to
    email.set_content(message)

    context = ssl.create_default_context()
    with smtplib.SMTP_SSL("smtp.gmail.com", 465, context=context) as server:
        server.login(cfg.gmail_user, cfg.gmail_app_password)
        server.send_message(email)


def send_telegram_alert(cfg: Config, message: str) -> None:
    if not cfg.telegram_bot_token or not cfg.telegram_chat_id:
        return
    url = (
        f"https://api.telegram.org/bot{cfg.telegram_bot_token}/sendMessage"
        f"?chat_id={quote_plus(cfg.telegram_chat_id)}&text={quote_plus(message)}"
    )
    with urlopen(url, timeout=20) as response:
        response.read()


def send_whatsapp_alert(cfg: Config, message: str) -> None:
    if not cfg.whatsapp_number_e164 or not cfg.whatsapp_apikey:
        return
    # CallMeBot endpoint. Phone number format should be international without '+'.
    url = (
        "https://api.callmebot.com/whatsapp.php"
        f"?phone={quote_plus(cfg.whatsapp_number_e164)}"
        f"&text={quote_plus(message)}"
        f"&apikey={quote_plus(cfg.whatsapp_apikey)}"
    )
    with urlopen(url, timeout=20) as response:
        response.read()


def main() -> int:
    try:
        cfg = Config.from_env()
    except ValueError as err:
        print(f"[CONFIG ERROR] {err}")
        return 2

    previous_state = load_previous_state()
    current_state: dict[str, bool] = {}
    newly_available_urls: list[str] = []

    for product_url in cfg.product_urls:
        try:
            html = fetch_product_page(product_url)
        except (HTTPError, URLError, TimeoutError, ssl.SSLError) as err:
            print(f"[FETCH ERROR] Could not fetch product page ({product_url}): {err}")
            if "CERTIFICATE_VERIFY_FAILED" in str(err):
                print(
                    "[HINT] SSL trust issue detected. Install certifi "
                    "(pip3 install certifi) or fix local Python certificates."
                )
            continue

        current_in_stock = is_in_stock(html)
        current_state[product_url] = current_in_stock
        status_text = "IN STOCK" if current_in_stock else "SOLD OUT"
        print(
            f"[{datetime.now().isoformat(timespec='seconds')}] "
            f"{product_url} -> {status_text}"
        )
        if previous_state.get(product_url) is False and current_in_stock is True:
            newly_available_urls.append(product_url)

    # Preserve entries that were temporarily unreachable in this run.
    merged_state = previous_state.copy()
    merged_state.update(current_state)
    save_state(merged_state)

    if not previous_state:
        print("[INFO] Baseline saved. No alert on first run.")
        return 0

    if newly_available_urls:
        lines = ["Casio stock alert: these watches are now available:"]
        lines.extend(f"- {url}" for url in newly_available_urls)
        text = "\n".join(lines)
        subject = "Stock Alert: Casio watch available"

        failures = []
        if cfg.has_gmail():
            try:
                send_gmail_alert(cfg, text, subject)
            except Exception as err:  # noqa: BLE001
                failures.append(f"Gmail failed: {err}")

        if cfg.has_telegram():
            try:
                send_telegram_alert(cfg, text)
            except Exception as err:  # noqa: BLE001
                failures.append(f"Telegram failed: {err}")

        if cfg.has_whatsapp():
            try:
                send_whatsapp_alert(cfg, text)
            except Exception as err:  # noqa: BLE001
                failures.append(f"WhatsApp failed: {err}")

        if failures:
            print("[WARN] Some notifications failed:")
            for item in failures:
                print(f" - {item}")
            return 4
        print("[ALERT SENT] Availability notifications sent.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
