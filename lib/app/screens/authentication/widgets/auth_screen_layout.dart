import 'package:flutter/material.dart';

import 'app_constants.dart';

/// Reusable authentication screen layout with background image and gradient overlay.
class AuthScreenLayout extends StatelessWidget {
  const AuthScreenLayout({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/login-background.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned.fill(
          child: Opacity(
            opacity: AppConstants.overlayOpacity,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppConstants.gradientStart,
                    AppConstants.gradientEnd,
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(padding: padding, child: child),
        ),
      ],
    );
  }
}
