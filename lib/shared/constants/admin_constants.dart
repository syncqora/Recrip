/// Strings for admin platform flows (tenant / user APIs).
abstract final class AdminConstants {
  AdminConstants._();

  /// Values accepted by `POST .../tenants/{id}/users` for `role`.
  static const List<String> tenantUserRoles = ['member', 'admin'];
}
