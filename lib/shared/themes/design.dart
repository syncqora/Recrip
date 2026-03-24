import 'package:flutter/material.dart';

class AppColors {
  static const Color appPrimaryColorLight = Color(0xFF6200EE);
  static const Color appPrimaryColorDark = Color(0xFF3700B3);
  static const Color appSecondaryColorLight = Color(0xFF03DAC6);
  static const Color appSecondaryColorDark = Color(0xFF018786);
  static const Color appBackgroundColor = Colors.white;
  static const Color appErrorColor = Colors.red;
}

class AppTextStyles {
  static const TextStyle b24 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    //letterSpacing: 0.24,
    color: AppColors.appPrimaryColorLight,
  );

  static const TextStyle b14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.appPrimaryColorLight,
  );

  static const TextStyle b16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    //letterSpacing: 0.24,
    color: Colors.grey,
  );

  static const TextStyle b10 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: AppColors.appPrimaryColorLight,
  );

  static const TextStyle b12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.appPrimaryColorLight,
  );

  static const TextStyle w12 = TextStyle(
    fontSize: 12,
    color: AppColors.appPrimaryColorLight,
  );
  static const TextStyle wb12 = TextStyle(fontSize: 8, color: Colors.white);
  static const TextStyle w14 = TextStyle(fontSize: 14, color: Colors.black);

  static const TextStyle w50018 = TextStyle(
    fontSize: 18,
    color: AppColors.appPrimaryColorLight,
  );
}
