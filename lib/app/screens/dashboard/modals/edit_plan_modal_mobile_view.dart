import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../authentication/widgets/app_constants.dart';
import '../../authentication/widgets/auth_form_field_section.dart';
import '../../../../shared/widgets/app_modal_primary_button.dart';
import 'create_plan_modal.dart';
import 'package:saas/shared/constants/app_icons.dart';

class EditPlanModalMobileView extends StatelessWidget {
  const EditPlanModalMobileView({
    super.key,
    required this.planNameController,
    required this.priceController,
    required this.selectedDuration,
    required this.customStartDate,
    required this.customEndDate,
    required this.selectedStatus,
    required this.onPickCustomDates,
    required this.onDurationChanged,
    required this.onStatusTap,
    required this.onCancel,
    required this.onSave,
  });

  final TextEditingController planNameController;
  final TextEditingController priceController;
  final PlanDuration? selectedDuration;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final String? selectedStatus;
  final VoidCallback onPickCustomDates;
  final ValueChanged<PlanDuration> onDurationChanged;
  final VoidCallback onStatusTap;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  static const _inputBorderRadius = 10.0;
  static const _inputBorderColor = Color(0xFFE2E8F0);
  static const _labelColor = Color(0xFF0F172A);
  static const _hintColor = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: onCancel,
          icon: SvgPicture.asset(AppIcons.backButton, width: 20, height: 20),
          style: IconButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.all(12),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        title: Text(
          'Edit Plan',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppConstants.labelColor,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(thickness: 1, color: Color(0xFFCBD5E1), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Plan Details'),
            const SizedBox(height: 16),
            AuthFormFieldSection(
              label: 'Plan Name*',
              spacingAfterLabel: 8,
              child: TextField(
                controller: planNameController,
                onTapOutside: (_) {},
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: _labelColor,
                  fontSize: 14,
                ),
                decoration: _inputDecoration('Enter Plan Name'),
              ),
            ),
            const SizedBox(height: 16),
            AuthFormFieldSection(
              label: 'Price',
              spacingAfterLabel: 8,
              child: TextField(
                controller: priceController,
                onTapOutside: (_) {},
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: _labelColor,
                  fontSize: 14,
                ),
                decoration: _inputDecoration('Enter Plan Price'),
              ),
            ),
            const SizedBox(height: 16),
            AuthFormFieldSection(
              label: 'Status*',
              spacingAfterLabel: 8,
              child: InkWell(
                onTap: onStatusTap,
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
                          selectedStatus ?? 'Select Plan Status',
                          style: Get.theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: selectedStatus != null
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
            const SizedBox(height: 24),
            _buildSectionTitle('Select Plan Duration'),
            const SizedBox(height: 12),
            _buildDurationRadios(),
            const SizedBox(height: 16),
            _buildCustomDurationField(),
            const SizedBox(height: 140),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(thickness: 1, height: 1, color: Color(0xFFCBD5E1)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: _buildActions(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: _labelColor,
        fontSize: 14,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
    );
  }

  Widget _buildDurationRadios() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _durationRadio(PlanDuration.days30, '30 Days')),
            Expanded(child: _durationRadio(PlanDuration.months3, '3 Months')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _durationRadio(PlanDuration.months6, '6 Months')),
            Expanded(child: _durationRadio(PlanDuration.months12, '12 Months')),
          ],
        ),
      ],
    );
  }

  Widget _durationRadio(PlanDuration value, String label) {
    final isSelected = selectedDuration == value;
    return InkWell(
      onTap: () => onDurationChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
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
                  ? const Center(
                      child: Icon(Icons.circle, size: 6, color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
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

  Widget _buildCustomDurationField() {
    final dateText = customStartDate != null && customEndDate != null
        ? '${_formatDate(customStartDate!)} - ${_formatDate(customEndDate!)}'
        : null;
    return AuthFormFieldSection(
      label: 'Custom Duration*',
      spacingAfterLabel: 8,
      child: InkWell(
        onTap: onPickCustomDates,
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
                ),
              ),
              SvgPicture.asset(
                AppIcons.calendarDays,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF64748B),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppConstants.supportTextColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.fieldBorderRadius,
                ),
              ),
              side: const BorderSide(color: AppConstants.borderColor),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppModalPrimaryButton(
            label: 'Save Changes',
            onPressed: onSave,
            padding: const EdgeInsets.symmetric(vertical: 12),
            borderRadius: 10,
          ),
        ),
      ],
    );
  }
}
