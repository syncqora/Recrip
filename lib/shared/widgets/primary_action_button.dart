import 'package:flutter/material.dart';

import '../../app/screens/authentication/widgets/app_constants.dart';

/// Standard primary action button used across dashboard screens.
class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.useFixedSize = true,
  });

  final String label;
  final VoidCallback? onPressed;

  /// When false, the parent can expand the button width (e.g. full-width on mobile).
  final bool useFixedSize;

  static const _padding = EdgeInsets.fromLTRB(20, 12, 20, 12);
  static const _height = 44.0;
  static const _borderRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Material(
      color: isEnabled
          ? AppConstants.buttonEnabledColor
          : AppConstants.buttonEnabledColor.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(_borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Container(
          padding: _padding,
          constraints: const BoxConstraints(
            minHeight: _height,
            maxHeight: _height,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
