import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/core/models/subscription/subscription_schema_models.dart';
import 'package:saas/core/services/auth_service.dart';
import 'package:saas/network/repo/subscription_repo.dart';

import 'widgets/subscription_plan_row.dart';

class SubscriptionsController extends GetxController {
  late final SubscriptionRepository _repository;
  late final AuthService _authService;

  final RxList<SubscriptionPlanRow> plans = <SubscriptionPlanRow>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<SubscriptionRepository>();
    _authService = Get.find<AuthService>();
  }

  /// GetX schedules this one frame after [onInit]; async HTTP belongs here (not in
  /// [onInit]), so the controller is fully registered before [loadInitialData] runs.
  @override
  void onReady() {
    super.onReady();
    loadInitialData();
  }

  /// Loads subscription schema, then fetches rows from GET `/content/asset/subscription`.
  Future<void> loadInitialData() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      // Keep schema check first, then load actual content list.
      await _repository.getSubscriptionSchema();
      final response = await _repository.getSubscriptions(
        pageNumber: 1,
        pageSize: 20,
      );
      plans.assignAll(response.items.map(_rowFromAsset).toList());
    } catch (e) {
      errorMessage.value = _authService.messageForError(e);
      plans.clear();
    } finally {
      try {
        isLoading.value = false;
      } catch (_) {}
    }
  }

  /// [RefreshIndicator] / Retry / tab revisit (via view post-frame).
  Future<void> refreshView() => loadInitialData();

  SubscriptionPlanRow _rowFromAsset(SubscriptionAsset a) {
    final name = a.name.isNotEmpty ? a.name : (a.key.isNotEmpty ? a.key : a.id);
    final durationLabel = a.duration != null ? '${a.duration} Months' : '—';
    final priceLabel = a.price != null ? _formatPrice(a.price!) : '—';
    final published = a.st == 'published';
    return SubscriptionPlanRow(
      planName: name,
      duration: durationLabel,
      price: priceLabel,
      isActive: published,
      remoteId: a.id.isNotEmpty ? a.id : null,
    );
  }

  String _formatPrice(double p) {
    if (p == p.roundToDouble()) {
      return '₹${p.toInt()}';
    }
    return '₹${p.toStringAsFixed(2)}';
  }

  void updatePlanAt(int index, SubscriptionPlanRow row) {
    if (index < 0 || index >= plans.length) return;
    final copy = List<SubscriptionPlanRow>.from(plans);
    copy[index] = row;
    plans.assignAll(copy);
  }

  void removePlanAt(int index) {
    if (index < 0 || index >= plans.length) return;
    final copy = List<SubscriptionPlanRow>.from(plans)..removeAt(index);
    plans.assignAll(copy);
  }

  void addPlan(SubscriptionPlanRow row) {
    plans.assignAll([...plans, row]);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
