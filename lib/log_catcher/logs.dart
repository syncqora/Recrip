import 'dart:developer';

class Logs {
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
