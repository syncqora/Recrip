import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/core/di/get_injector.dart';
import '../../../../../routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isFormValid = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  String? get emailOrPhone {
    final args = appNav.appArgs;
    return args is Map ? (args as Map)['emailOrPhone'] as String? : null;
  }

  String? get otp {
    final args = appNav.appArgs;
    return args is Map ? (args as Map)['otp'] as String? : null;
  }

  @override
  void onInit() {
    super.onInit();
    newPasswordController.addListener(_updateFormValid);
    confirmPasswordController.addListener(_updateFormValid);
  }

  void _updateFormValid() {
    final newPwd = newPasswordController.text;
    final confirmPwd = confirmPasswordController.text;
    isFormValid.value =
        newPwd.isNotEmpty && confirmPwd.isNotEmpty && newPwd == confirmPwd;
  }

  @override
  void onClose() {
    newPasswordController.removeListener(_updateFormValid);
    confirmPasswordController.removeListener(_updateFormValid);
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void onResetPassword() {
    if (!isFormValid.value) return;
    final newPwd = newPasswordController.text;
    final confirmPwd = confirmPasswordController.text;
    if (newPwd.isEmpty || newPwd != confirmPwd) return;
    // TODO: call API to reset password with emailOrPhone, otp, newPwd
    appNav.changePage(AppRoutes.dashboard);
  }
}
