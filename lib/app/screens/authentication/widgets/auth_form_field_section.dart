import 'package:flutter/material.dart';

import 'app_constants.dart';
import 'auth_form_field_label.dart';

/// Reusable form field section with label and spacing.
class AuthFormFieldSection extends StatelessWidget {
  const AuthFormFieldSection({
    super.key,
    required this.label,
    required this.child,
    this.spacingAfterLabel = AppConstants.spacingAfterLabel,
  });

  final String label;
  final Widget child;
  final double spacingAfterLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthFormFieldLabel(label: label),
        SizedBox(height: spacingAfterLabel),
        child,
      ],
    );
  }
}
