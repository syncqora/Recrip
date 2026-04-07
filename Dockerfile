FROM ghcr.io/cirruslabs/flutter:3.41.6 AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

RUN flutter build web \
  --release \
  --base-href "/" \
  --pwa-strategy=offline-first \
  --optimization-level=4 \
  --no-source-maps \
  --dart-define=ENVIRONMENT=production

FROM caddy:2.9.1-alpine

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=build /app/build/web /srv

EXPOSE 8080
