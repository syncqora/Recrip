/// Request body for `POST /api/users`.
class CreateAdminUserRequest {
  const CreateAdminUserRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.isActive,
  });

  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final bool isActive;

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'first_name': firstName,
    'last_name': lastName,
    'is_active': isActive,
  };
}
