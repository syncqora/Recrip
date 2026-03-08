import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_constants.dart';

/// Reusable authentication form card with logo, title, and content slot.
class AuthFormCard extends StatelessWidget {
  const AuthFormCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AuthConstants.cardMinWidth,
      constraints: const BoxConstraints(minHeight: AuthConstants.cardMinHeight),
      padding: const EdgeInsets.symmetric(
        vertical: AuthConstants.cardPaddingVertical,
        horizontal: AuthConstants.cardPaddingHorizontal,
      ),
      decoration: BoxDecoration(
        color: AuthConstants.cardBackground,
        borderRadius: BorderRadius.circular(AuthConstants.cardBorderRadius),
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
                'assets/images/saas-logo.png',
                height: AuthConstants.logoHeight,
              ),
            ],
          ),
          const SizedBox(height: AuthConstants.spacingAfterLogo),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AuthConstants.titleColor,
            ),
          ),
          const SizedBox(height: AuthConstants.spacingAfterTitle),
          child,
        ],
      ),
    );
  }
}
