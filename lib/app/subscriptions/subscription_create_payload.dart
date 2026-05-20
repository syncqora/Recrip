import '../../shared/utils/uuid_v4.dart';
import '../screens/dashboard/modals/create_plan_modal.dart';

/// Builds the JSON body for POST `/content/asset/subscription` from modal input.
abstract final class SubscriptionCreatePayload {
  SubscriptionCreatePayload._();

  static const String urn = 'urn:resource:asset:subscription';
  static const String contentType = 'subscription';
  static const List<String> productIds = ['recrip'];

  /// Maps modal output to the content API contract.
  static Map<String, dynamic> fromCreatePlanResult(CreatePlanResult result) {
    final id = newUuidV4();
    final days = result.durationDays;
    final start = result.startDate.toUtc();
    final end = start.add(Duration(days: days));
    final price = _parsePrice(result.price);

    final body = <String, dynamic>{
      'urn': urn,
      'st': result.isActive ? 'published' : 'draft',
      'id': id,
      'key': id,
      'cty': contentType,
      'status': result.isActive ? 'active' : 'inactive',
      'prd': productIds,
      'ct': _toIsoUtc(start),
      'ut': _toIsoUtc(end),
      'name': result.planName,
      'duration': days,
      'custom_duration': days,
      'tid': '',
    };
    if (price != null) {
      body['price'] = price;
    }
    return body;
  }

  static String _toIsoUtc(DateTime date) => date.toUtc().toIso8601String();

  static num? _parsePrice(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) {
      return null;
    }
    final parsed = double.tryParse(cleaned);
    if (parsed == null) {
      return null;
    }
    if (parsed == parsed.roundToDouble()) {
      return parsed.round();
    }
    return parsed;
  }
}
