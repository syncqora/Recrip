import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/models/subscription/subscription_schema_models.dart';
import '../../shared/utils/app_exceptions.dart';
import '../../shared/utils/tracking_id.dart';
import '../endPoints/end_points.dart';
import '../services/services.dart';

/// Subscription / asset schema API (GET with tenant + tracking headers).
///
/// On **Flutter web**, these headers trigger a CORS preflight. If login works but this
/// call shows `XMLHttpRequest error`, your API likely allows `Content-Type` on `/auth/login`
/// but does not list `Authorization`, `X-Tenant-Id`, and `X-Tracking-Id` in
/// `Access-Control-Allow-Headers` for `/schema/*` (or global OPTIONS). Fix CORS on the
/// server or use `tool/web_cors_proxy.dart` with `--dart-define=API_BASE_URL=…`.
class SubscriptionServices {
  Future<SubscriptionSchemaResponse> getSubscriptionSchema() async {
    debugPrint('[SubscriptionSchema] getSubscriptionSchema() start');
    final ApiServices api = Get.find<ApiServices>();
    final headers = <String, String>{
      'X-Tracking-Id': newTrackingId(),
      'X-Tenant-Id': ApiEndPoints.tenantId,
    };

    debugPrint('[SubscriptionSchema] calling callApi GET ${SubscriptionEndPoints.schemaSubscription}');
    final Response<dynamic> res = await api.callApi(
      httpMethod: HttpMethod.get,
      endPoint: SubscriptionEndPoints.schemaSubscription,
      headers: headers,
    );

    try {
      final raw = res.bodyString;
      debugPrint(
        '[SubscriptionSchema] raw status=${res.statusCode} bodyString=\n$raw',
      );

      Map<String, dynamic>? map;
      final body = res.body;
      if (body is Map<String, dynamic>) {
        map = body;
      } else if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) map = decoded;
      }
      if (map == null) {
        throw JSONException('Invalid subscription schema response');
      }
      final pretty = const JsonEncoder.withIndent('  ').convert(map);
      debugPrint('[SubscriptionSchema] parsed JSON:\n$pretty');
      return SubscriptionSchemaResponse.fromJson(map);
    } on JSONException {
      rethrow;
    } on FormatException catch (e) {
      throw JSONException(e.message);
    } catch (e) {
      if (e is ApiException || e is JSONException) rethrow;
      throw JSONException(e.toString());
    }
  }

  /// GET `/content/asset/subscription?pageNumber=1&pageSize=20`
  /// Returns subscription list rows after schema check.
  Future<SubscriptionSchemaResponse> getSubscriptions({
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    debugPrint(
      '[SubscriptionContent] getSubscriptions() start pageNumber=$pageNumber pageSize=$pageSize',
    );
    final ApiServices api = Get.find<ApiServices>();
    final headers = <String, String>{
      'X-Tracking-Id': newTrackingId(),
      'X-Tenant-Id': ApiEndPoints.tenantId,
      'X-Client-Id': ApiEndPoints.clientId,
    };
    final query = <String, dynamic>{
      // GetConnect query encoder is safer with string values.
      'pageNumber': '$pageNumber',
      'pageSize': '$pageSize',
    };

    debugPrint(
      '[SubscriptionContent] calling callApi GET ${SubscriptionEndPoints.contentSubscription}',
    );
    final Response<dynamic> res = await api.callApi(
      httpMethod: HttpMethod.get,
      endPoint: SubscriptionEndPoints.contentSubscription,
      headers: headers,
      query: query,
    );

    try {
      final raw = res.bodyString;
      debugPrint(
        '[SubscriptionContent] raw status=${res.statusCode} bodyString=\n$raw',
      );

      Map<String, dynamic>? map;
      final body = res.body;
      if (body is Map<String, dynamic>) {
        map = body;
      } else if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) map = decoded;
      }
      if (map == null) {
        throw JSONException('Invalid subscription content response');
      }
      final pretty = const JsonEncoder.withIndent('  ').convert(map);
      debugPrint('[SubscriptionContent] parsed JSON:\n$pretty');
      return SubscriptionSchemaResponse.fromJson(map);
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
