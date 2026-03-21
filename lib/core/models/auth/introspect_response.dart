class IntrospectResponse {
  const IntrospectResponse({
    required this.active,
    this.clientId,
    this.username,
    this.userId,
    this.scope,
    this.exp,
    this.iat,
  });

  final bool active;
  final String? clientId;
  final String? username;
  final String? userId;
  final String? scope;
  final int? exp;
  final int? iat;

  factory IntrospectResponse.fromJson(Map<String, dynamic> json) {
    return IntrospectResponse(
      active: json['active'] as bool,
      clientId: json['client_id'] as String?,
      username: json['username'] as String?,
      userId: json['user_id'] as String?,
      scope: json['scope'] as String?,
      exp: (json['exp'] as num?)?.toInt(),
      iat: (json['iat'] as num?)?.toInt(),
    );
  }
}
