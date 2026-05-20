import 'package:flutter_test/flutter_test.dart';
import 'package:saas/app/screens/dashboard/modals/create_plan_modal.dart';
import 'package:saas/app/subscriptions/subscription_create_payload.dart';

void main() {
  group('SubscriptionCreatePayload', () {
    test('fromCreatePlanResult maps asset fields and parses price', () {
      final result = CreatePlanResult(
        planName: 'Monthly',
        duration: '30 Days',
        price: '₹1,000',
        isActive: true,
        apiDuration: 'monthly',
        durationDays: 30,
        startDate: DateTime.utc(2026, 5, 13),
      );
      final map = SubscriptionCreatePayload.fromCreatePlanResult(result);
      expect(map['urn'], SubscriptionCreatePayload.urn);
      expect(map['st'], 'published');
      expect(map['cty'], 'subscription');
      expect(map['status'], 'active');
      expect(map['prd'], ['recrip']);
      expect(map['name'], 'Monthly');
      expect(map['duration'], 30);
      expect(map['custom_duration'], 30);
      expect(map['tid'], '');
      expect(map['price'], 1000);
      expect(map['key'], map['id']);
      final id = map['id'] as String;
      expect(
        id,
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ),
        ),
      );
      expect(map['ct'], '2026-05-13T00:00:00.000Z');
      expect(map['ut'], '2026-06-12T00:00:00.000Z');
    });

    test('inactive maps to draft and inactive status', () {
      final result = CreatePlanResult(
        planName: 'X',
        duration: '30 Days',
        price: '10',
        isActive: false,
        apiDuration: 'monthly',
        durationDays: 1,
        startDate: DateTime.utc(2026, 1, 1),
      );
      final map = SubscriptionCreatePayload.fromCreatePlanResult(result);
      expect(map['st'], 'draft');
      expect(map['status'], 'inactive');
      expect(map['duration'], 1);
      expect(map['custom_duration'], 1);
    });
  });
}
