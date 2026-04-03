import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/auth_widgets.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'reset_password_controller.dart';

class ResetPasswordTabletView extends GetView<ResetPasswordController> {
  const ResetPasswordTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreenLayout(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
        child: AuthFormCard(
          title: AppStrings.resetPasswordTitle,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormFieldSection(
                label: AppStrings.newPasswordLabel,
                spacingAfterLabel: 8,
                child: Obx(
                  () => AuthPasswordField(
                    controller: controller.newPasswordController,
                    obscureText: !controller.isNewPasswordVisible.value,
                    onToggleVisibility: controller.toggleNewPasswordVisibility,
                    hint: AppStrings.enterNewPasswordHint,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingBetweenFields),
              AuthFormFieldSection(
                label: AppStrings.confirmPasswordLabel,
                spacingAfterLabel: 8,
                child: Obx(
                  () => AuthPasswordField(
                    controller: controller.confirmPasswordController,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    onToggleVisibility:
                        controller.toggleConfirmPasswordVisibility,
                    hint: AppStrings.enterNewPasswordHint,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => AuthPrimaryButton(
                  text: AppStrings.resetPasswordTitle,
                  onPressed: controller.onResetPassword,
                  isEnabled: controller.isFormValid.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
