import 'dart:convert';

import 'package:get/get.dart';

import '../../core/models/admin/admin_user_response_model.dart';
import '../../core/models/admin/create_admin_user_request.dart';
import '../../core/models/admin/create_tenant_request.dart';
import '../../core/models/admin/link_tenant_user_request.dart';
import '../../core/models/admin/tenant_response_model.dart';
import '../../shared/utils/app_exceptions.dart';
import '../endPoints/end_points.dart';
import '../services/services.dart';

/// Super-admin platform APIs: tenants, users, tenant membership.
class AdminPlatformServices {
  /// Creates a tenant via `POST /api/tenants`.
  Future<TenantResponseModel> createTenant(CreateTenantRequest request) async {
    final ApiServices api = Get.find<ApiServices>(tag: ApiServicesTag.auth);
    final Response<dynamic> res = await api.callApi(
      httpMethod: HttpMethod.post,
      endPoint: AdminPlatformEndPoints.tenants,
      body: request.toJson(),
    );
    final map = _bodyAsMap(res);
    if (map == null) {
      throw JSONException('Invalid create tenant response');
    }
    return TenantResponseModel.fromJson(map);
  }

  /// Creates a user via `POST /api/users`.
  Future<AdminUserResponseModel> createUser(
    CreateAdminUserRequest request,
  ) async {
    final ApiServices api = Get.find<ApiServices>(tag: ApiServicesTag.auth);
    final Response<dynamic> res = await api.callApi(
      httpMethod: HttpMethod.post,
      endPoint: AdminPlatformEndPoints.users,
      body: request.toJson(),
    );
    final map = _bodyAsMap(res);
    if (map == null) {
      throw JSONException('Invalid create user response');
    }
    return AdminUserResponseModel.fromJson(map);
  }

  /// Links a user to a tenant with a role via `POST /api/tenants/{id}/users`.
  Future<void> linkTenantUser({
    required String tenantId,
    required LinkTenantUserRequest request,
  }) async {
    final ApiServices api = Get.find<ApiServices>(tag: ApiServicesTag.auth);
    await api.callApi(
      httpMethod: HttpMethod.post,
      endPoint: AdminPlatformEndPoints.tenantUsers(tenantId),
      body: request.toJson(),
    );
  }

  static Map<String, dynamic>? _bodyAsMap(Response<dynamic> res) {
    try {
      final body = res.body;
      if (body is Map<String, dynamic>) return body;
      if (body is Map) return Map<String, dynamic>.from(body);
      final s = res.bodyString;
      if (s != null && s.isNotEmpty) {
        final decoded = jsonDecode(s);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      }
    } on FormatException catch (e) {
      throw JSONException(e.message);
    } catch (_) {}
    return null;
  }
}
