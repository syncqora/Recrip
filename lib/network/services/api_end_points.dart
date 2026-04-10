/// Central base URLs and shared path catalog (override in `main.dart` via `--dart-define`).
class ApiEndPoints {
  ApiEndPoints._();

  /// Auth service (login, introspect, revoke). Used by [AuthServices].
  ///
  /// **Web:** CORS must allow this host. For local dev, `API_BASE_URL` sets both
  /// URLs to one origin in `main.dart`.
  static String authBaseUrl = 'https://auth-service.recrip.com';

  /// Data / content APIs (members, subscriptions, schema). Used by [MemberServices],
  /// [SubscriptionServices].
  static String dataManagementBaseUrl =
      'https://data-management-service.recrip.com';

  /// Tenant header is temporarily disabled in API services.
  /// Keep this for future re-enable if backend requires it again.
  static String tenantId = 'test-property-001';

  /// Sent as `X-Client-Id` on content/subscription API calls.
  static String clientId = 'syncqora-recrip-web';
}
