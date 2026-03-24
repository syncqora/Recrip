import 'package:get/get.dart';

import 'subscriptions_controller.dart';

/// Registers [SubscriptionsController] for the dashboard tab / shell pattern.
/// Call [ensureRegistered] before [Get.find] or [GetView] resolves the controller.
class SubscriptionsBinding extends Bindings {
  /// Idempotent: safe to call from [SubscriptionsView] on every build.
  static void ensureRegistered() {
    if (!Get.isRegistered<SubscriptionsController>()) {
      Get.lazyPut<SubscriptionsController>(
        () => SubscriptionsController(),
        fenix: true,
      );
    }
  }

  @override
  void dependencies() {
    ensureRegistered();
  }
}
