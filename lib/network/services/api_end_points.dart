/// Central base URL and shared path catalog (set `baseUrl` at app startup per flavor).
class ApiEndPoints {
  ApiEndPoints._();

  /// Assign before the first [ApiServices] request, e.g. in `main.dart` / flavor entrypoints.
  ///
  /// **Web:** Browsers enforce CORS. Either enable CORS on the API, or for local dev run
  /// `./scripts/dev_web_with_cors_proxy.sh`, or `dart run tool/web_cors_proxy.dart` plus
  /// `--dart-define=API_BASE_URL=http://127.0.0.1:8081` (see `tool/web_cors_proxy.dart`).
  static String baseUrl = 'http://localhost:8080';

  /// Sent as `X-Tenant-Id` on asset/schema API calls.
  static String tenantId = 'test-property-001';

  /// Sent as `X-Client-Id` on content/subscription API calls.
  static String clientId = 'syncquora-recrip-web';
}
