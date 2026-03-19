import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/auth_widgets.dart';
import 'otp_authentication_controller.dart';

class OtpAuthenticationMobileView extends GetView<OtpAuthenticationController> {
  const OtpAuthenticationMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreenLayout(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: _AuthFormCardMobile(
          title: 'Forgot Password?',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormFieldSection(
                label: 'Enter OTP',
                spacingAfterLabel: 12,
                child: AuthOtpInput(
                  length: OtpAuthenticationController.otpLength,
                  controllers: controller.otpControllers,
                  focusNodes: controller.otpFocusNodes,
                  onChanged: controller.onOtpChanged,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: controller.onResendOtp,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Resend OTP',
                    style: Get.theme.textTheme.bodySmall?.copyWith(
                      color: AuthConstants.titleColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => AuthPrimaryButton(
                  text: 'Verify',
                  onPressed: controller.onVerify,
                  isEnabled: controller.isFormValid.value,
                ),
              ),
              const SizedBox(height: 16),
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
                      fontSize: 15,
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
