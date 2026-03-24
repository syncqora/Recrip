import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_constants.dart';

/// Reusable authentication form card with logo, title, and content slot.
class AuthFormCard extends StatelessWidget {
  const AuthFormCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.cardMinWidth,
      constraints: const BoxConstraints(minHeight: AppConstants.cardMinHeight),
      padding: const EdgeInsets.symmetric(
        vertical: AppConstants.cardPaddingVertical,
        horizontal: AppConstants.cardPaddingHorizontal,
      ),
      decoration: BoxDecoration(
        color: AppConstants.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        boxShadow: const [
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/recrip.png',
                height: AppConstants.logoHeight,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingAfterLogo),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppConstants.titleColor,
            ),
          ),
          const SizedBox(height: AppConstants.spacingAfterTitle),
          child,
        ],
      ),
    );
  }
}
