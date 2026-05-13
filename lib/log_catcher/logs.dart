import 'dart:convert';
import 'dart:developer';

import 'package:get/get_connect.dart';
import 'package:saas/shared/utils/jwt_utils.dart';

class Logs {
  static const _banner =
      '=====================================================================';
  static const _appLogName = 'Recrip APP';
  static const _apiLogName = 'API SERVICE';
  static const _authLogName = 'Recrip AUTH';

  /// Same indent style as CoffeeWeb-App `Logs._safeJsonEncode` (single space).
  /// Only obvious secrets (e.g. login `password`) are redacted; tokens are left visible.
  static String _safeJsonEncode(dynamic value) {
    try {
      return const JsonEncoder.withIndent(' ').convert(_redactForApiLog(value));
    } catch (_) {
      return value?.toString() ?? 'null';
    }
  }

  static dynamic _redactForApiLog(dynamic value) {
    if (value is Map) {
      final out = <String, dynamic>{};
      for (final MapEntry(:key, :value) in value.entries) {
        final k = key.toString();
        if (k == 'password' ||
            k == 'old_password' ||
            k == 'new_password' ||
            k == 'secret') {
          out[k] = '***';
        } else {
          out[k] = _redactForApiLog(value);
        }
      }
      return out;
    }
    if (value is List) {
      return value.map(_redactForApiLog).toList();
    }
    return value;
  }

  static bool _httpFailed(int? code) {
    if (code == null) return false;
    return code < 200 || code >= 300;
  }

  static Map<String, dynamic> _bodyMapForLog(dynamic body) {
    if (body == null) return {};
    if (body is Map) return Map<String, dynamic>.from(body);
    if (body is String) {
      final t = body.trim();
      if (t.isEmpty) return {};
      try {
        final decoded = jsonDecode(t);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
        if (decoded is List) return {'_json': decoded};
      } catch (_) {
        return {'_raw': t};
      }
    }
    return {'_value': body.toString()};
  }

  /// Console blocks aligned with CoffeeWeb-App `Logs.apiRequestLogger`
  /// (`docs/console_request_response_logging.md`): banner, URL, headers, body.
  ///
  /// [bearerToken] is logged in full as `Authorization: Bearer <token>` when set
  /// and the caller did not already supply an Authorization header.
  static void apiGetConnectRequestLogger({
    required String verb,
    required String fullUrl,
    Map<String, String>? callerHeaders,
    Map<String, dynamic>? query,
    dynamic body,
    String? bearerToken,
  }) {
    final urlWithQuery = _urlWithQuery(fullUrl, query);
    final headers = <String, Object?>{'Content-Type': 'application/json'};
    if (callerHeaders != null) {
      for (final e in callerHeaders.entries) {
        headers[e.key] = e.value;
      }
    }
    if (bearerToken != null &&
        bearerToken.isNotEmpty &&
        !headers.keys.any((k) => k.toLowerCase() == 'authorization')) {
      headers['Authorization'] = 'Bearer $bearerToken';
    }
    final requestBody = _bodyMapForLog(body);

    log(_banner, name: _appLogName);
    log(
      '\n$verb $urlWithQuery\nRequest Header\n${_safeJsonEncode(headers)}\nRequest Body\n${_safeJsonEncode(requestBody)}',
      time: DateTime.now(),
      name: _apiLogName,
    );
    log(_banner, name: _appLogName);
  }

  /// Logs raw tokens and decoded JWT payload after a successful login (debug only).
  static void logPostLoginTokensAndJwtPayload({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
    required String scope,
  }) {
    final claims = JwtUtils.decodePayload(accessToken);
    final claimsText = claims.isEmpty
        ? '(empty — token could not be decoded)'
        : const JsonEncoder.withIndent(' ').convert(claims);

    log(_banner, name: _appLogName);
    log(
      '\nSession (after login)\n'
      'access_token\n$accessToken\n'
      'refresh_token\n$refreshToken\n'
      'token_type\n$tokenType\n'
      'expires_in\n$expiresIn\n'
      'scope\n$scope\n'
      'JWT payload (decoded only, not verified)\n$claimsText',
      time: DateTime.now(),
      name: _authLogName,
    );
    log(_banner, name: _appLogName);
  }

  /// Same pattern as CoffeeWeb-App `Logs.apiResponseLogger`.
  static void apiGetConnectResponseLogger({
    required String verb,
    required String fullUrl,
    Map<String, dynamic>? query,
    required Response<dynamic> response,
  }) {
    final code = response.statusCode;
    final raw = response.bodyString;
    final hasBody = raw != null && raw.trim().isNotEmpty;
    final hasDecodedBody = response.body != null;

    final statusText = response.statusText?.trim() ?? '';
    final hasError = !response.isOk || _httpFailed(code);
    final logUrl = _urlWithQuery(fullUrl, query);
    dynamic responseBody;
    if (hasBody) {
      final trimmed = raw.trim();
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        try {
          responseBody = jsonDecode(trimmed);
        } catch (_) {
          responseBody = trimmed;
        }
      } else {
        responseBody = trimmed;
      }
    } else if (hasDecodedBody) {
      responseBody = response.body;
    } else {
      responseBody = {};
    }

    log(_banner, name: _appLogName);
    if (hasError) {
      log(
        '\n$verb $logUrl\nResponse Body\n${_safeJsonEncode(responseBody)}',
        name: _apiLogName,
        time: DateTime.now(),
        error: 'ERROR :  ${code?.toString() ?? 'null'} -  $statusText',
      );
    } else {
      log(
        '\n$verb $logUrl\nResponse Body\n${_safeJsonEncode(responseBody)}',
        time: DateTime.now(),
        name: _apiLogName,
      );
    }
    log(_banner, name: _appLogName);
  }

  static String _urlWithQuery(String fullUrl, Map<String, dynamic>? query) {
    if (query == null || query.isEmpty) return fullUrl;
    final flat = <String, String>{};
    for (final e in query.entries) {
      flat[e.key] = e.value?.toString() ?? '';
    }
    final q = Uri(queryParameters: flat).query;
    if (q.isEmpty) return fullUrl;
    return fullUrl.contains('?') ? '$fullUrl&$q' : '$fullUrl?$q';
  }

  // static void appErrorLogger({
  //   Object? error,
  //   StackTrace? stackTrace,
  //   required SwaggerDataCategory swaggerDataCategory,
  //   FlutterErrorDetails? flutterErrorDetails,
  // }) {
  //   if (swaggerDataCategory == SwaggerDataCategory.flutterError) {
  //     Get.find<MiniSwaggerController>().addDataToRecords(
  //       MiniSwaggerFlutterErrorModel(flutterErrorDetails: flutterErrorDetails),
  //     );
  //     log("FlutterErrorLogger");
  //     log("error: $flutterErrorDetails");
  //     log("");
  //     log("");
  //   } else {
  //     Get.find<MiniSwaggerController>().addDataToRecords(
  //       MiniSwaggerAppErrorModel(
  //         category: swaggerDataCategory,
  //         stackTrace: stackTrace,
  //         error: error,
  //       ),
  //     );
  //     log("ZoneGuardErrorLogger");
  //     log("error: $error");
  //     log("stack: $stackTrace");
  //     log("");
  //     log("");
  //   }
  // }

  // static void screenControllerAPIErrorLogger({
  //   required String controllerName,
  //   required String apiEndPoint,
  //   required String error,
  //   required StackTrace stackTrace,
  // }) {
  //   Get.find<MiniSwaggerController>().addDataToRecords(
  //     MiniSwaggerAppErrorModel(
  //       error: error,
  //       category: SwaggerDataCategory.apiDataError,
  //       stackTrace: stackTrace,
  //     ),
  //   );
  //   log(
  //     "Controller: ${controllerName.toUpperCase()} \nAPI Endpoint: $apiEndPoint\n$stackTrace",
  //     error: error,
  //   );
  //   log("");
  //   log("");
  // }

  // static Future<void> apiRequestLogger({required APIModel apiModel}) async {
  //   final headers = apiModel.request?.headers ?? {};
  //   final requestBody = apiModel.requestBody ?? {};
  //   final requestMethod = apiModel.request?.method ?? "Unknown";
  //   log(
  //     "=====================================================================",
  //     name: "Coffee Web APP",
  //   );
  //   log(
  //     "\n${apiModel.url}\nRequest Header\n${const JsonEncoder.withIndent(' ').convert(headers)}\nRequest Body\n${const JsonEncoder.withIndent(' ').convert(requestBody)}",
  //     time: DateTime.now(),
  //     name: "API SERVICE",
  //   );
  //   log(
  //     "=====================================================================",
  //     name: "Coffee Web APP",
  //   );
  //   Get.find<MiniSwaggerController>().addDataToRecords(
  //     MiniSwaggerAPIServiceModel(
  //       category: SwaggerDataCategory.apiService,
  //       signalStrength: "0",
  //       internetSpeed: "",
  //       url: apiModel.url,
  //       requestBody: const JsonEncoder.withIndent(' ').convert(requestBody),
  //       requestHeader: const JsonEncoder.withIndent(' ').convert(headers),
  //       requestMethod: requestMethod,
  //       statusCode: 0,
  //       statusText: "",
  //       responseBody: null,
  //       requestTime: DateTime.now(),
  //       responseTime: null,
  //       isError: false,
  //       jsonParsingError: null,
  //     ),
  //   );
  // }

  // static Future<void> apiResponseLogger({required APIModel apiModel}) async {
  //   if (apiModel.response == null) return;
  //
  //   final bool hasError = apiModel.response!.hasError;
  //   final statusCode = apiModel.response!.statusCode;
  //   final statusText = apiModel.response!.statusText;
  //   final responseBody = apiModel.response!.body ?? {};
  //
  //   if (hasError) {
  //     // Log error details in the response
  //     log(
  //       "=====================================================================",
  //       name: "Coffee Web APP",
  //     );
  //     log(
  //       "\n${apiModel.response!.request!.url}\nResponse Body\n${const JsonEncoder.withIndent(' ').convert(responseBody)}",
  //       name: "API SERVICE",
  //       time: DateTime.now(),
  //       error: "ERROR :  ${statusCode.toString()} -  ${statusText}",
  //     );
  //     log(
  //       "=====================================================================",
  //       name: "Coffee Web APP",
  //     );
  //   } else {
  //     // Log successful response details
  //     log(
  //       "=====================================================================",
  //       name: "Coffee Web APP",
  //     );
  //     log(
  //       "\n${apiModel.response!.request!.url}\nResponse Body\n${const JsonEncoder.withIndent(' ').convert(responseBody)}",
  //       time: DateTime.now(),
  //       name: "API SERVICE",
  //     );
  //     log(
  //       "=====================================================================",
  //       name: "Coffee Web APP",
  //     );
  //   }
  //   Get.find<MiniSwaggerController>().addDataToRecords(
  //     MiniSwaggerAPIServiceModel(
  //       category: SwaggerDataCategory.apiService,
  //       signalStrength: null,
  //       internetSpeed: "",
  //       // Add internet speed if applicable
  //       url: apiModel.url,
  //       requestBody: null,
  //       requestHeader: null,
  //       requestMethod: apiModel.request?.method ?? "",
  //       //responseRequestBody: null,
  //       statusCode: statusCode,
  //       statusText: "",
  //       responseBody: const JsonEncoder.withIndent(' ').convert(responseBody),
  //       requestTime: null,
  //       responseTime: DateTime.now(),
  //       isError: hasError || apiModel.jsonParsingError != null,
  //       jsonParsingError: apiModel.jsonParsingError,
  //     ),
  //   );
  // }

  // static void apiJsonParseErrorLogger({required APIModel apiModel}) {
  //   _addToMiniSwagger(apiModel);
  // }

  // static void responseLogger(APIModel apiModel) {
  //   log(
  //     "=====================================================================",
  //     name: "Coffee Web APP",
  //   );
  //   log(
  //     "\n${apiModel.response!.request!.url}\nResponse Body\n${const JsonEncoder.withIndent(' ').convert(apiModel.response!.body)}",
  //     time: DateTime.now(),
  //     name: "API SERVICE",
  //   );
  //   log(
  //     "=====================================================================",
  //     name: "Coffee Web APP",
  //   );
  // }

  // static void _addToMiniSwagger(APIModel apiModel) {
  //   Get.find<MiniSwaggerController>().addDataToRecords(
  //     MiniSwaggerAPIServiceModel(
  //       category: SwaggerDataCategory.remoteService,
  //       signalStrength: null,
  //       internetSpeed: "",
  //       url: apiModel.url,
  //       requestHeader: null,
  //       requestMethod: "",
  //       requestBody: null,
  //       statusCode: apiModel.response!.statusCode,
  //       statusText: apiModel.response!.statusText!,
  //       responseBody: const JsonEncoder.withIndent(
  //         ' ',
  //       ).convert(apiModel.response!.body),
  //       requestTime: null,
  //       responseTime: DateTime.now(),
  //       isError:
  //       apiModel.response!.hasError || apiModel.jsonParsingError != null,
  //       jsonParsingError: apiModel.jsonParsingError,
  //     ),
  //   );
  // }

  static void routeLogger(List routes, [dynamic argument]) {
    final List routesList = [];
    routesList.addAll(routes);
    // Get.find<MiniSwaggerController>().addDataToRecords(
    //   MiniSwaggerAppNavigationModel(
    //     routes: routesList,
    //     argument: const JsonEncoder.withIndent(
    //       ' ',
    //     ).convert(argument?.toString()),
    //   ),
    // );
    log(
      "===========================================================",
      name: "App Navigator",
    );
    for (int i = 0; i < routes.length; i++) {
      if (routes[i].runtimeType == String) {
        log("Route $i: ${routes[i]}");
      } else {
        //routes[i] as Menu;
        log("Route $i: ${routes[i].mobilePath}");
      }
    }
    log(
      "=====================================================================",
    );
  }

  // static void stringLogger(String logData) {
  //   log(logData, name: "STRING LOG");
  //   Get.find<MiniSwaggerController>().addDataToRecords(
  //     MiniSwaggerLogsModel(log: logData),
  //   );
  // }
  //
  // static void eventLogger(String logData) {
  //   log(logData, name: "EVENT LOG");
  //   Get.find<MiniSwaggerController>().addDataToRecords(
  //     MiniSwaggerEvents(log: logData),
  //   );
  // }
}
