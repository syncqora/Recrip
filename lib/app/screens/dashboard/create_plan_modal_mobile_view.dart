import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authentication/widgets/auth_constants.dart';
import '../authentication/widgets/auth_form_field_section.dart';
import 'create_plan_modal.dart';

class CreatePlanModalMobileView extends StatelessWidget {
  const CreatePlanModalMobileView({
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
    required this.onCreate,
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
  final VoidCallback onCreate;

  static const _inputBorderRadius = 10.0;
  static const _inputBorderColor = Color(0xFFE2E8F0);
  static const _labelColor = Color(0xFF0F172A);
  static const _hintColor = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
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
                        style: Get.textTheme.bodyMedium?.copyWith(color: _labelColor, fontSize: 14),
                        decoration: _inputDecoration('Enter Plan Name'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AuthFormFieldSection(
                      label: 'Price',
                      spacingAfterLabel: 8,
                      child: TextField(
                        controller: priceController,
                        style: Get.textTheme.bodyMedium?.copyWith(color: _labelColor, fontSize: 14),
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
                                    color: selectedStatus != null ? _labelColor : _hintColor,
                                  ),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xFF64748B)),
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
                    const SizedBox(height: 24),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              'Create Plan',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: _labelColor,
                fontSize: 18,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: InkWell(
              onTap: onCancel,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 18, color: Color(0xFF475569)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: _labelColor, fontSize: 15),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: Get.theme.textTheme.bodyMedium?.copyWith(color: _hintColor, fontSize: 14),
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
        borderSide: const BorderSide(color: AuthConstants.focusedBorderColor, width: 1.5),
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
                  color: isSelected ? AuthConstants.buttonEnabledColor : _inputBorderColor,
                  width: 1.5,
                ),
                color: isSelected ? AuthConstants.buttonEnabledColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(Icons.circle, size: 6, color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(label, style: Get.textTheme.bodyMedium?.copyWith(color: _labelColor, fontSize: 14)),
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
              const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF64748B)),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Widget _buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: onCreate,
          style: FilledButton.styleFrom(
            backgroundColor: AuthConstants.buttonEnabledColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Create Plan'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF334155),
            side: const BorderSide(color: _inputBorderColor),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_inputBorderRadius)),
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
