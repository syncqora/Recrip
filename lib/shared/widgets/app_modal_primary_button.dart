import 'package:flutter/material.dart';

import '../../app/screens/authentication/widgets/app_constants.dart';

/// Shared primary action button for dashboard modals (Create/Save/Renew/Update).
class AppModalPrimaryButton extends StatelessWidget {
  const AppModalPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 12),
    this.minimumSize,
    this.borderRadius = 10.0,
    this.enabledBackgroundColor = AppConstants.buttonEnabledColor,
    this.disabledBackgroundColor = AppConstants.buttonDisabledColor,
    this.foregroundColor = Colors.white,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onPressed;

  final EdgeInsetsGeometry padding;
  final Size? minimumSize;
  final double borderRadius;

  final Color enabledBackgroundColor;
  final Color disabledBackgroundColor;

  final Color foregroundColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final backgroundColor = isEnabled
        ? enabledBackgroundColor
        : disabledBackgroundColor;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
        minimumSize: minimumSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(label, style: textStyle ?? TextStyle(color: foregroundColor)),
    );
  }
}
