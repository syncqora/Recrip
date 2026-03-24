import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_constants.dart';

/// Reusable styled text field for authentication screens.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.isHovered = false,
    this.fillColor = AppConstants.fieldFillColor,
    this.dismissKeyboardOnTapOutside = true,
    this.errorText,
    this.keyboardType,
    this.autocorrect = true,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final bool isHovered;
  final Color fillColor;
  final bool dismissKeyboardOnTapOutside;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool autocorrect;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      autocorrect: autocorrect,
      onTapOutside: dismissKeyboardOnTapOutside
          ? (_) => FocusManager.instance.primaryFocus?.unfocus()
          : (_) {},
      style: Get.theme.textTheme.bodySmall?.copyWith(
        color: AppConstants.textColor,
      ),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        errorText: errorText,
        errorMaxLines: 3,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        constraints: BoxConstraints(minHeight: AppConstants.fieldHeight),
        hintText: hint,
        hintStyle: Get.theme.textTheme.labelMedium!.copyWith(
          color: AppConstants.hintColor,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: fillColor,
        hoverColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
          borderSide: const BorderSide(color: AppConstants.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
          borderSide: BorderSide(
            color: isHovered
                ? AppConstants.focusedBorderColor
                : AppConstants.borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
          borderSide: const BorderSide(color: AppConstants.focusedBorderColor),
        ),
      ),
    );
  }
}
