import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app_constants.dart';

/// Reusable OTP input row for authentication screens.
class AuthOtpInput extends StatelessWidget {
  const AuthOtpInput({
    super.key,
    required this.length,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });

  final int length;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(int index, String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        length,
        (index) => _OtpField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          onChanged: (value) => onChanged(index, value),
        ),
      ),
    );
  }
}

class _OtpField extends StatelessWidget {
  const _OtpField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConstants.fieldHeight,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: Get.theme.textTheme.titleMedium?.copyWith(
          color: AppConstants.textColor,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppConstants.fieldFillColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
            borderSide: const BorderSide(color: AppConstants.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
            borderSide: const BorderSide(color: AppConstants.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
            borderSide: const BorderSide(
              color: AppConstants.focusedBorderColor,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
