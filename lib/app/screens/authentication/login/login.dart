import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/authentication/widgets/auth_widgets.dart';
import 'package:saas/shared/constants/app_strings.dart';

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
          title: AppStrings.loginTitle,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormFieldSection(
                label: AppStrings.loginEmailLabel,
                child: MouseRegion(
                  onEnter: (_) => controller.setUsernameHovered(true),
                  onExit: (_) => controller.setUsernameHovered(false),
                  child: Obx(
                    () => AuthTextField(
                      controller: controller.emailController,
                      focusNode: controller.emailFocusNode,
                      hint: AppStrings.loginEmailHint,
                      isHovered: controller.isUsernameHovered.value,
                      errorText: controller.emailError.value,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) =>
                          controller.passwordFocusNode.requestFocus(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingBetweenFields),
              AuthFormFieldSection(
                label: AppStrings.passwordLabel,
                child: MouseRegion(
                  onEnter: (_) => controller.setPasswordHovered(true),
                  onExit: (_) => controller.setPasswordHovered(false),
                  child: Obx(
                    () => AuthPasswordField(
                      controller: controller.passwordController,
                      focusNode: controller.passwordFocusNode,
                      obscureText: !controller.isPasswordVisible.value,
                      onToggleVisibility: controller.togglePasswordVisibility,
                      isHovered: controller.isPasswordHovered.value,
                      errorText: controller.passwordError.value,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => controller.onLogin(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingAfterLabel),
              Align(
                alignment: Alignment.centerRight,
                child: MouseRegion(
                  onEnter: (_) => controller.setForgotPasswordHovered(true),
                  onExit: (_) => controller.setForgotPasswordHovered(false),
                  child: Obx(() {
                    final hovered = controller.isForgotPasswordHovered.value;
                    final color = hovered
                        ? AppConstants.titleColor
                        : AppConstants.hintColor;
                    return TextButton(
                      onPressed: controller.onForgotPassword,
                      child: Text(
                        AppStrings.forgotPasswordTitle,
                        style: Get.theme.textTheme.labelMedium!.copyWith(
                          color: color,
                          fontWeight: hovered ? FontWeight.w400 : null,
                          decoration: TextDecoration.underline,
                          decorationColor: color,
                          decorationThickness: 1.2,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: AppConstants.spacingAfterLogo),
              Obx(
                () => AuthPrimaryButton(
                  text: AppStrings.loginTitle,
                  onPressed: controller.onLogin,
                  isEnabled: controller.isFormValid.value,
                  isLoading: controller.isSubmitting.value,
                ),
              ),
              const SizedBox(height: AppConstants.spacingAfterButton),
              AuthSupportFooter(onReachOut: controller.onReachOutTap),
            ],
          ),
        ),
      ),
    );
  }
}
