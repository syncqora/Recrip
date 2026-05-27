FROM ghcr.io/cirruslabs/flutter:3.41.6 AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

RUN flutter build web \
  --release \
  --base-href "/" \
  --pwa-strategy=none \
  --optimization-level=4 \
  --no-source-maps \
  --dart-define=ENVIRONMENT=production

# Stamp deploy id + bust main.dart.js URL (Railway Docker deploy; GH Actions mirrors in deploy.yml).
RUN set -eux; \
  BUILD_ID="${RAILWAY_GIT_COMMIT_SHA:-${SOURCE_VERSION:-local}}"; \
  BUILD_ID="$(printf '%s' "$BUILD_ID" | cut -c1-7)"; \
  BUILT_AT="$(date -u +%Y-%m-%dT%H:%M:%SZ)"; \
  perl -i -pe "s/\\\$RECRIP_BUILD_ID/${BUILD_ID}/g" build/web/index.html; \
  printf '{"buildId":"%s","builtAt":"%s"}\n' "$BUILD_ID" "$BUILT_AT" > build/web/recrip-build.json; \
  for f in build/web/flutter_bootstrap.js build/web/flutter.js; do \
    if [ -f "$f" ]; then \
      sed -i "s|main\\.dart\\.js|main.dart.js?v=${BUILD_ID}|g" "$f"; \
    fi; \
  done; \
  echo "Recrip build id: ${BUILD_ID}"

FROM caddy:2.9.1-alpine

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=build /app/build/web /srv

EXPOSE 8080
