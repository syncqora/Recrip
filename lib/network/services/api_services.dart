import 'package:get/get.dart';
import 'package:get/get_connect.dart';
import 'package:get_storage/get_storage.dart';

import '../../shared/constants/box_constants.dart';
import '../../shared/utils/app_exceptions.dart';
import 'api_end_points.dart';

/// HTTP verbs for [ApiServices.callApi] (CoffeeWeb-style).
enum HttpMethod { get, post, put, delete, patch }

/// Shared HTTP layer: GetConnect + [callApi], auth header, single entry for REST.
class ApiServices extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    baseUrl = ApiEndPoints.baseUrl.replaceAll(RegExp(r'/+$'), '');
    timeout = const Duration(seconds: 30);
    defaultContentType = 'application/json';

    httpClient.addRequestModifier<dynamic>((request) async {
      final token = GetStorage().read<String>(BoxConstants.accessToken);
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    // TODO: on 401, refresh token + retry (see CoffeeWeb `ApiServices` authenticator).
  }

  /// Primary REST entry point. On failure throws [ApiException] via [ErrorHandler].
  Future<Response<dynamic>> callApi({
    required HttpMethod httpMethod,
    required String endPoint,
    Map<String, dynamic>? query,
    dynamic body,
  }) async {
    final path = endPoint.startsWith('/') ? endPoint : '/$endPoint';
    late Response<dynamic> response;
    switch (httpMethod) {
      case HttpMethod.get:
        response = await get<dynamic>(path, query: query);
        break;
      case HttpMethod.post:
        response = await post<dynamic>(path, body, query: query);
        break;
      case HttpMethod.put:
        response = await put<dynamic>(path, body, query: query);
        break;
      case HttpMethod.delete:
        response = await delete<dynamic>(path, query: query);
        break;
      case HttpMethod.patch:
        response = await patch<dynamic>(path, body, query: query);
        break;
    }

    if (!response.isOk) {
      ErrorHandler.throwForResponse(response);
    }
    return response;
  }
}
