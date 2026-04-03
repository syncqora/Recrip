import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/core/di/get_injector.dart';
import '../../../../../routes/app_pages.dart';

class OtpAuthenticationController extends GetxController {
  static const int otpLength = 6;

  final List<TextEditingController> otpControllers = List.generate(
    otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> otpFocusNodes = List.generate(
    otpLength,
    (_) => FocusNode(),
  );

  final isFormValid = false.obs;

  String? get emailOrPhone {
    final args = appNav.appArgs;
    return args is Map ? (args as Map)['emailOrPhone'] as String? : null;
  }

  @override
  void onInit() {
    super.onInit();
    for (int i = 0; i < otpLength; i++) {
      otpControllers[i].addListener(_updateFormValid);
    }
  }

  void _updateFormValid() {
    final filled = otpControllers.every((c) => c.text.length == 1);
    isFormValid.value = filled;
  }

  @override
  void onClose() {
    for (int i = 0; i < otpLength; i++) {
      otpControllers[i].removeListener(_updateFormValid);
      otpControllers[i].dispose();
      otpFocusNodes[i].dispose();
    }
    super.onClose();
  }

  void onOtpChanged(int index, String value) {
    if (value.length > 1) {
      otpControllers[index].text = value[value.length - 1];
    }
    if (value.isNotEmpty && index < otpLength - 1) {
      otpFocusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
    _updateFormValid();
  }

  String get otpCode => otpControllers.map((c) => c.text).join();

  void onVerify() {
    if (!isFormValid.value) return;
    final code = otpCode;
    if (code.length != otpLength) return;
    // TODO: call API to verify OTP if needed
    appNav.changePage(
      AppRoutes.resetPassword,
      arguments: {'emailOrPhone': emailOrPhone, 'otp': code},
    );
  }

  void onResendOtp() {
    // TODO: call API to resend OTP to emailOrPhone
  }

  void onBack() {
    Get.back();
  }
}
