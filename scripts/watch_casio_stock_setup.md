# Casio Stock Alert Setup

This script checks the Casio product page and alerts you when stock changes from sold-out to available.

## 1) Required values

Set these environment variables:

- `GMAIL_USER` = your Gmail address
- `GMAIL_APP_PASSWORD` = Gmail app password (not your regular Gmail password)
- `NOTIFY_EMAIL_TO` = recipient email (can be same as sender)

Optional variables:

- `PRODUCT_URL` (defaults to the AE-1200WHL-5AV page)
- `PRODUCT_URLS` (comma-separated URLs, overrides `PRODUCT_URL`)
- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_CHAT_ID`
- `WHATSAPP_NUMBER_E164` (example: `919980655374`)
- `WHATSAPP_APIKEY` (from CallMeBot)

## 2) One-time Gmail app password setup

1. Enable 2-step verification on your Google account.
2. Open Google Account -> Security -> App passwords.
3. Create an app password and use that as `GMAIL_APP_PASSWORD`.

## 3) Optional Telegram setup

1. In Telegram, message `@BotFather` and create a bot.
2. Save the bot token as `TELEGRAM_BOT_TOKEN`.
3. Send any message to your bot from your Telegram app.
4. Open:
   `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
5. Find your `chat.id` and set it as `TELEGRAM_CHAT_ID`.

## 4) Optional WhatsApp setup (CallMeBot)

1. Add phone number `+34 644 88 88 88` to your contacts.
2. Send this WhatsApp message to that contact:
   `I allow callmebot to send me messages`
3. You will receive an API key.
4. Set:
   - `WHATSAPP_NUMBER_E164` (international format without `+`)
   - `WHATSAPP_APIKEY`

## 5) Manual test

Run from project root:

```bash
export GMAIL_USER="vishalvav55@gmail.com"
export GMAIL_APP_PASSWORD="YOUR_APP_PASSWORD"
export NOTIFY_EMAIL_TO="vishalvav55@gmail.com"

# Optional:
# export TELEGRAM_BOT_TOKEN="..."
# export TELEGRAM_CHAT_ID="..."
# export WHATSAPP_NUMBER_E164="919980655374"
# export WHATSAPP_APIKEY="..."

python3 scripts/watch_casio_stock.py
```

First run only saves baseline state and sends no alert.

## 6) Auto-run every 5 minutes (macOS launchd)

Create `~/Library/LaunchAgents/com.vishal.casio.stock.plist`:

```xml
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
      <string>cd /Users/vishal/StudioProjects/Recrip && python3 scripts/watch_casio_stock.py >> /tmp/casio-stock.log 2>&1</string>
    </array>

    <key>StartInterval</key>
    <integer>300</integer>

    <key>RunAtLoad</key>
    <true/>

    <key>EnvironmentVariables</key>
    <dict>
      <key>GMAIL_USER</key>
      <string>vishalvav55@gmail.com</string>
      <key>GMAIL_APP_PASSWORD</key>
      <string>YOUR_APP_PASSWORD</string>
      <key>NOTIFY_EMAIL_TO</key>
      <string>vishalvav55@gmail.com</string>
      <!-- Optional keys:
      <key>TELEGRAM_BOT_TOKEN</key><string>...</string>
      <key>TELEGRAM_CHAT_ID</key><string>...</string>
      <key>WHATSAPP_NUMBER_E164</key><string>919980655374</string>
      <key>WHATSAPP_APIKEY</key><string>...</string>
      -->
    </dict>
  </dict>
</plist>
```

Load:

```bash
launchctl unload ~/Library/LaunchAgents/com.vishal.casio.stock.plist 2>/dev/null
launchctl load ~/Library/LaunchAgents/com.vishal.casio.stock.plist
```

Check logs:

```bash
tail -f /tmp/casio-stock.log
```

## 7) Sleep-proof cloud monitor (GitHub Actions)

If you want alerts even when your Mac is asleep/off:

1. Push this repository to GitHub (if not already pushed).
2. In GitHub repository settings, add these secrets:
   - `TELEGRAM_BOT_TOKEN`
   - `TELEGRAM_CHAT_ID`
3. Ensure workflow file exists:
   - `.github/workflows/casio-stock-monitor.yml`
4. In GitHub Actions tab, run `Casio Stock Monitor` once manually (`workflow_dispatch`).

Notes:
- GitHub Actions minimum schedule interval is every 5 minutes.
- The workflow stores state in `.github/state/casio_stock_state.json` so it alerts only on sold-out -> in-stock transition.
