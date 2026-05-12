import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/auth/introspect_request.dart';
import '../models/auth/introspect_response.dart';
import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';
import '../models/auth/revoke_token_request.dart';
import '../../network/repo/repo.dart';
import '../../shared/constants/box_constants.dart';
import '../../shared/utils/app_exceptions.dart';
import '../../shared/utils/jwt_utils.dart';

/// Application layer: uses [AuthRepository], persists session after login.
class AuthService extends GetxService {
  AuthService(this._repository);

  final AuthRepository _repository;
  final GetStorage _storage = GetStorage();

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final result = await _repository.login(
      LoginRequest(email: email, password: password),
    );
    await _persistSession(result, loginEmail: email);
    return result;
  }

  Future<void> _persistSession(
    LoginResponse response, {
    required String loginEmail,
  }) async {
    await _storage.write(BoxConstants.accessToken, response.accessToken);
    await _storage.write(BoxConstants.refreshToken, response.refreshToken);
    await _storage.write(BoxConstants.tokenScope, response.scope);
    final expiresAt = DateTime.now()
        .add(Duration(seconds: response.expiresIn))
        .millisecondsSinceEpoch;
    await _storage.write(BoxConstants.tokenExpiresAtMs, expiresAt);
    await _storage.write(BoxConstants.isUserLoggedIn, true);
    await _storage.write(
      BoxConstants.loggedInEmail,
      loginEmail.trim().toLowerCase(),
    );
    await _persistTokenClaims(response.accessToken);
  }

  /// Decodes the access token payload and persists tenant + user identifiers
  /// so the rest of the app can read them without re-parsing the JWT.
  Future<void> _persistTokenClaims(String accessToken) async {
    final claims = JwtUtils.decodePayload(accessToken);
    if (claims.isEmpty) return;

    Future<void> writeIfPresent(String key, Object? value) async {
      if (value == null) return;
      if (value is String && value.isEmpty) return;
      await _storage.write(key, value);
    }

    await writeIfPresent(BoxConstants.userId, claims['user_id']);
    await writeIfPresent(BoxConstants.username, claims['username']);
    await writeIfPresent(BoxConstants.userEmail, claims['email']);
    await writeIfPresent(BoxConstants.tenantId, claims['tenant_id']);
    await writeIfPresent(BoxConstants.tenantSlug, claims['tenant_slug']);
    await writeIfPresent(BoxConstants.tenantRole, claims['tenant_role']);

    final rawRoles = claims['roles'];
    if (rawRoles is List) {
      await _storage.write(
        BoxConstants.userRoles,
        rawRoles.whereType<String>().toList(),
      );
    }

    print(
      '[AuthService] persisted JWT claims -> '
      'tenant_id=${claims['tenant_id']}, '
      'tenant_slug=${claims['tenant_slug']}, '
      'tenant_role=${claims['tenant_role']}, '
      'user_id=${claims['user_id']}, '
      'username=${claims['username']}, '
      'roles=${claims['roles']}',
    );
    print(
      '[AuthService] BoxDB tenantId = '
      '${_storage.read<String>(BoxConstants.tenantId)}',
    );
  }

  /// Calls `POST /auth/revoke` when an access token exists, then clears local session.
  /// Local session is always cleared even if the revoke request fails.
  Future<Map<String, dynamic>?> logout() async {
    Map<String, dynamic>? revokeBody;
    Object? revokeError;
    final token = _storage.read<String>(BoxConstants.accessToken);
    if (token != null && token.isNotEmpty) {
      try {
        revokeBody = await _repository.revoke(RevokeTokenRequest(token: token));
      } catch (e) {
        revokeError = e;
        print('Logout revoke failed: $e');
      }
    }
    if (revokeBody != null) {
      print(const JsonEncoder.withIndent('  ').convert(revokeBody));
    } else if (token != null && token.isNotEmpty && revokeError == null) {
      print('Logout response: (empty or non-JSON body)');
    }
    await _clearLocalSession();
    return revokeBody;
  }

  Future<void> _clearLocalSession() async {
    await _storage.remove(BoxConstants.accessToken);
    await _storage.remove(BoxConstants.refreshToken);
    await _storage.remove(BoxConstants.tokenScope);
    await _storage.remove(BoxConstants.tokenExpiresAtMs);
    await _storage.remove(BoxConstants.loggedInEmail);
    await _storage.remove(BoxConstants.userId);
    await _storage.remove(BoxConstants.username);
    await _storage.remove(BoxConstants.userEmail);
    await _storage.remove(BoxConstants.userRoles);
    await _storage.remove(BoxConstants.tenantId);
    await _storage.remove(BoxConstants.tenantSlug);
    await _storage.remove(BoxConstants.tenantRole);
    await _storage.write(BoxConstants.isUserLoggedIn, false);
  }

  String? get accessToken => _storage.read<String>(BoxConstants.accessToken);

  /// Lowercased email from last successful login.
  String? get loggedInEmail =>
      _storage.read<String>(BoxConstants.loggedInEmail);

  /// Tenant id extracted from the access token payload (`tenant_id` claim).
  String? get tenantId => _storage.read<String>(BoxConstants.tenantId);

  /// Tenant slug from the access token payload (`tenant_slug` claim).
  String? get tenantSlug => _storage.read<String>(BoxConstants.tenantSlug);

  /// Tenant role from the access token payload (`tenant_role` claim).
  String? get tenantRole => _storage.read<String>(BoxConstants.tenantRole);

  /// User id from the access token payload (`user_id` claim).
  String? get userId => _storage.read<String>(BoxConstants.userId);

  /// Username from the access token payload (`username` claim).
  String? get username => _storage.read<String>(BoxConstants.username);

  /// Roles list from the access token payload (`roles` claim).
  List<String> get userRoles {
    final raw = _storage.read(BoxConstants.userRoles);
    if (raw is List) return raw.whereType<String>().toList();
    return const <String>[];
  }

  /// POST `/auth/introspect` with the stored access token.
  Future<IntrospectResponse> introspect() async {
    final token = _storage.read<String>(BoxConstants.accessToken);
    if (token == null || token.isEmpty) {
      throw StateError('No access token to introspect');
    }
    final response = await _repository.introspect(
      IntrospectRequest(token: token),
    );
    print(
      'introspect response: active=${response.active}, client_id=${response.clientId}, '
      'username=${response.username}, user_id=${response.userId}, scope=${response.scope}, '
      'exp=${response.exp}, iat=${response.iat}',
    );
    return response;
  }

  /// Clears stored tokens and login flag without calling `/auth/revoke`.
  Future<void> clearLocalSessionOnly() => _clearLocalSession();

  String messageForError(Object error) {
    if (error is ApiException) return error.message;
    if (error is JSONException) return error.message;
    return 'Something went wrong. Please try again.';
  }
}
