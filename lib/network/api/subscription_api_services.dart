import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/models/subscription/subscription_schema_models.dart';
import '../../shared/constants/box_constants.dart';
import '../../shared/utils/app_exceptions.dart';
import '../../shared/utils/tracking_id.dart';
import '../endPoints/end_points.dart';
import '../services/services.dart';

/// Reads the tenant id persisted at login time from the JWT payload.
String _tenantId() => GetStorage().read<String>(BoxConstants.tenantId) ?? '';

/// Subscription / asset schema API.
///
/// On **Flutter web**, these headers trigger a CORS preflight. If login works but this
/// call shows `XMLHttpRequest error`, your API likely allows `Content-Type` on `/auth/login`
/// but does not list `Authorization` and custom headers in
/// `Access-Control-Allow-Headers` for `/schema/*` (or global OPTIONS). Fix CORS on the
/// server or use `tool/web_cors_proxy.dart` with `--dart-define=API_BASE_URL=…`.
class SubscriptionServices {
  Future<SubscriptionSchemaResponse> getSubscriptionSchema() async {
    debugPrint('[SubscriptionSchema] getSubscriptionSchema() start');
    final ApiServices api = Get.find<ApiServices>(
      tag: ApiServicesTag.dataManagement,
    );
    final headers = <String, String>{
      'X-Tenant-Id': _tenantId(),
      'X-Tracking-Id': newTrackingId(),
    };

    debugPrint(
      '[SubscriptionSchema] calling callApi GET ${SubscriptionEndPoints.schemaSubscription}',
    );
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
    final ApiServices api = Get.find<ApiServices>(
      tag: ApiServicesTag.dataManagement,
    );
    final headers = <String, String>{
      'X-Tenant-Id': _tenantId(),
      'X-Tracking-Id': newTrackingId(),
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

  /// POST `/content/asset/subscription` — creates a subscription content asset.
  ///
  /// Headers: `Authorization` (via [ApiServices]), `X-Tenant-Id`, `X-Client-Id`,
  /// `Content-Type`.
  Future<SubscriptionAsset?> createSubscription({
    required Map<String, dynamic> body,
  }) async {
    debugPrint('[SubscriptionCreate] createSubscription() start');
    final ApiServices api = Get.find<ApiServices>(
      tag: ApiServicesTag.dataManagement,
    );
    final headers = <String, String>{
      'X-Tenant-Id': _tenantId(),
      'X-Client-Id': ApiEndPoints.clientId,
      'Content-Type': 'application/json',
    };

    final Response<dynamic> res = await api.callApi(
      httpMethod: HttpMethod.post,
      endPoint: SubscriptionEndPoints.contentSubscription,
      headers: headers,
      body: body,
    );
    debugPrint(
      '[SubscriptionCreate] status=${res.statusCode} bodyString=\n${res.bodyString}',
    );

    final raw = res.bodyString;
    Map<String, dynamic>? map;
    final responseBody = res.body;
    if (responseBody is Map<String, dynamic>) {
      map = responseBody;
    } else if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        map = decoded;
      }
    }
    if (map == null) {
      return null;
    }
    final parsed = SubscriptionSchemaResponse.fromJson(map);
    if (parsed.items.isNotEmpty) {
      return parsed.items.first;
    }
    final data = map['data'];
    if (data is Map<String, dynamic>) {
      return SubscriptionAsset.fromJson(data);
    }
    return null;
  }
}
