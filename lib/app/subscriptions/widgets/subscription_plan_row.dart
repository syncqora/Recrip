/// Row model for subscriptions table / cards (UI + optional API `id`).
class SubscriptionPlanRow {
  SubscriptionPlanRow({
    required this.planName,
    required this.duration,
    required this.price,
    this.isActive = true,
    this.remoteId,
  });

  final String planName;
  final String duration;
  final String price;
  final bool isActive;

  /// Server resource id when loaded from API.
  final String? remoteId;
}
