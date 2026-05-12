/// Request body for `POST /api/tenants/{tenant_id}/users`.
class LinkTenantUserRequest {
  const LinkTenantUserRequest({required this.userId, required this.role});

  final String userId;
  final String role;

  Map<String, dynamic> toJson() => {'user_id': userId, 'role': role};
}
