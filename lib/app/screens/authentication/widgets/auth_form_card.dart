import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_constants.dart';

/// Reusable authentication form card with logo, title, and content slot.
class AuthFormCard extends StatelessWidget {
  const AuthFormCard({
    super.key,
    required this.title,
    required this.child,
    this.compact = false,
    this.showLogo = true,
    /// When set, replaces logo + [title] block (e.g. landing hero). [title] is ignored.
    this.customHeader,
    /// Corner radius in logical pixels. Defaults to [AppConstants.cardBorderRadius].
    this.cornerRadius,
    /// Card fill color. Defaults to [AppConstants.cardBackground].
    this.cardColor,
    /// Shadow(s) under the card. Defaults to a light drop shadow.
    this.boxShadow,
  });

  final String title;
  final Widget child;
  /// Smaller padding and spacing (e.g. landing page hero login card).
  final bool compact;
  final bool showLogo;
  final Widget? customHeader;
  final double? cornerRadius;
  final Color? cardColor;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final vPad = compact ? 24.0 : AppConstants.cardPaddingVertical;
    final hPad = compact ? 28.0 : AppConstants.cardPaddingHorizontal;
    final afterLogo = compact ? 20.0 : AppConstants.spacingAfterLogo;
    final afterTitle = compact ? 20.0 : AppConstants.spacingAfterTitle;
    final logoHeight = compact ? 40.0 : AppConstants.logoHeight;

    final radius = cornerRadius ?? AppConstants.cardBorderRadius;
    final fill = cardColor ?? AppConstants.cardBackground;

    return Container(
      width: compact ? double.infinity : AppConstants.cardMinWidth,
      constraints: BoxConstraints(
        minWidth: compact ? 0 : AppConstants.cardMinWidth,
        maxWidth: compact ? 400 : double.infinity,
        minHeight: compact ? 0 : AppConstants.cardMinHeight,
      ),
      padding: EdgeInsets.symmetric(vertical: vPad, horizontal: hPad),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: boxShadow ??
            const [
              BoxShadow(
                color: Color(0x40000000),
                offset: Offset(0, 4),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (customHeader != null) ...[
            customHeader!,
            SizedBox(height: afterTitle),
          ] else ...[
            if (showLogo) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/recrip.webp',
                    height: logoHeight,
                  ),
                ],
              ),
              SizedBox(height: afterLogo),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: Get.theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppConstants.titleColor,
                fontSize: compact ? 16 : null,
              ),
            ),
            SizedBox(height: afterTitle),
          ],
          child,
        ],
      ),
    );
  }
}
