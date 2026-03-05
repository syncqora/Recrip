import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/auth_widgets.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordTabletView extends GetView<ForgotPasswordController> {
  const ForgotPasswordTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreenLayout(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
        child: AuthFormCard(
          title: 'Forgot Password?',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormFieldSection(
                label: 'Email Address/Phone Number',
                child: Obx(
                  () => AuthTextField(
                    controller: controller.emailOrPhoneController,
                    hint: 'Enter Email Address /Phone Number',
                    isHovered: controller.isEmailHovered.value,
                  ),
                ),
              ),
              const SizedBox(height: AuthConstants.spacingAfterLabel),
              Text(
                'OTP will be sent to the Email Address/Phone Number',
                textAlign: TextAlign.center,
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: AuthConstants.supportTextColor,
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => AuthPrimaryButton(
                  text: 'Get OTP',
                  onPressed: controller.onGetOtp,
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
