import 'package:flutter/material.dart';

import '../../app/screens/authentication/widgets/auth_constants.dart';

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

  /// When true, uses a fixed size of 140x44. When false, uses this as a
  /// minimum size so the parent can expand the width (e.g. full-width on mobile).
  final bool useFixedSize;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle baseStyle = FilledButton.styleFrom(
      backgroundColor: AuthConstants.buttonEnabledColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final ButtonStyle style = useFixedSize
        ? baseStyle.copyWith(
            fixedSize:
                MaterialStateProperty.all<Size>(const Size(140, 44)),
          )
        : baseStyle.copyWith(
            minimumSize:
                MaterialStateProperty.all<Size>(const Size(140, 44)),
          );

    return FilledButton(
      onPressed: onPressed,
      style: style,
      child: Text(label),
    );
  }
}

