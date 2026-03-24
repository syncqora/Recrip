import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/authentication/widgets/auth_widgets.dart';
import 'package:saas/shared/constants/app_strings.dart';

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
          title: AppStrings.forgotPasswordTitle,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormFieldSection(
                label: AppStrings.emailOrPhoneLabel,
                child: MouseRegion(
                  onEnter: (_) => controller.setEmailHovered(true),
                  onExit: (_) => controller.setEmailHovered(false),
                  child: Obx(
                    () => AuthTextField(
                      controller: controller.emailOrPhoneController,
                      hint: AppStrings.enterEmailOrPhoneHint,
                      isHovered: controller.isEmailHovered.value,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingAfterLabel),
              Text(
                AppStrings.otpSentToEmailOrPhone,
                textAlign: TextAlign.center,
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: AppConstants.supportTextColor,
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => AuthPrimaryButton(
                  text: AppStrings.getOtpText,
                  onPressed: controller.onGetOtp,
                  isEnabled: controller.isFormValid.value,
                ),
              ),
              const SizedBox(height: AppConstants.spacingAfterLabel),
              SizedBox(
                height: AppConstants.buttonHeight,
                child: OutlinedButton(
                  onPressed: controller.onBack,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: const Color(0xFF475569),
                    side: const BorderSide(color: AppConstants.borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.fieldBorderRadius,
                      ),
                    ),
                  ),
                  child: Text(
                    AppStrings.backText,
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
