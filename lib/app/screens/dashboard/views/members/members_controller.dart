import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dashboard/dashboard_controller.dart';
import 'members_mobile_view.dart';

class MembersController extends GetxController {
  late final DashboardController _dashboardController;

  final selectedPlan = RxnString();
  final selectedStatus = RxnString();

  RxList<MemberRow> get tableData => _dashboardController.memberTableData;
  RxBool get isLoading => _dashboardController.membersLoading;
  RxnString get errorMessage => _dashboardController.membersErrorMessage;

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController());
    }
    _dashboardController = Get.find<DashboardController>();
  }

  @override
  void onReady() {
    super.onReady();
    if (_dashboardController.memberTableData.isEmpty &&
        !_dashboardController.membersLoading.value) {
      _dashboardController.loadMembers();
    }
  }

  Future<void> loadMembers() => _dashboardController.loadMembers();

  Future<void> addMember({
    required String name,
    required String email,
    required String phone,
    required String plan,
    required DateTime startDate,
    required DateTime expiresAt,
  }) async {
    await _dashboardController.addMember(
      name: name,
      email: email,
      phone: phone,
      plan: plan,
      startDate: startDate,
      expiresAt: expiresAt,
    );
  }

  Future<void> updateMember({
    required String contentId,
    required String name,
    required String email,
    required String phone,
    required String plan,
    required DateTime startDate,
    required DateTime expiresAt,
  }) async {
    await _dashboardController.updateMember(
      contentId: contentId,
      name: name,
      email: email,
      phone: phone,
      plan: plan,
      startDate: startDate,
      expiresAt: expiresAt,
    );
  }

  void setSelectedPlan(String? value) {
    selectedPlan.value = value;
  }

  void setSelectedStatus(String? value) {
    selectedStatus.value = value;
  }

  Color statusColor(String value) {
    switch (value) {
      case 'Active':
        return const Color(0xFF166534);
      case 'Expiring':
        return const Color(0xFF92400E);
      case 'Expired':
        return const Color(0xFF991B1B);
      default:
        return const Color(0xFF0F172A);
    }
  }

}
