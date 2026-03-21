class RevokeTokenRequest {
  const RevokeTokenRequest({required this.token});

  final String token;

  Map<String, dynamic> toJson() => {
    'token': token,
    'token_type': 'access_token',
  };
}
