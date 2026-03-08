import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/authentication/widgets/auth_widgets.dart';

import 'views/forgot_password_controller.dart';
import 'views/forgot_password_mobile_view.dart';
import 'views/forgot_password_tablet_view.dart';

class ForgotPassword extends GetView<ForgotPasswordController> {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ForgotPasswordController());
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return const ForgotPasswordMobileView();
    }

    if (width < 1024) {
      return const ForgotPasswordTabletView();
    }

    return Scaffold(
      body: AuthScreenLayout(
        child: AuthFormCard(
          title: 'Forgot Password?',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormFieldSection(
                label: 'Email Address/Phone Number',
                child: MouseRegion(
                  onEnter: (_) => controller.setEmailHovered(true),
                  onExit: (_) => controller.setEmailHovered(false),
                  child: Obx(
                    () => AuthTextField(
                      controller: controller.emailOrPhoneController,
                      hint: 'Enter Email Address /Phone Number',
                      isHovered: controller.isEmailHovered.value,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AuthConstants.spacingAfterLabel),
              Text(
                'OTP will be sent to the\nEmail Address/Phone Number',
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
              const SizedBox(height: AuthConstants.spacingAfterLabel),
              SizedBox(
                height: AuthConstants.buttonHeight,
                child: OutlinedButton(
                  onPressed: controller.onBack,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: const Color(0xFF475569),
                    side: const BorderSide(color: AuthConstants.borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AuthConstants.fieldBorderRadius,
                      ),
                    ),
                  ),
                  child: Text(
                    'Back',
                    style: Get.theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: const Color(0xFF475569),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
