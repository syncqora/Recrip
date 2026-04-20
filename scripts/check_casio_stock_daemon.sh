#!/usr/bin/env bash
set -euo pipefail

PLIST_PATH="$HOME/Library/LaunchAgents/com.vishal.casio.stock.plist"
LABEL="com.vishal.casio.stock"
LOG_FILE="/tmp/casio-stock.log"

echo "== LaunchAgent file =="
if [[ -f "$PLIST_PATH" ]]; then
  echo "FOUND: $PLIST_PATH"
else
  echo "MISSING: $PLIST_PATH"
fi

echo
echo "== launchctl status =="
if launchctl list | rg -q "$LABEL"; then
  launchctl list | rg "$LABEL"
  echo "STATUS: loaded"
else
  echo "STATUS: not loaded"
fi

echo
echo "== Recent logs =="
if [[ -f "$LOG_FILE" ]]; then
  rg "." "$LOG_FILE" | tail -n 20
else
  echo "No log file yet at $LOG_FILE"
fi
