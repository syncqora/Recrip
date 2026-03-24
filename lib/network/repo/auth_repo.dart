import '../../core/models/auth/login_request.dart';
import '../../core/models/auth/login_response.dart';
import '../../core/models/auth/introspect_request.dart';
import '../../core/models/auth/introspect_response.dart';
import '../../core/models/auth/revoke_token_request.dart';
import '../api/api.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);

  /// Server-side token revoke; body map when JSON returned, else `null`.
  Future<Map<String, dynamic>?> revoke(RevokeTokenRequest request);

  Future<IntrospectResponse> introspect(IntrospectRequest request);
}

class AuthRepo implements AuthRepository {
  AuthRepo({required this.services});

  final AuthServices services;

  @override
  Future<LoginResponse> login(LoginRequest request) => services.login(request);

  @override
  Future<Map<String, dynamic>?> revoke(RevokeTokenRequest request) =>
      services.revoke(request);

  @override
  Future<IntrospectResponse> introspect(IntrospectRequest request) =>
      services.introspect(request);
}
