import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/auth_widgets.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordTabletView extends GetView<ForgotPasswordController> {
  const ForgotPasswordTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreenLayout(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
        child: AuthFormCard(
          title: AppStrings.forgotPasswordTitle,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormFieldSection(
                label: AppStrings.emailOrPhoneLabel,
                child: Obx(
                  () => AuthTextField(
                    controller: controller.emailOrPhoneController,
                    hint: AppStrings.enterEmailOrPhoneHint,
                    isHovered: controller.isEmailHovered.value,
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
