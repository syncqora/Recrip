import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../shared/widgets/success_toast.dart';
import '../../../../shared/widgets/app_close_button.dart';
import '../../authentication/widgets/auth_constants.dart';
import '../../authentication/widgets/auth_form_field_section.dart';
import 'create_plan_modal_mobile_view.dart';
import 'create_plan_modal_tablet_view.dart';

enum PlanDuration { days30, months3, months6, months12 }

/// Result passed to [CreatePlanModal.onCreate] when user taps Create Plan.
class CreatePlanResult {
  const CreatePlanResult({
    required this.planName,
    required this.duration,
    required this.price,
    required this.isActive,
  });
  final String planName;
  final String duration;
  final String price;
  final bool isActive;
}

class CreatePlanModal extends StatefulWidget {
  const CreatePlanModal({super.key, this.onCreate});

  final void Function(CreatePlanResult)? onCreate;

  @override
  State<CreatePlanModal> createState() => _CreatePlanModalState();
}

class _CreatePlanModalState extends State<CreatePlanModal> {
  final _planNameController = TextEditingController();
  final _priceController = TextEditingController();

  PlanDuration? _selectedDuration;
  DateTime? _customStartDate;
  String? _selectedStatus;

  static const _inputBorderRadius = 10.0;
  static const _inputBorderColor = Color(0xFFE2E8F0);
  static const _labelColor = Color(0xFF0F172A);
  static const _hintColor = Color(0xFF94A3B8);
  static const _statusMenuBorderRadius = 12.0;
  static const _statusMenuElevation = 8.0;
  static const EdgeInsets _statusItemPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );

  bool get _isCreateEnabled =>
      _planNameController.text.trim().isNotEmpty &&
      _priceController.text.trim().isNotEmpty &&
      _selectedStatus != null &&
      (_selectedDuration != null || _customStartDate != null);

  @override
  void initState() {
    super.initState();
    _planNameController.addListener(_onFormChanged);
    _priceController.addListener(_onFormChanged);
  }

  void _onFormChanged() => setState(() {});

  @override
  void dispose() {
    _planNameController.removeListener(_onFormChanged);
    _priceController.removeListener(_onFormChanged);
    _planNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _showStatusMenu(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final pos = box.localToGlobal(Offset.zero);
    final size = box.size;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        pos.dx,
        pos.dy + size.height + 4,
        pos.dx + size.width,
        pos.dy + size.height + 8,
      ),
      constraints: BoxConstraints(
        minWidth: size.width,
        maxWidth: size.width,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_statusMenuBorderRadius),
      ),
      color: Colors.white,
      elevation: _statusMenuElevation,
      items: [
        PopupMenuItem<String>(
          value: 'Active',
          padding: _statusItemPadding,
          child: Text(
            'Active',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: AuthConstants.labelColor,
              fontSize: 14,
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'Inactive',
          padding: _statusItemPadding,
          child: Text(
            'Inactive',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: AuthConstants.labelColor,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
    if (selected != null) {
      setState(() => _selectedStatus = selected);
    }
  }

  Future<void> _pickCustomDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _customStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select custom date',
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AuthConstants.buttonEnabledColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AuthConstants.labelColor,
              surfaceContainerHighest: AuthConstants.cardBackground,
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
              headerBackgroundColor: AuthConstants.buttonEnabledColor,
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
                color: AuthConstants.supportTextColor,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
              dayStyle: Get.textTheme.bodyMedium?.copyWith(
                color: AuthConstants.labelColor,
                fontFamily: 'Inter',
              ),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return Colors.white;
                if (states.contains(WidgetState.disabled)) {
                  return AuthConstants.hintColor;
                }
                return AuthConstants.labelColor;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AuthConstants.buttonEnabledColor;
                }
                return null;
              }),
              dayShape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              todayBorder: BorderSide(
                color: AuthConstants.buttonEnabledColor,
                width: 1.5,
              ),
              yearStyle: Get.textTheme.bodyLarge?.copyWith(
                color: AuthConstants.labelColor,
                fontFamily: 'Inter',
              ),
              yearForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return Colors.white;
                return AuthConstants.labelColor;
              }),
              yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AuthConstants.buttonEnabledColor;
                }
                return null;
              }),
              yearShape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              dividerColor: AuthConstants.borderColor,
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: AuthConstants.supportTextColor,
                textStyle: Get.textTheme.labelLarge?.copyWith(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              confirmButtonStyle: FilledButton.styleFrom(
                backgroundColor: AuthConstants.buttonEnabledColor,
                foregroundColor: Colors.white,
                textStyle: Get.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
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
    if (date != null) setState(() => _customStartDate = date);
  }

  String _getDurationString() {
    if (_selectedDuration != null) {
      switch (_selectedDuration!) {
        case PlanDuration.days30:
          return '30 Days';
        case PlanDuration.months3:
          return '3 Months';
        case PlanDuration.months6:
          return '6 Months';
        case PlanDuration.months12:
          return '12 Months';
      }
    }
    if (_customStartDate != null) {
      return _formatDate(_customStartDate!);
    }
    return 'Custom';
  }

  void _onCreate() {
    if (!_isCreateEnabled) return;
    final result = CreatePlanResult(
      planName: _planNameController.text.trim(),
      duration: _getDurationString(),
      price: _priceController.text.trim(),
      isActive: _selectedStatus == 'Active',
    );
    if (widget.onCreate != null) {
      widget.onCreate!(result);
    } else {
      SuccessToast.show(
        context,
        title: 'Plan Created Successfully!',
        popRoute: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return CreatePlanModalMobileView(
        planNameController: _planNameController,
        priceController: _priceController,
        selectedDuration: _selectedDuration,
        customStartDate: _customStartDate,
        selectedStatus: _selectedStatus,
        onPickCustomDates: _pickCustomDate,
        onDurationChanged: (v) => setState(() => _selectedDuration = v),
        onStatusTap: () {
          // Simple mock for status selection
          setState(() => _selectedStatus = _selectedStatus == 'Active' ? 'Inactive' : 'Active');
        },
        onCancel: () => Navigator.of(context).pop(),
        onCreate: _onCreate,
        isCreateEnabled: _isCreateEnabled,
      );
    }

    if (width < 1024) {
      return CreatePlanModalTabletView(
        planNameController: _planNameController,
        priceController: _priceController,
        selectedDuration: _selectedDuration,
        customStartDate: _customStartDate,
        selectedStatus: _selectedStatus,
        onPickCustomDates: _pickCustomDate,
        onDurationChanged: (v) => setState(() => _selectedDuration = v),
        onStatusTap: () {
          setState(() => _selectedStatus = _selectedStatus == 'Active' ? 'Inactive' : 'Active');
        },
        onCancel: () => Navigator.of(context).pop(),
        onCreate: _onCreate,
        isCreateEnabled: _isCreateEnabled,
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 820),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Plan Details'),
                    const SizedBox(height: 14),
                    _buildPlanDetailsRow(),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Select Plan Duration'),
                    const SizedBox(height: 14),
                    _buildDurationRadios(),
                    const SizedBox(height: 18),
                    _buildCustomDurationField(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              height: 1,
              color: Color(0xFFE2E8F0),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
              child: _buildActions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48),
          Expanded(
            child: Center(
              child: Text(
                'Create Plan',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                  fontSize: 20,
                ),
              ),
            ),
          ),
          AppCloseButton(onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: _labelColor,
        fontSize: 16,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: Get.theme.textTheme.bodyMedium?.copyWith(
        color: _hintColor,
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputBorderRadius),
        borderSide: const BorderSide(color: _inputBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputBorderRadius),
        borderSide: const BorderSide(color: _inputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputBorderRadius),
        borderSide: const BorderSide(
          color: AuthConstants.focusedBorderColor,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Widget _buildPlanDetailsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: AuthFormFieldSection(
            label: 'Plan Name*',
            spacingAfterLabel: 8,
            child: TextField(
              controller: _planNameController,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: _labelColor,
                fontSize: 14,
              ),
              decoration: _inputDecoration('Enter Plan Name'),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AuthFormFieldSection(
            label: 'Price',
            spacingAfterLabel: 8,
            child: TextField(
              controller: _priceController,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: _labelColor,
                fontSize: 14,
              ),
              decoration: _inputDecoration('Enter Plan Price'),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AuthFormFieldSection(
            label: 'Status*',
            spacingAfterLabel: 8,
            child: Builder(
              builder: (context) {
                return InkWell(
                  onTap: () => _showStatusMenu(context),
                  borderRadius: BorderRadius.circular(_inputBorderRadius),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_inputBorderRadius),
                      border: Border.all(color: _inputBorderColor),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedStatus ?? 'Select Plan Status',
                            style: Get.theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              color: _selectedStatus != null
                                  ? _labelColor
                                  : _hintColor,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: _hintColor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationRadios() {
    return Row(
      children: [
        _durationRadio(PlanDuration.days30, '30 Days'),
        const SizedBox(width: 24),
        _durationRadio(PlanDuration.months3, '3 Months'),
        const SizedBox(width: 24),
        _durationRadio(PlanDuration.months6, '6 Months'),
        const SizedBox(width: 24),
        _durationRadio(PlanDuration.months12, '12 Months'),
      ],
    );
  }

  Widget _durationRadio(PlanDuration value, String label) {
    final isSelected = _selectedDuration == value;
    return InkWell(
      onTap: () => setState(() => _selectedDuration = value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AuthConstants.buttonEnabledColor
                      : _inputBorderColor,
                  width: 1.5,
                ),
                color: isSelected
                    ? AuthConstants.buttonEnabledColor
                    : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: _labelColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _customDurationFieldWidth = 240.0;

  Widget _buildCustomDurationField() {
    final dateText =
        _customStartDate != null ? _formatDate(_customStartDate!) : null;
    return SizedBox(
      width: _customDurationFieldWidth,
      child: AuthFormFieldSection(
        label: 'Custom Date*',
        spacingAfterLabel: 8,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _pickCustomDate,
            borderRadius: BorderRadius.circular(_inputBorderRadius),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_inputBorderRadius),
                border: Border.all(color: _inputBorderColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      dateText ?? 'Select Date',
                      style: Get.theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: dateText != null ? _labelColor : _hintColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/calendar-days.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF64748B),
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 94,
          height: 44,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AuthConstants.supportTextColor,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              minimumSize: const Size(94, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  width: 1,
                  color: AuthConstants.borderColor,
                ),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 146,
          height: 44,
          child: FilledButton(
            onPressed: _isCreateEnabled ? _onCreate : null,
            style: FilledButton.styleFrom(
              backgroundColor: _isCreateEnabled
                  ? AuthConstants.buttonEnabledColor
                  : AuthConstants.buttonDisabledColor,
              disabledBackgroundColor: AuthConstants.buttonDisabledColor,
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              minimumSize: const Size(146, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Create Plan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
