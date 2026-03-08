import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_constants.dart';

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
        ? AuthConstants.titleColor
        : AuthConstants.hintColor;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Any support required? ',
            style: Get.theme.textTheme.bodySmall?.copyWith(
              color: AuthConstants.hintColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isLinkHovered = true),
            onExit: (_) => setState(() => _isLinkHovered = false),
            child: GestureDetector(
              onTap: widget.onReachOut,
              child: Text(
                'Reach out to us',
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
