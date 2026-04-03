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
  }

  /// Calls `POST /auth/revoke` when an access token exists, then clears local session.
  /// Local session is always cleared even if the revoke request fails.
  Future<Map<String, dynamic>?> logout() async {
    Map<String, dynamic>? revokeBody;
    Object? revokeError;
    final token = _storage.read<String>(BoxConstants.accessToken);
    if (token != null && token.isNotEmpty) {
      try {
        revokeBody = await _repository.revoke(
          RevokeTokenRequest(token: token),
        );
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
    await _storage.write(BoxConstants.isUserLoggedIn, false);
  }

  String? get accessToken => _storage.read<String>(BoxConstants.accessToken);

  /// Lowercased email from last successful login; used for admin vs member routing.
  String? get loggedInEmail => _storage.read<String>(BoxConstants.loggedInEmail);

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
