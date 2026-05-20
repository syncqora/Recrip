import 'package:flutter_test/flutter_test.dart';
import 'package:saas/core/models/member/member_schema_models.dart';

void main() {
  group('MemberCountResponse', () {
    test('fromJson reads count from numeric data field', () {
      final r = MemberCountResponse.fromJson({
        'header': {
          'source': '022-06',
          'code': 0,
          'message': 'Success',
          'system_time': 1779279036849,
          'tracking_id': '401cae2a-89d8-4423-9f4b-309954d66854',
        },
        'data': 2,
      });
      expect(r.count, 2);
    });

    test('fromJson reads count when data is only present', () {
      final r = MemberCountResponse.fromJson({'data': 12});
      expect(r.count, 12);
    });

    test('fromJson treats null or missing data as zero', () {
      expect(MemberCountResponse.fromJson({'data': null}).count, 0);
      expect(MemberCountResponse.fromJson({'header': {}}).count, 0);
    });

    test('fromJson throws when data is not numeric', () {
      expect(
        () => MemberCountResponse.fromJson({
          'data': {'count': 7},
        }),
        throwsFormatException,
      );
    });
  });
}
