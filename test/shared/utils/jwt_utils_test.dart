import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:saas/shared/utils/jwt_utils.dart';

String _jwtWithPayload(Map<String, dynamic> payload) {
  final encoded = base64Url.encode(utf8.encode(jsonEncode(payload)));
  return 'hdr.$encoded.sig';
}

void main() {
  group('JwtUtils.hasSuperAdminRole', () {
    test('returns true when roles list contains super_admin', () {
      expect(
        JwtUtils.hasSuperAdminRole(
          _jwtWithPayload({
            'roles': ['member', 'super_admin'],
          }),
        ),
        isTrue,
      );
    });

    test('returns false when roles list does not contain super_admin', () {
      expect(
        JwtUtils.hasSuperAdminRole(
          _jwtWithPayload({
            'roles': ['member'],
          }),
        ),
        isFalse,
      );
    });

    test('returns false for null or empty token', () {
      expect(JwtUtils.hasSuperAdminRole(null), isFalse);
      expect(JwtUtils.hasSuperAdminRole(''), isFalse);
    });

    test('returns false when roles claim is missing or not a list', () {
      expect(JwtUtils.hasSuperAdminRole(_jwtWithPayload({})), isFalse);
      expect(
        JwtUtils.hasSuperAdminRole(_jwtWithPayload({'roles': 'super_admin'})),
        isFalse,
      );
    });
  });
}
