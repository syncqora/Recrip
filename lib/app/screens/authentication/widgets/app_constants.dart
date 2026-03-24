import 'package:flutter/material.dart';

/// Shared design constants for authentication screens.
abstract final class AppConstants {
  AppConstants._();

  // Colors
  static const Color cardBackground = Color(0xFFF8FAFC);
  static const Color titleColor = Color(0xFF4F46E5);
  static const Color labelColor = Color(0xFF0F172A);
  static const Color hintColor = Color(0xFF94A3B8);
  static const Color textColor = Color(0xFF0F172A);
  static const Color supportTextColor = Color(0xFF475569);
  static const Color borderColor = Color(0xFFE2E8F0);

  // Frequently reused shared UI colors (across multiple screens).
  static const Color dividerColor = Color(0xFFCBD5E1);
  static const Color softBorderColor = Color(0xFFE5E7EB);
  static const Color tableHeaderBackgroundColor = Color(0xFFEEF2FF);
  static const Color headerBackgroundColor = Color(0xFFF1F5F9);
  static const Color slate700Color = Color(0xFF334155);
  static const Color mutedTextColor = Color(0xFF666666);
  static const Color slateMutedColor = Color(0xFF64748B);

  // Status badge colors
  static const Color activeBadgeColor = Color(0xFFDCFCE7);
  static const Color activeBadgeTextColor = Color(0xFF166534);
  static const Color expiringBadgeColor = Color(0xFFFEF3C7);
  static const Color expiringBadgeTextColor = Color(0xFF92400E);
  static const Color expiringBadgeTextColorDark = Color(0xFFB45309);
  static const Color expiredBadgeColor = Color(0xFFFEE2E2);
  static const Color expiredBadgeTextColor = Color(0xFF991B1B);

  // Renewed badge colors (used by Renewals screen)
  static const Color renewedBadgeColor = Color(0xFFD1FAE5);
  static const Color renewedBadgeTextColor = Color(0xFF059669);

  // Extra common colors seen across the project
  static const Color dangerTextColor = Color(0xFFDC2626);
  static const Color amberTextColor = Color(0xFFF59E0B);
  static const Color greenTextColor = Color(0xFF16A34A);
  static const Color lightPeriwinkleColor = Color(0xFFC7D2FE);
  static const Color darkTextColor = Color(0xFF121212);
  static const Color appSoftBgColor = Color(0xFFEEEDFB);
  static const Color lightGrayFillColor = Color(0xFFFAFAFA);
  static const Color blackAlpha10 = Color(0x0F000000);
  static const Color blackAlpha25 = Color(0x40000000);

  static const Color focusedBorderColor = Color(0xFF6C63FF);
  static const Color buttonEnabledColor = Color(0xFF4F46E5);
  static const Color buttonDisabledColor = Color(0xFFA5B4FC);
  static const Color fieldFillColor = Color(0xFFFFFFFF);

  // Gradient
  static const Color gradientStart = Color(0xFF0F172A);
  static const Color gradientEnd = Color(0xFF334F90);
  static const double overlayOpacity = 0.80;

  // Dimensions
  static const double logoHeight = 48;
  static const double fieldHeight = 44;

  /// Minimum tap height; must fit label + vertical padding (avoid clipped text).
  static const double buttonHeight = 48;
  static const double cardBorderRadius = 12;
  static const double cardMinWidth = 495;
  static const double cardMinHeight = 671;
  static const double fieldBorderRadius = 10;

  // Spacing (from login reference)
  static const double spacingAfterLogo = 48;
  static const double spacingAfterTitle = 48;
  static const double spacingAfterLabel = 16;
  static const double spacingBetweenFields = 32;
  static const double spacingAfterButton = 80;
  static const double cardPaddingVertical = 48;
  static const double cardPaddingHorizontal = 108;
}
