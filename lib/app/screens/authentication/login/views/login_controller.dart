import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/core/di/get_injector.dart';

import '../../../../../routes/app_pages.dart';

class LoginController extends GetxController {
  // UI state
  final isPasswordVisible = false.obs;
  final isUsernameHovered = false.obs;
  final isPasswordHovered = false.obs;
  final isForgotPasswordHovered = false.obs;

  // Form data (for validation / submit)
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    usernameController.addListener(_updateFormValid);
    passwordController.addListener(_updateFormValid);
  }

  void _updateFormValid() {
    isFormValid.value =
        usernameController.text.trim().isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  @override
  void onClose() {
    usernameController.removeListener(_updateFormValid);
    passwordController.removeListener(_updateFormValid);
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void setUsernameHovered(bool value) {
    isUsernameHovered.value = value;
  }

  void setPasswordHovered(bool value) {
    isPasswordHovered.value = value;
  }

  void setForgotPasswordHovered(bool value) {
    isForgotPasswordHovered.value = value;
  }

  void onLogin() {
    final username = usernameController.text.trim();
    final password = passwordController.text;
    // TODO: validate and call auth API
    if (username.isEmpty || password.isEmpty) {
      return;
    }
    appNav.changePage(AppRoutes.dashboard);
    // Get.find<AuthService>().login(username, password);
  }

  void onForgotPassword() {
    appNav.changePage(AppRoutes.forgotPassword);
  }

  void onReachOutTap() {
    // TODO: open support link or email
  }
}
