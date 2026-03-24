import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/core/di/get_injector.dart';
import '../../../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final emailOrPhoneController = TextEditingController();
  final isFormValid = false.obs;
  final isEmailHovered = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailOrPhoneController.addListener(_updateFormValid);
  }

  void _updateFormValid() {
    isFormValid.value = emailOrPhoneController.text.trim().isNotEmpty;
  }

  @override
  void onClose() {
    emailOrPhoneController.removeListener(_updateFormValid);
    emailOrPhoneController.dispose();
    super.onClose();
  }

  void setEmailHovered(bool value) {
    isEmailHovered.value = value;
  }

  void onGetOtp() {
    final value = emailOrPhoneController.text.trim();
    if (value.isEmpty) return;
    // TODO: call API to send OTP
    appNav.changePage(AppRoutes.otp, arguments: {'emailOrPhone': value});
  }

  void onBack() {
    Get.back();
  }
}
