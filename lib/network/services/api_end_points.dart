/// Central base URL and shared path catalog (set `baseUrl` at app startup per flavor).
class ApiEndPoints {
  ApiEndPoints._();

  /// Assign before the first [ApiServices] request, e.g. in `main.dart` / flavor entrypoints.
  static String baseUrl = 'http://localhost:8080';
}
