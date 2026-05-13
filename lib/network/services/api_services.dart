import 'package:flutter/foundation.dart'
    show
        TargetPlatform,
        debugPrint,
        debugPrintStack,
        defaultTargetPlatform,
        kIsWeb;
import 'package:get/get_connect.dart';
import 'package:get_storage/get_storage.dart';

import '../../log_catcher/logs.dart';
import '../../shared/constants/box_constants.dart';
import '../../shared/utils/app_exceptions.dart';

/// HTTP verbs for [ApiServices.callApi] (CoffeeWeb-style).
enum HttpMethod { get, post, put, delete, patch }

/// [Get.find] tags for the two HTTP clients (auth vs data-management hosts).
abstract final class ApiServicesTag {
  ApiServicesTag._();

  static const auth = 'api_auth';
  static const dataManagement = 'api_data_management';
}

/// Shared HTTP layer: GetConnect + [callApi], auth header, single entry for REST.
///
/// Each instance is pinned to one API host; use [ApiServicesTag] when calling
/// [Get.find].
///
/// Request/response logging follows CoffeeWeb-App `Logs.apiRequestLogger` /
/// `Logs.apiResponseLogger` (see CoffeeWeb-App `docs/console_request_response_logging.md`):
/// `dart:developer` [log] with [name] `Recrip APP` / `API SERVICE`, JSON with
/// single-space indent, and [error] on non-success HTTP status. Login
/// `password` fields in JSON bodies are redacted; tokens and Authorization
/// values are logged in full.
class ApiServices extends GetConnect {
  ApiServices(String rootUrl)
    : _rootUrl = rootUrl.replaceAll(RegExp(r'/+$'), '');

  final String _rootUrl;

  @override
  void onInit() {
    super.onInit();
    baseUrl = _rootUrl;
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
    final token = GetStorage().read<String>(BoxConstants.accessToken);
    Logs.apiGetConnectRequestLogger(
      verb: verb,
      fullUrl: fullUrl,
      callerHeaders: headers,
      query: query,
      body: body,
      bearerToken: token,
    );

    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        (fullUrl.contains('localhost') || fullUrl.contains('127.0.0.1'))) {
      debugPrint(
        '[ApiServices] Android emulator: localhost/127.0.0.1 is the emulator itself, '
        'not your computer. Use http://10.0.2.2:PORT (or your LAN IP) for a server on the host.',
      );
    }

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
              .post<dynamic>(path, body: body, query: query, headers: headers)
              .timeout(timeout);
          break;
        case HttpMethod.put:
          response = await httpClient
              .put<dynamic>(path, body: body, query: query, headers: headers)
              .timeout(timeout);
          break;
        case HttpMethod.delete:
          response = await httpClient
              .delete<dynamic>(path, query: query, headers: headers)
              .timeout(timeout);
          break;
        case HttpMethod.patch:
          response = await httpClient
              .patch<dynamic>(path, body: body, query: query, headers: headers)
              .timeout(timeout);
          break;
      }
    } on Object catch (e, st) {
      if (e is ApiException) rethrow;
      debugPrint('[ApiServices] $verb $path failed: $e');
      debugPrintStack(stackTrace: st);
      throw ApiException('$verb $path failed: $e', statusCode: null);
    }

    final st = response.statusText?.trim();
    if (response.statusCode == null) {
      debugPrint(
        '[ApiServices] $verb $path → no HTTP status (connection failed). '
        'statusText=${st ?? '(empty)'}',
      );
      if (kIsWeb && (st?.toLowerCase().contains('xmlhttprequest') ?? false)) {
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
    }

    Logs.apiGetConnectResponseLogger(
      verb: verb,
      fullUrl: fullUrl,
      query: query,
      response: response,
    );

    if (!response.isOk) {
      ErrorHandler.throwForResponse(response);
    }
    return response;
  }
}
