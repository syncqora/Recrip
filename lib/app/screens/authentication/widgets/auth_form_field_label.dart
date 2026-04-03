import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_constants.dart';

/// Reusable label for form fields in authentication screens.
class AuthFormFieldLabel extends StatelessWidget {
  const AuthFormFieldLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Get.theme.textTheme.labelMedium?.copyWith(
      color: AppConstants.labelColor,
      fontWeight: FontWeight.w600,
    );

    if (label.endsWith('*')) {
      final text = label.substring(0, label.length - 1);
      return RichText(
        text: TextSpan(
          style: labelStyle,
          children: [
            TextSpan(text: text),
            const TextSpan(
              text: '*',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    return Text(
      label,
      style: labelStyle,
    );
  }
}
