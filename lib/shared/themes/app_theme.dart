import 'package:flutter/material.dart';

import 'design.dart';

class AppTheme {
  static const _inter = 'Inter';

  static TextTheme _lightTextTheme() {
    return TextTheme(
      headlineMedium: AppTextStyles.w50018.copyWith(
        color: Colors.black,
        fontFamily: _inter,
      ),
      bodyLarge: AppTextStyles.b24.copyWith(
        color: const Color(0xFFFFFFFF),
        fontFamily: _inter,
      ),
      bodyMedium: AppTextStyles.b16.copyWith(
        color: const Color(0xFFFFFFFF),
        fontFamily: _inter,
      ),
      bodySmall: AppTextStyles.b14.copyWith(
        color: Colors.black,
        fontFamily: _inter,
      ),
      labelLarge: AppTextStyles.w14.copyWith(
        color: Colors.black,
        fontFamily: _inter,
      ),
      labelMedium: AppTextStyles.b12.copyWith(
        color: Colors.black,
        fontFamily: _inter,
      ),
      labelSmall: AppTextStyles.b10.copyWith(
        color: Colors.black,
        letterSpacing: 0.0,
        fontFamily: _inter,
      ),
    );
  }

  static TextTheme _darkTextTheme() {
    return TextTheme(
      headlineMedium: AppTextStyles.w50018.copyWith(
        color: Colors.white,
        fontFamily: _inter,
      ),
      bodyLarge: AppTextStyles.b24.copyWith(
        color: Colors.white,
        fontFamily: _inter,
      ),
      bodyMedium: AppTextStyles.b16.copyWith(
        color: Colors.white,
        fontFamily: _inter,
      ),
      bodySmall: AppTextStyles.b14.copyWith(
        color: Colors.white,
        fontFamily: _inter,
      ),
      labelLarge: AppTextStyles.w14.copyWith(
        color: Colors.white,
        fontFamily: _inter,
      ),
      labelMedium: AppTextStyles.b12.copyWith(
        color: Colors.white,
        fontFamily: _inter,
      ),
      labelSmall: AppTextStyles.b10.copyWith(
        color: Colors.white,
        letterSpacing: 0.0,
        fontFamily: _inter,
      ),
    );
  }

  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: _inter,
    primaryColor: Colors.white,
    primaryColorLight: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    listTileTheme: ListTileThemeData(tileColor: Colors.black12),
    colorScheme: ColorScheme.fromSeed(
      primary: Colors.black,
      seedColor: Colors.black,
    ),
    textTheme: Typography.material2021().black
        .apply(fontFamily: _inter)
        .merge(_lightTextTheme()),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: _inter,
    primaryColor: Colors.black,
    primaryColorDark: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    canvasColor: Colors.black,
    listTileTheme: ListTileThemeData(tileColor: Colors.white10),
    colorScheme: ColorScheme.fromSeed(
      primary: Colors.white,
      seedColor: Colors.white,
    ),
    textTheme: Typography.material2021().white
        .apply(fontFamily: _inter)
        .merge(_darkTextTheme()),
  );
}
