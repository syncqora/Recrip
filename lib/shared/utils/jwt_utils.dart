import 'dart:convert';

/// Lightweight helper for working with JSON Web Tokens.
///
/// Only decodes the **payload** (claims) — does **not** verify the signature.
/// That's fine here because we only use it to extract identifiers (e.g. the
/// `tenant_id`) the server already issued and trusts; signature verification
/// happens server-side on every authenticated request.
class JwtUtils {
  const JwtUtils._();

  /// Decodes the payload of [token] and returns it as a [Map].
  ///
  /// Returns an empty, unmodifiable map if [token] is empty, malformed, or the
  /// payload is not valid JSON. Never throws.
  static Map<String, dynamic> decodePayload(String? token) {
    if (token == null || token.isEmpty) return const <String, dynamic>{};
    try {
      final parts = token.split('.');
      if (parts.length != 3) return const <String, dynamic>{};
      final normalized = base64Url.normalize(parts[1]);
      final jsonStr = utf8.decode(base64Url.decode(normalized));
      final decoded = jsonDecode(jsonStr);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {
      // Malformed token — fall through to empty map.
    }
    return const <String, dynamic>{};
  }

  /// Returns the `exp` claim of [token] as a UTC [DateTime], or `null` if
  /// missing/invalid.
  static DateTime? expiresAt(String? token) {
    final exp = decodePayload(token)['exp'];
    if (exp is int) {
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    }
    return null;
  }

  /// Whether the JWT payload's `roles` claim includes `super_admin`.
  ///
  /// Expects `roles` to be a JSON array of strings (as persisted in
  /// [AuthService]). Returns `false` if [token] is empty or `roles` is absent
  /// or not a list.
  static bool hasSuperAdminRole(String? token) {
    final roles = decodePayload(token)['roles'];
    if (roles is! List) return false;
    for (final r in roles) {
      if (r == 'super_admin') return true;
    }
    return false;
  }
}
