import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../core/di/get_injector.dart';

class DashboardController extends GetxController {
  final selectedNavIndex = 0.obs;
  final renewalsScrollController = ScrollController();

  @override
  void onClose() {
    renewalsScrollController.dispose();
    super.onClose();
  }

  void onNavTap(int index) {
    selectedNavIndex.value = index;
    // TODO: navigate to Members, Subscriptions, etc. when those screens exist
  }

  void onLogout() {
    // TODO: clear session and navigate to login
    appNav.changePage(AppRoutes.home);
  }

  void onAddMember() {}
  void onViewAllRenewals() {}
  void onSendRemindersNow() {}
}
