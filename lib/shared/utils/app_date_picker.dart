import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/screens/authentication/widgets/app_constants.dart';

Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  String? helpText,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    helpText: helpText,
    initialEntryMode: DatePickerEntryMode.calendar,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppConstants.buttonEnabledColor,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AppConstants.labelColor,
            surfaceContainerHighest: AppConstants.cardBackground,
          ),
          dialogTheme: DialogThemeData(
            elevation: 16,
            shadowColor: Colors.black.withValues(alpha: 0.2),
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            headerBackgroundColor: AppConstants.buttonEnabledColor,
            headerForegroundColor: Colors.white,
            headerHeadlineStyle: Get.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
            headerHelpStyle: Get.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontFamily: 'Inter',
            ),
            weekdayStyle: Get.textTheme.bodySmall?.copyWith(
              color: AppConstants.supportTextColor,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
            dayStyle: Get.textTheme.bodyMedium?.copyWith(
              color: AppConstants.labelColor,
              fontFamily: 'Inter',
            ),
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return Colors.white;
              if (states.contains(WidgetState.disabled)) {
                return AppConstants.hintColor;
              }
              return AppConstants.labelColor;
            }),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppConstants.buttonEnabledColor;
              }
              return null;
            }),
            dayShape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            todayBorder: const BorderSide(
              color: AppConstants.buttonEnabledColor,
              width: 1.5,
            ),
            yearStyle: Get.textTheme.bodyLarge?.copyWith(
              color: AppConstants.labelColor,
              fontFamily: 'Inter',
            ),
            yearForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return Colors.white;
              return AppConstants.labelColor;
            }),
            yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppConstants.buttonEnabledColor;
              }
              return null;
            }),
            yearShape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            dividerColor: AppConstants.borderColor,
            cancelButtonStyle: TextButton.styleFrom(
              foregroundColor: AppConstants.supportTextColor,
              textStyle: Get.textTheme.labelLarge?.copyWith(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            confirmButtonStyle: FilledButton.styleFrom(
              backgroundColor: AppConstants.buttonEnabledColor,
              foregroundColor: Colors.white,
              textStyle: Get.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}
