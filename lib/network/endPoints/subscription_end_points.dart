/// Subscription / asset schema paths (relative to [ApiEndPoints.dataManagementBaseUrl]).
abstract final class SubscriptionEndPoints {
  SubscriptionEndPoints._();

  static const String schemaSubscription = '/schema/asset/subscription';
  static const String contentSubscription = '/content/asset/subscription';
}
