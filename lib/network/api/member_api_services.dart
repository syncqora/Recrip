import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/models/member/member_schema_models.dart';
import '../../shared/utils/app_exceptions.dart';
import '../../shared/utils/tracking_id.dart';
import '../endPoints/end_points.dart';
import '../services/services.dart';

class MemberServices {
  Future<MemberSchemaResponse> getMemberSchema() async {
    debugPrint('[MemberSchema] getMemberSchema() start');
    final ApiServices api =
        Get.find<ApiServices>(tag: ApiServicesTag.dataManagement);
    final headers = <String, String>{
      'X-Tracking-Id': newTrackingId(),
      'X-Tenant-Id': ApiEndPoints.tenantId,
    };

    final Response<dynamic> res = await api.callApi(
      httpMethod: HttpMethod.get,
      endPoint: MemberEndPoints.schemaMember,
      headers: headers,
    );

    try {
      final raw = res.bodyString;
      Map<String, dynamic>? map;
      final body = res.body;
      if (body is Map<String, dynamic>) {
        map = body;
      } else if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) map = decoded;
      }
      if (map == null) {
        throw JSONException('Invalid member schema response');
      }
      return MemberSchemaResponse.fromJson(map);
    } on JSONException {
      rethrow;
    } on FormatException catch (e) {
      throw JSONException(e.message);
    } catch (e) {
      if (e is ApiException || e is JSONException) rethrow;
      throw JSONException(e.toString());
    }
  }

  Future<MemberSchemaResponse> getMembers({
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    debugPrint(
      '[MemberContent] getMembers() start pageNumber=$pageNumber pageSize=$pageSize',
    );
    final ApiServices api =
        Get.find<ApiServices>(tag: ApiServicesTag.dataManagement);
    final headers = <String, String>{
      'X-Tracking-Id': newTrackingId(),
      'X-Tenant-Id': ApiEndPoints.tenantId,
      'X-Client-Id': ApiEndPoints.clientId,
    };
    final query = <String, dynamic>{
      'pageNumber': '$pageNumber',
      'pageSize': '$pageSize',
    };

    final Response<dynamic> res = await api.callApi(
      httpMethod: HttpMethod.get,
      endPoint: MemberEndPoints.contentMember,
      headers: headers,
      query: query,
    );

    try {
      final raw = res.bodyString;
      Map<String, dynamic>? map;
      final body = res.body;
      if (body is Map<String, dynamic>) {
        map = body;
      } else if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) map = decoded;
      }
      if (map == null) {
        throw JSONException('Invalid member content response');
      }
      return MemberSchemaResponse.fromJson(map);
    } on JSONException {
      rethrow;
    } on FormatException catch (e) {
      throw JSONException(e.message);
    } catch (e) {
      if (e is ApiException || e is JSONException) rethrow;
      throw JSONException(e.toString());
    }
  }
}
