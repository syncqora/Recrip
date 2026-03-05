import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/auth_widgets.dart';
import 'login_controller.dart';

class LoginMobileView extends GetView<LoginController> {
  const LoginMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreenLayout(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: _AuthFormCardMobile(
          title: 'Login',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormFieldSection(
                label: 'User Name',
                child: Obx(
                  () => AuthTextField(
                    controller: controller.usernameController,
                    hint: 'Enter username',
                    isHovered: controller.isUsernameHovered.value,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AuthFormFieldSection(
                label: 'Password',
                child: Obx(
                  () => AuthPasswordField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    onToggleVisibility: controller.togglePasswordVisibility,
                    isHovered: controller.isPasswordHovered.value,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.onForgotPassword,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot Password?',
                    style: Get.theme.textTheme.labelMedium!.copyWith(
                      color: AuthConstants.hintColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => AuthPrimaryButton(
                  text: 'Login',
                  onPressed: controller.onLogin,
                  isEnabled: controller.isFormValid.value,
                ),
              ),
              const SizedBox(height: 48),
              AuthSupportFooter(onReachOut: controller.onReachOutTap),
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
              fontSize: 20,
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
