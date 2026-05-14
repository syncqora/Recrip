import '../../shared/utils/uuid_v4.dart';
import '../screens/dashboard/modals/create_plan_modal.dart';

/// Builds the JSON body for POST `/content/asset/subscription` from modal input.
abstract final class SubscriptionCreatePayload {
  SubscriptionCreatePayload._();

  /// Default [data.subscriptionType] when the UI does not collect a tier.
  static const String defaultSubscriptionType = 'standard';

  /// Maps modal output to the content API contract (id, title, description, status, data).
  static Map<String, dynamic> fromCreatePlanResult(CreatePlanResult result) {
    final id = newUuidV4();
    final price = _parsePrice(result.price);
    final status = result.isActive ? 'published' : 'draft';
    final data = <String, dynamic>{
      'subscriptionType': defaultSubscriptionType,
      'duration': result.apiDuration,
    };
    if (price != null) {
      data['price'] = price;
    }

    return <String, dynamic>{
      'id': id,
      'title': result.planName,
      'description': _description(result),
      'status': status,
      'data': data,
    };
  }

  static String _description(CreatePlanResult result) {
    return '${result.planName}: price ${result.price}, period ${result.duration}.';
  }

  static double? _parsePrice(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) {
      return null;
    }
    return double.tryParse(cleaned);
  }
}
