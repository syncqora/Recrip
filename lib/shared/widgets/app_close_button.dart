import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/screens/authentication/widgets/auth_constants.dart';

/// Reusable close button used across dashboard modals/dialogs.
///
/// Default behavior: no grey hover/splash background (keeps hover clean).
class AppCloseButton extends StatelessWidget {
  const AppCloseButton({
    super.key,
    required this.onPressed,
    this.iconColor = AuthConstants.hintColor,
    this.iconSize = 24,
    this.hitSize = 40,
    this.backgroundColor = Colors.transparent,
    this.hoverBackgroundColor = const Color(0xFFF1F5F9),
    this.showHoverBackground = false,
  });

  final VoidCallback onPressed;
  final Color iconColor;
  final double iconSize;
  final double hitSize;

  /// Background color of the circular hit area.
  /// Useful when the design requires a visible grey circle.
  final Color backgroundColor;

  /// Background color shown on hover/splash when [showHoverBackground] is true.
  final Color hoverBackgroundColor;

  /// When true, the hover/splash uses a light grey background.
  /// When false, hover/splash is transparent.
  final bool showHoverBackground;

  @override
  Widget build(BuildContext context) {
    final hoverColor = showHoverBackground ? hoverBackgroundColor : Colors.transparent;

    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        hoverColor: hoverColor,
        highlightColor: hoverColor,
        splashColor: hoverColor,
        child: SizedBox(
          width: hitSize,
          height: hitSize,
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/close-button.svg',
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}

