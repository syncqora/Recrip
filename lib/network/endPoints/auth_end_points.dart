/// Auth-related path fragments (relative to [ApiEndPoints.authBaseUrl]).
abstract final class AuthEndPoints {
  AuthEndPoints._();

  static const String login = '/auth/login';
  static const String revoke = '/auth/revoke';
  static const String introspect = '/auth/introspect';
}
