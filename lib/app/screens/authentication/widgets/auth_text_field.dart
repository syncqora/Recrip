import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_constants.dart';

/// Reusable styled text field for authentication screens.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.isHovered = false,
  });

  final TextEditingController controller;
  final String hint;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AuthConstants.fieldHeight,
      child: TextField(
        controller: controller,
        style: Get.theme.textTheme.bodySmall?.copyWith(
          color: AuthConstants.textColor,
        ),
        cursorColor: AuthConstants.textColor,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Get.theme.textTheme.labelMedium!.copyWith(
            color: AuthConstants.hintColor,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: AuthConstants.fieldFillColor,
          hoverColor: AuthConstants.fieldFillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AuthConstants.fieldBorderRadius,
            ),
            borderSide: const BorderSide(color: AuthConstants.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AuthConstants.fieldBorderRadius,
            ),
            borderSide: BorderSide(
              color: isHovered
                  ? AuthConstants.focusedBorderColor
                  : AuthConstants.borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AuthConstants.fieldBorderRadius,
            ),
            borderSide: const BorderSide(
              color: AuthConstants.focusedBorderColor,
            ),
          ),
        ),
      ),
    );
  }
}
