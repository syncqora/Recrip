#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/Users/vishal/StudioProjects/Recrip"
SCRIPT_PATH="$REPO_DIR/scripts/watch_casio_stock.py"
PLIST_PATH="$HOME/Library/LaunchAgents/com.vishal.casio.stock.plist"
KEYCHAIN_SERVICE="recrip.casio.stock.gmail"
INTERVAL_SECONDS="${INTERVAL_SECONDS:-300}"

GMAIL_USER="${GMAIL_USER:-vishalvav55@gmail.com}"
NOTIFY_EMAIL_TO="${NOTIFY_EMAIL_TO:-vishalvav55@gmail.com}"
PRODUCT_URL="${PRODUCT_URL:-https://casiostore.bhawar.com/products/casio-youth-ae-1200whl-5avdf-watch}"
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-}"
WHATSAPP_NUMBER_E164="${WHATSAPP_NUMBER_E164:-919980655374}"
WHATSAPP_APIKEY="${WHATSAPP_APIKEY:-}"
TELEGRAM_ONLY="${TELEGRAM_ONLY:-0}"

if [[ ! -f "$SCRIPT_PATH" ]]; then
  echo "Error: missing script at $SCRIPT_PATH"
  exit 1
fi

if [[ "$TELEGRAM_ONLY" != "1" ]]; then
  EXISTING_KEYCHAIN_PASSWORD="$(security find-generic-password -s "$KEYCHAIN_SERVICE" -a "$GMAIL_USER" -w 2>/dev/null || true)"

  if [[ -n "${GMAIL_APP_PASSWORD:-}" ]]; then
    : # Use provided password.
  elif [[ -n "$EXISTING_KEYCHAIN_PASSWORD" ]]; then
    GMAIL_APP_PASSWORD="$EXISTING_KEYCHAIN_PASSWORD"
    echo "Using existing Gmail app password from Keychain."
  else
    echo "Enter your NEW Gmail App Password (input hidden):"
    read -r -s GMAIL_APP_PASSWORD
    echo
  fi

  if [[ -z "${GMAIL_APP_PASSWORD:-}" ]]; then
    echo "Error: Gmail app password is required (env var or Keychain)."
    exit 1
  fi
fi

if [[ -z "$TELEGRAM_BOT_TOKEN" || -z "$TELEGRAM_CHAT_ID" ]]; then
  echo "Error: TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID are required."
  exit 1
fi

mkdir -p "$HOME/Library/LaunchAgents"

if [[ "$TELEGRAM_ONLY" != "1" ]]; then
  security delete-generic-password -s "$KEYCHAIN_SERVICE" -a "$GMAIL_USER" >/dev/null 2>&1 || true
  security add-generic-password -U -s "$KEYCHAIN_SERVICE" -a "$GMAIL_USER" -w "$GMAIL_APP_PASSWORD" >/dev/null
fi

cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.vishal.casio.stock</string>

    <key>ProgramArguments</key>
    <array>
      <string>/bin/zsh</string>
      <string>-lc</string>
      <string>cd "$REPO_DIR" &amp;&amp; python3 "$SCRIPT_PATH" &gt;&gt; /tmp/casio-stock.log 2&gt;&amp;1</string>
    </array>

    <key>StartInterval</key>
    <integer>$INTERVAL_SECONDS</integer>

    <key>RunAtLoad</key>
    <true/>

    <key>EnvironmentVariables</key>
    <dict>
      <key>GMAIL_USER</key>
      <string>$GMAIL_USER</string>
      <key>NOTIFY_EMAIL_TO</key>
      <string>$NOTIFY_EMAIL_TO</string>
      <key>PRODUCT_URL</key>
      <string>$PRODUCT_URL</string>
      <key>GMAIL_KEYCHAIN_SERVICE</key>
      <string>$KEYCHAIN_SERVICE</string>
      <key>TELEGRAM_BOT_TOKEN</key>
      <string>$TELEGRAM_BOT_TOKEN</string>
      <key>TELEGRAM_CHAT_ID</key>
      <string>$TELEGRAM_CHAT_ID</string>
      <key>WHATSAPP_NUMBER_E164</key>
      <string>$WHATSAPP_NUMBER_E164</string>
      <key>WHATSAPP_APIKEY</key>
      <string>$WHATSAPP_APIKEY</string>
    </dict>
  </dict>
</plist>
EOF

launchctl unload "$PLIST_PATH" >/dev/null 2>&1 || true
launchctl load "$PLIST_PATH"

echo "Installed and started: com.vishal.casio.stock"
echo "Logs: /tmp/casio-stock.log"
