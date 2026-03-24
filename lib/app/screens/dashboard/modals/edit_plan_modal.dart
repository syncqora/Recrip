import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/success_toast.dart';
import '../../../../shared/widgets/app_close_button.dart';
import '../../../../shared/widgets/app_modal_primary_button.dart';
import '../../authentication/widgets/app_constants.dart';
import '../../authentication/widgets/auth_form_field_section.dart';
import 'create_plan_modal.dart';
import 'edit_plan_modal_mobile_view.dart';
import 'edit_plan_modal_tablet_view.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/utils/app_date_picker.dart';

/// Initial data for editing a plan.
class EditPlanData {
  const EditPlanData({
    required this.planName,
    required this.duration,
    required this.price,
    this.isActive = true,
  });

  final String planName;
  final String duration;
  final String price;
  final bool isActive;
}

class EditPlanModal extends StatefulWidget {
  const EditPlanModal({super.key, required this.plan, this.onSave});

  final EditPlanData plan;
  final void Function(EditPlanData)? onSave;

  @override
  State<EditPlanModal> createState() => _EditPlanModalState();
}

class _EditPlanModalState extends State<EditPlanModal> {
  late final TextEditingController _planNameController;
  late final TextEditingController _priceController;

  PlanDuration? _selectedDuration;
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  String? _selectedStatus;

  static const _inputBorderRadius = 10.0;
  static const _inputBorderColor = Color(0xFFE2E8F0);
  static const _labelColor = Color(0xFF0F172A);
  static const _hintColor = Color(0xFF94A3B8);

  @override
  void initState() {
    super.initState();
    _planNameController = TextEditingController(text: widget.plan.planName);
    _priceController = TextEditingController(text: widget.plan.price);
    _planNameController.addListener(_onFormChanged);
    _priceController.addListener(_onFormChanged);
    _selectedDuration = _durationFromString(widget.plan.duration);
    _selectedStatus = widget.plan.isActive ? 'Active' : 'Inactive';
  }

  void _onFormChanged() => setState(() {});

  PlanDuration? _durationFromString(String s) {
    switch (s) {
      case '30 Days':
        return PlanDuration.days30;
      case '3 Months':
        return PlanDuration.months3;
      case '6 Months':
        return PlanDuration.months6;
      case '12 Months':
        return PlanDuration.months12;
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _planNameController.removeListener(_onFormChanged);
    _priceController.removeListener(_onFormChanged);
    _planNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickCustomDate() async {
    final date = await showAppDatePicker(
      context: context,
      initialDate: _customStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select custom date',
    );
    if (date != null) {
      setState(() {
        _customStartDate = date;
        _customEndDate = date;
      });
    }
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
    if (_customStartDate != null && _customEndDate != null) {
      return '${_formatDate(_customStartDate!)} - ${_formatDate(_customEndDate!)}';
    }
    return widget.plan.duration;
  }

  void _onSave() {
    final updated = EditPlanData(
      planName: _planNameController.text.trim(),
      duration: _getDurationString(),
      price: _priceController.text.trim(),
      isActive: _selectedStatus == 'Active',
    );
    widget.onSave?.call(updated);
    SuccessToast.show(
      context,
      title: 'Changes Saved Successfully!',
      popRoute: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return EditPlanModalMobileView(
        planNameController: _planNameController,
        priceController: _priceController,
        selectedDuration: _selectedDuration,
        customStartDate: _customStartDate,
        customEndDate: _customEndDate,
        selectedStatus: _selectedStatus,
        onPickCustomDates: _pickCustomDate,
        onDurationChanged: (v) => setState(() => _selectedDuration = v),
        onStatusTap: () {
          setState(
            () => _selectedStatus = _selectedStatus == 'Active'
                ? 'Inactive'
                : 'Active',
          );
        },
        onCancel: () => Navigator.of(context).pop(),
        onSave: _onSave,
      );
    }

    if (width < 1024) {
      return EditPlanModalTabletView(
        planNameController: _planNameController,
        priceController: _priceController,
        selectedDuration: _selectedDuration,
        customStartDate: _customStartDate,
        customEndDate: _customEndDate,
        selectedStatus: _selectedStatus,
        onPickCustomDates: _pickCustomDate,
        onDurationChanged: (v) => setState(() => _selectedDuration = v),
        onStatusTap: () {
          setState(
            () => _selectedStatus = _selectedStatus == 'Active'
                ? 'Inactive'
                : 'Active',
          );
        },
        onCancel: () => Navigator.of(context).pop(),
        onSave: _onSave,
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 620),
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
                    _buildActions(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 22, 12, 18),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              'Edit Plan',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: _labelColor,
                fontSize: 20,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: AppCloseButton(
              onPressed: () => Navigator.of(context).pop(),
              hitSize: 36,
              iconSize: 18,
              iconColor: const Color(0xFF475569),
              backgroundColor: const Color(0xFFF1F5F9),
            ),
          ),
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
          color: AppConstants.focusedBorderColor,
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
            child: InkWell(
              onTap: () {
                setState(
                  () => _selectedStatus = _selectedStatus == 'Active'
                      ? 'Inactive'
                      : 'Active',
                );
              },
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
                        _selectedStatus ?? 'Select Plan Status',
                        style: Get.theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: _selectedStatus != null
                              ? _labelColor
                              : _hintColor,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Color(0xFF64748B),
                    ),
                  ],
                ),
              ),
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
                      ? AppConstants.buttonEnabledColor
                      : _inputBorderColor,
                  width: 1.5,
                ),
                color: isSelected
                    ? AppConstants.buttonEnabledColor
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
    final dateText = _customStartDate != null && _customEndDate != null
        ? '${_formatDate(_customStartDate!)} - ${_formatDate(_customEndDate!)}'
        : null;
    return SizedBox(
      width: _customDurationFieldWidth,
      child: AuthFormFieldSection(
        label: 'Custom Duration*',
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
                      dateText ?? 'Select Dates',
                      style: Get.theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: dateText != null ? _labelColor : _hintColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SvgPicture.asset(
                    AppIcons.calendarDays,
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
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF334155),
            side: const BorderSide(color: _inputBorderColor),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            minimumSize: const Size(0, 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_inputBorderRadius),
            ),
          ),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 14),
        AppModalPrimaryButton(
          label: 'Save Changes',
          onPressed: _onSave,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          minimumSize: const Size(0, 44),
          borderRadius: _inputBorderRadius,
          enabledBackgroundColor: AppConstants.buttonEnabledColor,
          disabledBackgroundColor: AppConstants.buttonDisabledColor,
        ),
      ],
    );
  }
}
