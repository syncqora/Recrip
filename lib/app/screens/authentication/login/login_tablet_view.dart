import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/auth_widgets.dart';
import 'login_controller.dart';

class LoginTabletView extends GetView<LoginController> {
  const LoginTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreenLayout(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
        child: AuthFormCard(
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
              const SizedBox(height: AuthConstants.spacingBetweenFields),
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
              const SizedBox(height: AuthConstants.spacingAfterLabel),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.onForgotPassword,
                  child: Text(
                    'Forgot Password?',
                    style: Get.theme.textTheme.labelMedium!.copyWith(
                      color: AuthConstants.hintColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AuthConstants.spacingAfterLogo),
              Obx(
                () => AuthPrimaryButton(
                  text: 'Login',
                  onPressed: controller.onLogin,
                  isEnabled: controller.isFormValid.value,
                ),
              ),
              const SizedBox(height: AuthConstants.spacingAfterButton),
              AuthSupportFooter(onReachOut: controller.onReachOutTap),
            ],
          ),
        ),
      ),
    );
  }
}
