/// Response from `POST /api/users` (PascalCase JSON keys).
class AdminUserResponseModel {
  const AdminUserResponseModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isActive,
  });

  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final bool isActive;

  factory AdminUserResponseModel.fromJson(Map<String, dynamic> json) {
    return AdminUserResponseModel(
      id: json['ID'] as String? ?? '',
      username: json['Username'] as String? ?? '',
      email: json['Email'] as String? ?? '',
      firstName: json['FirstName'] as String? ?? '',
      lastName: json['LastName'] as String? ?? '',
      isActive: json['IsActive'] as bool? ?? false,
    );
  }
}
