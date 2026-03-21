import 'dart:convert';

import 'package:get/get_connect.dart';

/// API / HTTP failures after a completed request (non-2xx or unusable body).
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// JSON decode or model parse failures.
class JSONException implements Exception {
  JSONException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Maps [Response] failures into [ApiException] (CoffeeWeb-style `ErrorHandler`).
abstract final class ErrorHandler {
  ErrorHandler._();

  static Never throwForResponse(Response<dynamic> response) {
    throw fromResponse(response);
  }

  static ApiException fromResponse(Response<dynamic> response) {
    final code = response.statusCode;
    final raw = response.bodyString;
    Map<String, dynamic>? json;
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) json = decoded;
      } catch (_) {}
    }
    final message =
        _messageFromErrorJson(json) ??
        (raw != null && raw.isNotEmpty
            ? raw
            : 'Request failed${code != null ? ' ($code)' : ''}');
    return ApiException(message, statusCode: code);
  }

  static String? _messageFromErrorJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final msg = json['message'] ?? json['error'] ?? json['detail'];
    if (msg is String && msg.isNotEmpty) return msg;
    if (msg is List && msg.isNotEmpty) return msg.first.toString();
    return null;
  }
}
