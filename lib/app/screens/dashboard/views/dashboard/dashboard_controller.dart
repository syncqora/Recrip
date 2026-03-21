import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/controllers/app_settings_controller.dart';
import '../../../../../core/di/get_injector.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../routes/app_pages.dart';

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

  Future<void> onLogout() async {
    await Get.find<AuthService>().logout();
    Get.find<AppSettingsController>().isUserLoggedIn.value = false;
    appNav.changePage(AppRoutes.home);
  }

  void onAddMember() {}
  void onViewAllRenewals() {}
  void onSendRemindersNow() {}
}
