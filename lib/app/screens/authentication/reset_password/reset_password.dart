import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/authentication/widgets/auth_widgets.dart';
import 'package:saas/shared/constants/app_strings.dart';

import 'views/reset_password_controller.dart';
import 'views/reset_password_mobile_view.dart';
import 'views/reset_password_tablet_view.dart';

class ResetPassword extends GetView<ResetPasswordController> {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ResetPasswordController());
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return const ResetPasswordMobileView();
    }

    if (width < 1024) {
      return const ResetPasswordTabletView();
    }

    return Scaffold(
      body: AuthScreenLayout(
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
