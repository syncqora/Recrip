import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/routes/app_pages.dart';

import '../../../../core/di/get_injector.dart';
import 'app_constants.dart';
import 'package:saas/shared/constants/app_strings.dart';

/// Reusable support footer link for authentication screens.
/// Styled like the Forgot Password link: underlined, titleColor on hover.
class AuthSupportFooter extends StatefulWidget {
  const AuthSupportFooter({super.key, required this.onReachOut});

  final VoidCallback onReachOut;

  @override
  State<AuthSupportFooter> createState() => _AuthSupportFooterState();
}

class _AuthSupportFooterState extends State<AuthSupportFooter> {
  bool _isLinkHovered = false;

  @override
  Widget build(BuildContext context) {
    final linkColor = _isLinkHovered
        ? AppConstants.titleColor
        : AppConstants.hintColor;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            child: Text(
              AppStrings.anySupportRequiredText,
              style: Get.theme.textTheme.bodySmall?.copyWith(
                color: AppConstants.hintColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isLinkHovered = true),
            onExit: (_) => setState(() => _isLinkHovered = false),
            child: GestureDetector(
              onTap: () {},
              // onTap: widget.onReachOut,
              child: Text(
                AppStrings.reachOutToUsText,
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: linkColor,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  decorationColor: linkColor,
                  decorationThickness: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
