import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/success_toast.dart';
import '../authentication/widgets/auth_constants.dart';
import '../authentication/widgets/auth_form_field_section.dart';
import 'create_plan_modal.dart';

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
  const EditPlanModal({super.key, required this.plan});

  final EditPlanData plan;

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
    _selectedDuration = _durationFromString(widget.plan.duration);
    _selectedStatus = widget.plan.isActive ? 'Active' : 'Inactive';
  }

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
    _planNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickCustomDates() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _customStartDate != null && _customEndDate != null
          ? DateTimeRange(start: _customStartDate!, end: _customEndDate!)
          : null,
    );
    if (range != null) {
      setState(() {
        _customStartDate = range.start;
        _customEndDate = range.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.close, size: 18, color: Color(0xFF475569)),
                ),
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
              style: Get.textTheme.bodyMedium?.copyWith(color: _labelColor, fontSize: 14),
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
              style: Get.textTheme.bodyMedium?.copyWith(color: _labelColor, fontSize: 14),
              decoration: _inputDecoration('Enter Plan Price'),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AuthFormFieldSection(
            label: 'Status*',
            spacingAfterLabel: 8,
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
                        color: _selectedStatus != null ? _labelColor : _hintColor,
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
                  color: isSelected ? AuthConstants.buttonEnabledColor : _inputBorderColor,
                  width: 1.5,
                ),
                color: isSelected ? AuthConstants.buttonEnabledColor : Colors.transparent,
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
              style: Get.textTheme.bodyMedium?.copyWith(color: _labelColor, fontSize: 14),
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
            onTap: _pickCustomDates,
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
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: Color(0xFF64748B),
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
        FilledButton(
          onPressed: () {
            SuccessToast.show(
              context,
              title: 'Changes Saved Successfully!',
              popRoute: true,
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: AuthConstants.buttonEnabledColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            minimumSize: const Size(0, 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_inputBorderRadius),
            ),
          ),
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}
