import '../../core/models/subscription/subscription_schema_models.dart';
import '../api/subscription_api_services.dart';

abstract class SubscriptionRepository {
  Future<SubscriptionSchemaResponse> getSubscriptionSchema();
  Future<SubscriptionSchemaResponse> getSubscriptions({
    int pageNumber,
    int pageSize,
  });

  /// POST `/content/asset/subscription`.
  Future<SubscriptionAsset?> createSubscription({
    required Map<String, dynamic> body,
  });
}

class SubscriptionRepo implements SubscriptionRepository {
  SubscriptionRepo({required this.services});

  final SubscriptionServices services;

  @override
  Future<SubscriptionSchemaResponse> getSubscriptionSchema() =>
      services.getSubscriptionSchema();

  @override
  Future<SubscriptionSchemaResponse> getSubscriptions({
    int pageNumber = 1,
    int pageSize = 20,
  }) => services.getSubscriptions(pageNumber: pageNumber, pageSize: pageSize);

  @override
  Future<SubscriptionAsset?> createSubscription({
    required Map<String, dynamic> body,
  }) => services.createSubscription(body: body);
}
