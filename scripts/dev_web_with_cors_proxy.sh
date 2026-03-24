#!/usr/bin/env bash
# Starts tool/web_cors_proxy.dart then Flutter web with API_BASE_URL pointing at the proxy.
# Your real API should be reachable at UPSTREAM (default http://127.0.0.1:8080).
#
# Usage (from repo root):
#   ./scripts/dev_web_with_cors_proxy.sh
#   UPSTREAM=http://127.0.0.1:8091 PROXY_PORT=8082 ./scripts/dev_web_with_cors_proxy.sh
# Extra args are passed to `flutter run` (e.g. --web-port=5050).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PROXY_PORT="${PROXY_PORT:-8081}"
UPSTREAM="${UPSTREAM:-http://127.0.0.1:8080}"

cleanup() {
  if [[ -n "${PROXY_PID:-}" ]] && kill -0 "$PROXY_PID" 2>/dev/null; then
    kill "$PROXY_PID" 2>/dev/null || true
    wait "$PROXY_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

echo "Starting CORS proxy: http://127.0.0.1:${PROXY_PORT} -> ${UPSTREAM}"
dart run tool/web_cors_proxy.dart "$UPSTREAM" "$PROXY_PORT" &
PROXY_PID=$!
sleep 1

flutter run -d chrome \
  --dart-define="API_BASE_URL=http://127.0.0.1:${PROXY_PORT}" \
  "$@"
