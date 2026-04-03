import 'dart:convert';

import 'package:get/get.dart';

import '../../core/models/auth/login_request.dart';
import '../../core/models/auth/login_response.dart';
import '../../core/models/auth/introspect_request.dart';
import '../../core/models/auth/introspect_response.dart';
import '../../core/models/auth/revoke_token_request.dart';
import '../../shared/utils/app_exceptions.dart';
import '../endPoints/end_points.dart';
import '../services/services.dart';

/// Feature API: builds endpoint, calls [ApiServices], maps JSON → models.
class AuthServices {
  Future<LoginResponse> login(LoginRequest request) async {
    final ApiServices api = Get.find<ApiServices>(tag: ApiServicesTag.auth);
    final Response<dynamic> res = await api.callApi(
      httpMethod: HttpMethod.post,
      endPoint: AuthEndPoints.login,
      body: request.toJson(),
    );

    try {
      final body = res.body;
      Map<String, dynamic>? map;
      if (body is Map<String, dynamic>) {
        map = body;
      } else {
        final s = res.bodyString;
        if (s != null && s.isNotEmpty) {
          final decoded = jsonDecode(s);
          if (decoded is Map<String, dynamic>) map = decoded;
        }
      }
      if (map == null) {
        throw JSONException('Invalid login response');
      }
      return LoginResponse.fromJson(map);
    } on JSONException {
      rethrow;
    } on FormatException catch (e) {
      throw JSONException(e.message);
    } catch (e) {
      if (e is ApiException || e is JSONException) rethrow;
      throw JSONException(e.toString());
    }
  }

  /// POST `/auth/revoke` — returns parsed JSON body if present, otherwise `null`.
  Future<Map<String, dynamic>?> revoke(RevokeTokenRequest request) async {
    final ApiServices api = Get.find<ApiServices>(tag: ApiServicesTag.auth);
    final Response<dynamic> res = await api.callApi(
      httpMethod: HttpMethod.post,
      endPoint: AuthEndPoints.revoke,
      body: request.toJson(),
    );

    try {
      final body = res.body;
      if (body is Map<String, dynamic>) return body;
      final s = res.bodyString;
      if (s != null && s.isNotEmpty) {
        final decoded = jsonDecode(s);
        if (decoded is Map<String, dynamic>) return decoded;
      }
      return null;
    } on FormatException catch (e) {
      throw JSONException(e.message);
    }
  }

  /// POST `/auth/introspect` — whether the access token is still active.
  Future<IntrospectResponse> introspect(IntrospectRequest request) async {
    final ApiServices api = Get.find<ApiServices>(tag: ApiServicesTag.auth);
    final Response<dynamic> res = await api.callApi(
      httpMethod: HttpMethod.post,
      endPoint: AuthEndPoints.introspect,
      body: request.toJson(),
    );

    try {
      Map<String, dynamic>? map;
      final body = res.body;
      if (body is Map<String, dynamic>) {
        map = body;
      } else {
        final s = res.bodyString;
        if (s != null && s.isNotEmpty) {
          final decoded = jsonDecode(s);
          if (decoded is Map<String, dynamic>) map = decoded;
        }
      }
      if (map == null) {
        throw JSONException('Invalid introspect response');
      }
      return IntrospectResponse.fromJson(map);
    } on FormatException catch (e) {
      throw JSONException(e.message);
    }
  }
}
