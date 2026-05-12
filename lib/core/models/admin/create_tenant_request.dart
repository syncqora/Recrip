/// Request body for `POST /api/tenants`.
class CreateTenantRequest {
  const CreateTenantRequest({
    required this.name,
    required this.slug,
    required this.domain,
    required this.description,
    required this.logoUrl,
  });

  final String name;
  final String slug;
  final String domain;
  final String description;
  final String logoUrl;

  Map<String, dynamic> toJson() => {
    'name': name,
    'slug': slug,
    'domain': domain,
    'description': description,
    'logo_url': logoUrl,
  };
}
