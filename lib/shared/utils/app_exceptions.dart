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
    final json = _responseBodyAsJsonMap(response, raw);

    final message = _messageFromErrorJson(json) ??
        _messageFromPlainBody(raw) ??
        _messageFromStatus(response, code);

    return ApiException(message, statusCode: code);
  }

  /// Prefer decoded JSON from [raw], else [Response.body] if it is already a [Map].
  static Map<String, dynamic>? _responseBodyAsJsonMap(
    Response<dynamic> response,
    String? raw,
  ) {
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    final b = response.body;
    if (b is Map<String, dynamic>) return b;
    if (b is Map) return Map<String, dynamic>.from(b);
    return null;
  }

  static String? _messageFromPlainBody(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final t = raw.trim();
    if (t.isEmpty) return null;
    // Short HTML / plain text from reverse proxies
    if (t.length > 500) return '${t.substring(0, 500)}…';
    return t;
  }

  static String _messageFromStatus(Response<dynamic> response, int? code) {
    final st = response.statusText?.trim();
    if (st != null && st.isNotEmpty) {
      return code != null ? 'HTTP $code: $st' : st;
    }
    return 'Request failed${code != null ? ' ($code)' : ''}';
  }

  static String? _messageFromErrorJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    // Envelope APIs: { "header": { "message": "...", "code": 1 } }
    final header = json['header'];
    if (header is Map) {
      final hm = Map<String, dynamic>.from(header);
      final hMsg = hm['message'];
      final hCode = hm['code'];
      if (hMsg is String && hMsg.isNotEmpty) {
        if (hCode is num && hCode != 0) {
          return '$hMsg (code: ${hCode.toInt()})';
        }
        return hMsg;
      }
    }

    final msg = json['message'] ?? json['error'] ?? json['detail'];
    if (msg is String && msg.isNotEmpty) return msg;
    if (msg is List && msg.isNotEmpty) return msg.first.toString();

    final errors = json['errors'];
    if (errors is List && errors.isNotEmpty) {
      final first = errors.first;
      if (first is String) return first;
      if (first is Map) {
        final m = first['message'] ?? first['detail'] ?? first['title'];
        if (m is String && m.isNotEmpty) return m;
      }
    }

    return null;
  }
}
