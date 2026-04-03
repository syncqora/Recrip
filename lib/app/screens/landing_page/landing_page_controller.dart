import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/core/controllers/app_settings_controller.dart';
import 'package:saas/core/di/get_injector.dart';
import 'package:saas/core/services/auth_service.dart';
import 'package:saas/routes/app_pages.dart';
import 'package:saas/shared/utils/auth_landing.dart';
import 'package:saas/shared/utils/auth_validators.dart';

/// Owns hero login form state on [LandingPage]. Logic mirrors [LoginController]
/// but is independent so the landing screen does not depend on login bindings.
class LandingPageController extends GetxController {
  late final AuthService _authService;

  final isPasswordVisible = false.obs;
  final isUsernameHovered = false.obs;
  final isPasswordHovered = false.obs;
  final isForgotPasswordHovered = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;

  final isFormValid = false.obs;
  final isSubmitting = false.obs;
  final emailError = RxnString();
  final passwordError = RxnString();

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    emailFocusNode.addListener(_onEmailFocusChange);
    emailController.addListener(_onEmailTextChange);
    passwordController.addListener(_onPasswordTextChange);
  }

  void _onEmailFocusChange() {
    if (!emailFocusNode.hasFocus) {
      validateEmailOnLeaveField();
    }
  }

  void validateEmailOnLeaveField() {
    final v = emailController.text.trim();
    if (v.isEmpty) {
      return;
    }
    emailError.value = AuthValidators.emailFieldError(emailController.text);
  }

  void _onEmailTextChange() {
    emailError.value = null;
    _recomputeFormValid();
  }

  void _onPasswordTextChange() {
    passwordError.value = null;
    _recomputeFormValid();
  }

  void _recomputeFormValid() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    isFormValid.value = AuthValidators.isValidEmail(email) &&
        AuthValidators.isStrongPassword(password);
  }

  @override
  void onClose() {
    emailFocusNode.removeListener(_onEmailFocusChange);
    emailController.removeListener(_onEmailTextChange);
    passwordController.removeListener(_onPasswordTextChange);
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
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

  Future<void> onLogin() async {
    if (isSubmitting.value) return;

    emailError.value = AuthValidators.emailErrorForSubmit(emailController.text);
    passwordError.value = AuthValidators.passwordErrorForSubmit(
      passwordController.text,
    );
    _recomputeFormValid();
    if (emailError.value != null || passwordError.value != null) {
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text;

    isSubmitting.value = true;
    try {
      final response = await _authService.login(email: email, password: password);
      debugPrint(
        const JsonEncoder.withIndent('  ').convert(response.toJson()),
      );
      Get.find<AppSettingsController>().isUserLoggedIn.value = true;
      appNav.changePage(
        AuthLanding.path(persistedEmail: email),
      );
    } catch (e) {
      Get.snackbar(
        'Login failed',
        _authService.messageForError(e),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void onForgotPassword() {
    appNav.changePage(AppRoutes.forgotPassword);
  }

  void onReachOutTap() {
    // TODO: open support link or email
  }
}
