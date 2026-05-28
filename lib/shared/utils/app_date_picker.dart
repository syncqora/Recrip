import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/screens/authentication/widgets/app_constants.dart';

Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  String? helpText,
  bool useGridCalendarStyle = false,
}) {
  // Use CalendarDatePicker to avoid numeric/text input mode.
  final localizations = MaterialLocalizations.of(context);
  final today = DateUtils.dateOnly(DateTime.now());
  final normalizedFirstDate = DateUtils.dateOnly(firstDate);
  final effectiveFirstDate = normalizedFirstDate;
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
            headerBackgroundColor: useGridCalendarStyle
                ? Colors.white
                : AppConstants.buttonEnabledColor,
            headerForegroundColor: useGridCalendarStyle
                ? AppConstants.labelColor
                : Colors.white,
            headerHeadlineStyle: Get.textTheme.headlineMedium?.copyWith(
              color: useGridCalendarStyle
                  ? AppConstants.labelColor
                  : Colors.white,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
            headerHelpStyle: Get.textTheme.bodySmall?.copyWith(
              color: useGridCalendarStyle
                  ? AppConstants.labelColor
                  : Colors.white.withValues(alpha: 0.9),
              fontFamily: 'Inter',
            ),
            weekdayStyle: Get.textTheme.bodySmall?.copyWith(
              color: AppConstants.labelColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
            dayStyle: Get.textTheme.bodyMedium?.copyWith(
              color: AppConstants.labelColor,
              fontFamily: 'Inter',
            ),
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return Colors.white;
              if (states.contains(WidgetState.disabled)) {
                // Keep previous/next month days visible but muted.
                return const Color(0xFF9CA3AF);
              }
              return AppConstants.labelColor;
            }),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppConstants.buttonEnabledColor;
              }
              if (useGridCalendarStyle &&
                  states.contains(WidgetState.disabled)) {
                return const Color(0xFFF3F4F6);
              }
              return null;
            }),
            dayOverlayColor: WidgetStateProperty.resolveWith((states) {
              if (!useGridCalendarStyle) return null;
              if (states.contains(WidgetState.pressed)) {
                return const Color(0x334F46E5);
              }
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused)) {
                return const Color(0x1F4F46E5);
              }
              return null;
            }),
            dayShape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  useGridCalendarStyle ? 0 : 12,
                ),
                side: useGridCalendarStyle
                    ? const BorderSide(color: Color(0xFFE5E7EB), width: 1)
                    : BorderSide.none,
              ),
            ),
            todayBorder: useGridCalendarStyle
                ? const BorderSide(
                    color: AppConstants.buttonEnabledColor,
                    width: 1.2,
                  )
                : const BorderSide(
                    color: AppConstants.buttonEnabledColor,
                    width: 1.5,
                  ),
            todayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return Colors.white;
              return AppConstants.buttonEnabledColor;
            }),
            todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppConstants.buttonEnabledColor;
              }
              return Colors.white;
            }),
            dividerColor: AppConstants.borderColor,
          ),
        ),
        child: useGridCalendarStyle
            ? Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: SizedBox(
                  width: 470,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
                    child: _AnimatedGridCalendarPicker(
                      initialDate: selectedDate,
                      firstDate: effectiveFirstDate,
                      lastDate: lastDate,
                      onDateSelected: (value) =>
                          Navigator.of(dialogContext).pop(value),
                    ),
                  ),
                ),
              )
            : StatefulBuilder(
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
                        onPressed: () =>
                            Navigator.of(stateContext).pop(selectedDate),
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

class _AnimatedGridCalendarPicker extends StatefulWidget {
  const _AnimatedGridCalendarPicker({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<_AnimatedGridCalendarPicker> createState() =>
      _AnimatedGridCalendarPickerState();
}

class _AnimatedGridCalendarPickerState
    extends State<_AnimatedGridCalendarPicker>
    with TickerProviderStateMixin {
  static const double _calendarBodyHeight = 308;
  late DateTime _selectedDate;
  late DateTime _displayMonth;
  bool _forward = true;
  bool _showYearPicker = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateUtils.dateOnly(widget.initialDate);
    _displayMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
  }

  void _changeMonth(int delta) {
    setState(() {
      _forward = delta > 0;
      _displayMonth = DateTime(
        _displayMonth.year,
        _displayMonth.month + delta,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final monthLabel = localizations
        .formatMonthYear(_displayMonth)
        .split(' ')
        .first;
    final titleStyle = Get.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w800,
      color: AppConstants.labelColor,
    );
    final dayHeaderStyle = Get.textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: const Color(0xFF6B7280),
      letterSpacing: 0.2,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
          child: Row(
            children: [
              if (!_showYearPicker)
                _monthArrowButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => _changeMonth(-1),
                )
              else
                const SizedBox(width: 34),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(monthLabel, style: titleStyle),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () =>
                            setState(() => _showYearPicker = !_showYearPicker),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${_displayMonth.year}', style: titleStyle),
                              const SizedBox(width: 2),
                              Icon(
                                _showYearPicker
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: AppConstants.labelColor,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!_showYearPicker)
                _monthArrowButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: () => _changeMonth(1),
                )
              else
                const SizedBox(width: 34),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final isYearView = (child.key as ValueKey<String>).value
                  .startsWith('year-');
              final beginOffset = isYearView
                  ? const Offset(0, 0.06)
                  : (_forward ? const Offset(0.12, 0) : const Offset(-0.12, 0));
              final slide = Tween<Offset>(begin: beginOffset, end: Offset.zero)
                  .animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  );
              final scale =
                  Tween<double>(
                    begin: isYearView ? 0.97 : 0.99,
                    end: 1,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  );
              final fade = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              );
              return FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: slide,
                  child: ScaleTransition(scale: scale, child: child),
                ),
              );
            },
            child: _showYearPicker
                ? SizedBox(
                    key: ValueKey('year-${_displayMonth.year}'),
                    height: _calendarBodyHeight,
                    child: _buildYearGrid(),
                  )
                : SizedBox(
                    key: ValueKey(
                      '${_displayMonth.year}-${_displayMonth.month}',
                    ),
                    height: _calendarBodyHeight,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            children: localizations.narrowWeekdays
                                .map(
                                  (day) => Expanded(
                                    child: Center(
                                      child: Text(
                                        day.toUpperCase(),
                                        style: dayHeaderStyle,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(growable: false),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(child: _buildMonthGrid()),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthGrid() {
    final firstOfMonth = DateTime(_displayMonth.year, _displayMonth.month, 1);
    final offsetFromSunday = firstOfMonth.weekday % 7;
    final firstVisible = firstOfMonth.subtract(
      Duration(days: offsetFromSunday),
    );
    final days = List<DateTime>.generate(
      42,
      (index) => DateUtils.dateOnly(firstVisible.add(Duration(days: index))),
      growable: false,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.28,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
      ),
      itemBuilder: (context, index) {
        final day = days[index];
        final inCurrentMonth = day.month == _displayMonth.month;
        final isSelected = DateUtils.isSameDay(day, _selectedDate);
        final isDisabled =
            day.isBefore(DateUtils.dateOnly(widget.firstDate)) ||
            day.isAfter(DateUtils.dateOnly(widget.lastDate));

        final background = isSelected
            ? AppConstants.buttonEnabledColor
            : (!inCurrentMonth || isDisabled)
            ? const Color(0xFFF3F4F6)
            : Colors.white;
        final foreground = isSelected
            ? Colors.white
            : (!inCurrentMonth || isDisabled)
            ? const Color(0xFF9CA3AF)
            : AppConstants.labelColor;

        return Material(
          color: background,
          child: InkWell(
            onTap: isDisabled
                ? null
                : () {
                    _selectedDate = day;
                    widget.onDateSelected(day);
                  },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: foreground,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _monthArrowButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF8FAFC),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Icon(icon, size: 20, color: AppConstants.labelColor),
      ),
    );
  }

  Widget _buildYearGrid() {
    final startYear = widget.firstDate.year - 50;
    final endYear = widget.lastDate.year + 50;
    final years = List<int>.generate(
      (endYear - startYear) + 1,
      (index) => startYear + index,
      growable: false,
    );

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      itemCount: years.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 2.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final year = years[index];
        final isSelectedYear = year == _displayMonth.year;
        final isDisabled =
            year < widget.firstDate.year || year > widget.lastDate.year;
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: isDisabled
              ? null
              : () {
                  setState(() {
                    _displayMonth = DateTime(year, _displayMonth.month, 1);
                    _showYearPicker = false;
                  });
                },
          child: Container(
            decoration: BoxDecoration(
              color: isDisabled
                  ? const Color(0xFFF3F4F6)
                  : isSelectedYear
                  ? AppConstants.buttonEnabledColor
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDisabled
                    ? const Color(0xFFE5E7EB)
                    : isSelectedYear
                    ? AppConstants.buttonEnabledColor
                    : const Color(0xFFE2E8F0),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$year',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: isDisabled
                    ? const Color(0xFF9CA3AF)
                    : isSelectedYear
                    ? Colors.white
                    : AppConstants.labelColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}
