import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/auth_widgets.dart';
import 'reset_password_controller.dart';

class ResetPasswordTabletView extends GetView<ResetPasswordController> {
  const ResetPasswordTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreenLayout(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
        child: AuthFormCard(
          title: 'Reset Password',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormFieldSection(
                label: 'New Password',
                spacingAfterLabel: 8,
                child: Obx(
                  () => AuthPasswordField(
                    controller: controller.newPasswordController,
                    obscureText: !controller.isNewPasswordVisible.value,
                    onToggleVisibility: controller.toggleNewPasswordVisibility,
                    hint: 'Enter New Password',
                  ),
                ),
              ),
              const SizedBox(height: AuthConstants.spacingBetweenFields),
              AuthFormFieldSection(
                label: 'Confirm Password',
                spacingAfterLabel: 8,
                child: Obx(
                  () => AuthPasswordField(
                    controller: controller.confirmPasswordController,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    onToggleVisibility: controller.toggleConfirmPasswordVisibility,
                    hint: 'Enter New Password',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => AuthPrimaryButton(
                  text: 'Reset Password',
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
