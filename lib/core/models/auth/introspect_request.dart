class IntrospectRequest {
  const IntrospectRequest({required this.token});

  final String token;

  Map<String, dynamic> toJson() => {'token': token};
}
