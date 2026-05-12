/// Response from `POST /api/tenants` (Go-style PascalCase JSON keys).
class TenantResponseModel {
  const TenantResponseModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.domain,
    required this.description,
    required this.logoUrl,
    required this.isActive,
  });

  final String id;
  final String name;
  final String slug;
  final String domain;
  final String description;
  final String logoUrl;
  final bool isActive;

  factory TenantResponseModel.fromJson(Map<String, dynamic> json) {
    return TenantResponseModel(
      id: json['ID'] as String? ?? '',
      name: json['Name'] as String? ?? '',
      slug: json['Slug'] as String? ?? '',
      domain: json['Domain'] as String? ?? '',
      description: json['Description'] as String? ?? '',
      logoUrl: json['LogoURL'] as String? ?? '',
      isActive: json['IsActive'] as bool? ?? false,
    );
  }
}
