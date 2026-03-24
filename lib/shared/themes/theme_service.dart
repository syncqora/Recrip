import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/di/get_injector.dart';
import '../constants/box_constants.dart';

class ThemeService {
  final RxBool isDarkTheme = false.obs;
  ThemeMode getThemeMode() {
    return isDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool isDarkMode() {
    isDarkTheme.value = boxDb.readBoolValue(key: BoxConstants.isDarkMode);
    return isDarkTheme.value;
  }

  void saveThemeMode(bool isDarkMode) {
    boxDb.writeBoolValue(key: BoxConstants.isDarkMode, value: isDarkMode);
    isDarkTheme.value = isDarkMode;
  }

  // void changeThemeMode() {
  //   Get.changeThemeMode(isDarkMode() ? ThemeMode.light : ThemeMode.dark);
  //   saveThemeMode(!_isDarkTheme);
  // }

  void toggleThemMode() {
    final newThemeMode = !isDarkTheme.value;

    // Apply the new theme
    Get.changeThemeMode(newThemeMode ? ThemeMode.dark : ThemeMode.light);

    // Save the new theme mode
    saveThemeMode(newThemeMode);
  }
}
