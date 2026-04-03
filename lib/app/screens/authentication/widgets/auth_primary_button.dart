import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_constants.dart';

/// Reusable primary action button for authentication screens.
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isEnabled,
    this.isLoading = false,
    this.enabledBackgroundColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;
  /// When provided and [isEnabled], used instead of [AppConstants.buttonEnabledColor].
  final Color? enabledBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final active = isEnabled && !isLoading;
    return ElevatedButton(
      onPressed: active ? onPressed : null,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: Size(double.infinity, AppConstants.buttonHeight),
        backgroundColor: active
            ? (enabledBackgroundColor ?? AppConstants.buttonEnabledColor)
            : AppConstants.buttonDisabledColor,
        disabledBackgroundColor: AppConstants.buttonDisabledColor,
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: Colors.white,
              ),
            )
          : Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
    );
  }
}
