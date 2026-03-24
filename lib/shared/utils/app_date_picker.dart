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
  // Use CalendarDatePicker to avoid numeric/text input mode.
  final localizations = MaterialLocalizations.of(context);
  final today = DateUtils.dateOnly(DateTime.now());
  final normalizedFirstDate = DateUtils.dateOnly(firstDate);
  final effectiveFirstDate = normalizedFirstDate.compareTo(today) < 0
      ? today
      : normalizedFirstDate;
  final effectiveInitialDate = initialDate.isBefore(effectiveFirstDate)
      ? effectiveFirstDate
      : DateUtils.dateOnly(initialDate);

  return showDialog<DateTime?>(
    context: context,
    builder: (dialogContext) {
      DateTime selectedDate = effectiveInitialDate;
      return Theme(
        data: Theme.of(dialogContext).copyWith(
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
            dividerColor: AppConstants.borderColor,
          ),
        ),
        child: StatefulBuilder(
          builder: (stateContext, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: helpText == null ? null : Text(helpText),
              content: SizedBox(
                width: 360,
                child: CalendarDatePicker(
                  // CalendarDatePicker takes `initialDate` (not `selectedDate`).
                  initialDate: selectedDate,
                  firstDate: effectiveFirstDate,
                  lastDate: lastDate,
                  currentDate: today,
                  onDateChanged: (DateTime value) {
                    setState(() => selectedDate = value);
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(stateContext).pop(null),
                  child: Text(
                    localizations.cancelButtonLabel,
                    style: Get.textTheme.labelLarge?.copyWith(
                      color: AppConstants.supportTextColor,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(stateContext).pop(selectedDate),
                  child: Text(
                    localizations.okButtonLabel,
                    style: Get.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
