/// Platform admin paths (relative to [ApiEndPoints.authBaseUrl]).
abstract final class AdminPlatformEndPoints {
  AdminPlatformEndPoints._();

  static const String tenants = '/api/tenants';
  static const String users = '/api/users';

  /// POST body: `user_id`, `role`.
  static String tenantUsers(String tenantId) => '/api/tenants/$tenantId/users';
}
