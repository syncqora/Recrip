import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/auth_widgets.dart';
import 'reset_password_controller.dart';

class ResetPasswordMobileView extends GetView<ResetPasswordController> {
  const ResetPasswordMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreenLayout(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: _AuthFormCardMobile(
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 32),
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

class _AuthFormCardMobile extends StatelessWidget {
  const _AuthFormCardMobile({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: AuthConstants.cardBackground,
        borderRadius: BorderRadius.circular(AuthConstants.cardBorderRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/saas-logo.png',
                height: 36,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.bodyLarge?.copyWith(
              color: AuthConstants.titleColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          child,
        ],
      ),
    );
  }
}
