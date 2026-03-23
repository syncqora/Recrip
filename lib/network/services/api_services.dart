import 'package:flutter/foundation.dart'
    show TargetPlatform, debugPrint, debugPrintStack, defaultTargetPlatform, kIsWeb;
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

    httpClient.addRequestModifier<dynamic>((request) {
      final token = GetStorage().read<String>(BoxConstants.accessToken);
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    // TODO: on 401, refresh token + retry (see CoffeeWeb `ApiServices` authenticator).
  }

  /// Primary REST entry point. On failure throws [ApiException] via [ErrorHandler].
  /// [headers] are merged per request (e.g. `X-Tenant-Id`, `X-Tracking-Id`).
  Future<Response<dynamic>> callApi({
    required HttpMethod httpMethod,
    required String endPoint,
    Map<String, dynamic>? query,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final path = endPoint.startsWith('/') ? endPoint : '/$endPoint';
    final verb = httpMethod.name.toUpperCase();
    final fullUrl = '${baseUrl ?? ''}$path';
    debugPrint('[ApiServices] $verb $fullUrl (timeout ${timeout.inSeconds}s)');
    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        (fullUrl.contains('localhost') || fullUrl.contains('127.0.0.1'))) {
      debugPrint(
        '[ApiServices] Android emulator: localhost/127.0.0.1 is the emulator itself, '
        'not your computer. Use http://10.0.2.2:PORT (or your LAN IP) for a server on the host.',
      );
    }

    // GetX only times out the body pipe on IO, not [HttpClient.openUrl] — a stuck
    // TCP connect can hang forever. Always cap the whole request.
    late Response<dynamic> response;
    try {
      switch (httpMethod) {
        case HttpMethod.get:
          response = await httpClient
              .get<dynamic>(path, query: query, headers: headers)
              .timeout(timeout);
          break;
        case HttpMethod.post:
          response = await httpClient
              .post<dynamic>(
                path,
                body: body,
                query: query,
                headers: headers,
              )
              .timeout(timeout);
          break;
        case HttpMethod.put:
          response = await httpClient
              .put<dynamic>(
                path,
                body: body,
                query: query,
                headers: headers,
              )
              .timeout(timeout);
          break;
        case HttpMethod.delete:
          response = await httpClient
              .delete<dynamic>(path, query: query, headers: headers)
              .timeout(timeout);
          break;
        case HttpMethod.patch:
          response = await httpClient
              .patch<dynamic>(
                path,
                body: body,
                query: query,
                headers: headers,
              )
              .timeout(timeout);
          break;
      }
    } on Object catch (e, st) {
      if (e is ApiException) rethrow;
      debugPrint('[ApiServices] $verb $path failed: $e');
      debugPrintStack(stackTrace: st);
      throw ApiException(
        '$verb $path failed: $e',
        statusCode: null,
      );
    }

    final st = response.statusText?.trim();
    if (response.statusCode == null) {
      debugPrint(
        '[ApiServices] $verb $path → no HTTP status (connection failed). '
        'statusText=${st ?? '(empty)'}',
      );
      if (kIsWeb &&
          (st?.toLowerCase().contains('xmlhttprequest') ?? false)) {
        debugPrint(
          '[ApiServices] Flutter web: browser blocked the call (almost always CORS). '
          'The server at $baseUrl must answer OPTIONS preflight with e.g. '
          'Access-Control-Allow-Origin (your app origin or * in dev), '
          'Access-Control-Allow-Methods including GET, '
          'Access-Control-Allow-Headers listing every header this request sends. '
          'Login often works on the same port because the first request may only send '
          'Content-Type (no token yet). Subscription also sends Authorization, '
          'X-Tenant-Id, X-Tracking-Id, and X-Client-Id — those names must appear in '
          'Access-Control-Allow-Headers for /schema/... (many backends only whitelist '
          'headers for /auth/*). Or use tool/web_cors_proxy.dart + --dart-define=API_BASE_URL=…',
        );
      }
    } else {
      debugPrint('[ApiServices] $verb $path → status=${response.statusCode}');
    }
    if (!response.isOk) {
      ErrorHandler.throwForResponse(response);
    }
    return response;
  }
}
