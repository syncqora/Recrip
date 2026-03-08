import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/authentication/widgets/auth_widgets.dart';

import 'views/login_controller.dart';
import 'views/login_mobile_view.dart';
import 'views/login_tablet_view.dart';

class Login extends GetView<LoginController> {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return const LoginMobileView();
    }

    if (width < 1024) {
      return const LoginTabletView();
    }

    return Scaffold(
      body: AuthScreenLayout(
        child: AuthFormCard(
          title: 'Login',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormFieldSection(
                label: 'User Name',
                child: MouseRegion(
                  onEnter: (_) => controller.setUsernameHovered(true),
                  onExit: (_) => controller.setUsernameHovered(false),
                  child: Obx(
                    () => AuthTextField(
                      controller: controller.usernameController,
                      hint: 'Enter username',
                      isHovered: controller.isUsernameHovered.value,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AuthConstants.spacingBetweenFields),
              AuthFormFieldSection(
                label: 'Password',
                child: MouseRegion(
                  onEnter: (_) => controller.setPasswordHovered(true),
                  onExit: (_) => controller.setPasswordHovered(false),
                  child: Obx(
                    () => AuthPasswordField(
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      onToggleVisibility: controller.togglePasswordVisibility,
                      isHovered: controller.isPasswordHovered.value,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AuthConstants.spacingAfterLabel),
              Align(
                alignment: Alignment.centerRight,
                child: MouseRegion(
                  onEnter: (_) => controller.setForgotPasswordHovered(true),
                  onExit: (_) => controller.setForgotPasswordHovered(false),
                  child: Obx(
                    () {
                      final hovered = controller.isForgotPasswordHovered.value;
                      final color = hovered
                          ? AuthConstants.titleColor
                          : AuthConstants.hintColor;
                      return TextButton(
                        onPressed: controller.onForgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: Get.theme.textTheme.labelMedium!.copyWith(
                            color: color,
                            fontWeight: hovered ? FontWeight.w400 : null,
                            decoration: TextDecoration.underline,
                            decorationColor: color,
                            decorationThickness: 1.2,
                          ),
                        ),
                      );
                    },
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
