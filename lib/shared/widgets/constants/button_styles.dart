import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/shared/widgets/constants/widget_enums.dart';

import '../../themes/design.dart';

class AppButtonStyles {
  static BoxDecoration getButtonDecoration(
    Color? color,
    Color? borderColor,
    bool isEnabled,
    double? borderRadius,
  ) {
    final baseColor = color ?? AppColors.appPrimaryColorLight;
    final radius = borderRadius ?? 4.0;
    return BoxDecoration(
      color: isEnabled ? baseColor : baseColor.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        width: 1,
        color: isEnabled
            ? (borderColor ?? baseColor)
            : (borderColor ?? baseColor).withValues(alpha: 0.3),
      ),
    );
  }

  static TextStyle getTextStyle(
    TextStyle? textStyle, {
    Color color = Colors.white,
    double? fontSize = 14,
  }) {
    return textStyle ??
        Get.theme.textTheme.bodyMedium!.copyWith(
          color: color,
          fontSize: fontSize,
        );
  }

  static EdgeInsets getPadding(AppButtonType type) {
    switch (type) {
      case AppButtonType.compact:
        return const EdgeInsets.symmetric(vertical: 6, horizontal: 20);
      case AppButtonType.small:
        return const EdgeInsets.symmetric(vertical: 4, horizontal: 6);
      case AppButtonType.mini:
        return const EdgeInsets.symmetric(vertical: 0, horizontal: 4);
      // case AppButtonType.micro:
      //   return const EdgeInsets.symmetric(vertical: 0, horizontal: 2);
      case AppButtonType.inverted:
        return const EdgeInsets.symmetric(vertical: 8, horizontal: 24);
      case AppButtonType.newsFeedsReadMore:
        return const EdgeInsets.symmetric(vertical: 3.5, horizontal: 5);
      case AppButtonType.newsFeedsLockIcon:
        return const EdgeInsets.symmetric(vertical: 4, horizontal: 4);
      case AppButtonType.terminalDataRefresh:
        return const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0);
      case AppButtonType.loginCreateAccount:
        return const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0);
      case AppButtonType.roundedCorner:
        return const EdgeInsets.symmetric(horizontal: 52.0, vertical: 12.0);
      default:
        return const EdgeInsets.symmetric(vertical: 10, horizontal: 16);
    }
  }
}
