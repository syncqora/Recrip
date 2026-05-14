import 'package:flutter_test/flutter_test.dart';
import 'package:saas/app/screens/dashboard/modals/create_plan_modal.dart';
import 'package:saas/app/subscriptions/subscription_create_payload.dart';

void main() {
  group('SubscriptionCreatePayload', () {
    test('fromCreatePlanResult maps fields and parses price', () {
      const result = CreatePlanResult(
        planName: 'Gold',
        duration: '12 Months',
        price: '₹1,299.50',
        isActive: true,
        apiDuration: 'yearly',
      );
      final map = SubscriptionCreatePayload.fromCreatePlanResult(result);
      expect(map['title'], 'Gold');
      expect(map['status'], 'published');
      final id = map['id'] as String;
      expect(
        id,
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ),
        ),
      );
      expect(map['description'], contains('Gold'));
      expect(map['description'], contains('₹1,299.50'));
      final data = map['data'] as Map<String, dynamic>;
      expect(data['subscriptionType'], 'standard');
      expect(data['duration'], 'yearly');
      expect(data['price'], 1299.5);
    });

    test('inactive maps to draft status', () {
      const result = CreatePlanResult(
        planName: 'X',
        duration: '30 Days',
        price: '10',
        isActive: false,
        apiDuration: 'monthly',
      );
      final map = SubscriptionCreatePayload.fromCreatePlanResult(result);
      expect(map['status'], 'draft');
    });
  });
}
