import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'app_constants.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'package:saas/shared/constants/app_icons.dart';

/// Reusable password field with visibility toggle for authentication screens.
class AuthPasswordField extends StatelessWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
    this.hint = AppStrings.enterPasswordHint,
    this.isHovered = false,
  });

  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String hint;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.fieldHeight,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: Get.theme.textTheme.bodySmall?.copyWith(
          color: AppConstants.textColor,
        ),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Get.theme.textTheme.labelMedium!.copyWith(
            color: AppConstants.hintColor,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: AppConstants.fieldFillColor,
          hoverColor: AppConstants.fieldFillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
            borderSide: BorderSide(
              color: isHovered
                  ? AppConstants.focusedBorderColor
                  : Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
            borderSide: const BorderSide(
              color: AppConstants.focusedBorderColor,
            ),
          ),
          suffixIcon: IconButton(
            onPressed: onToggleVisibility,
            icon: SvgPicture.asset(
              obscureText ? AppIcons.eyeClose : AppIcons.eyeOpen,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Color(0xFF64748B),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
