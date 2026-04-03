import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/app_close_button.dart';
import '../../../../shared/widgets/plan_dropdown.dart';
import '../../../../shared/widgets/app_modal_primary_button.dart';
import '../../../../shared/widgets/success_toast.dart';
import '../../authentication/widgets/app_constants.dart';
import '../../authentication/widgets/auth_form_field_section.dart';
import '../../authentication/widgets/auth_text_field.dart';
import 'add_member_modal_mobile_view.dart';
import 'add_member_modal_tablet_view.dart';
import 'subscription_utils.dart';
import 'package:saas/shared/utils/app_date_picker.dart';

class AddMemberModal extends StatefulWidget {
  const AddMemberModal({
    super.key,
    this.initialFullName,
    this.initialPhone,
    this.initialPlan,
    this.isEditMode = false,
  });

  final String? initialFullName;
  final String? initialPhone;
  final String? initialPlan;
  final bool isEditMode;

  @override
  State<AddMemberModal> createState() => _AddMemberModalState();
}

class _AddMemberModalState extends State<AddMemberModal> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedPlan;
  DateTime? _startDate;
  bool _whatsApp = false;
  bool _email = false;

  bool get isRenewMode =>
      widget.initialFullName != null || widget.initialPhone != null;
  bool get isEditMode => widget.isEditMode;
  bool get _isNameEditable => !(isRenewMode || isEditMode);

  @override
  void initState() {
    super.initState();
    if (isRenewMode) {
      _fullNameController.text = widget.initialFullName ?? '';
      _phoneController.text = (widget.initialPhone ?? '')
          .replaceFirst(RegExp(r'^\+91\s*'), '')
          .trim();
      _selectedPlan = widget.initialPlan;
    }
    _fullNameController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
  }

  void _onFormChanged() => setState(() {});

  @override
  void dispose() {
    _fullNameController.removeListener(_onFormChanged);
    _phoneController.removeListener(_onFormChanged);
    _emailController.removeListener(_onFormChanged);
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool get _isSaveEnabled =>
      _fullNameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _selectedPlan != null &&
      _startDate != null;

  Future<void> _pickStartDate() async {
    final date = await showAppDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select start date',
    );
    if (date != null) setState(() => _startDate = date);
  }

  void _onSave() {
    if (_fullNameController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Please enter Full Name');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Please enter Email Address');
      return;
    }
    if (_selectedPlan == null) {
      Get.snackbar('Required', 'Please choose a Plan');
      return;
    }
    if (_startDate == null) {
      Get.snackbar('Required', 'Please select Start Date');
      return;
    }
    SuccessToast.show(
      context,
      title: 'Member Added Successfully!',
      popRoute: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return AddMemberModalMobileView(
        fullNameController: _fullNameController,
        phoneController: _phoneController,
        emailController: _emailController,
        selectedPlan: _selectedPlan,
        startDate: _startDate,
        whatsApp: _whatsApp,
        email: _email,
        onPickStartDate: _pickStartDate,
        onPlanChanged: (v) => setState(() => _selectedPlan = v),
        onWhatsAppChanged: (v) => setState(() => _whatsApp = v),
        onEmailChanged: (v) => setState(() => _email = v),
        onCancel: () => Navigator.of(context).pop(),
        onSave: _onSave,
        isSaveEnabled: _isSaveEnabled,
        isNameEditable: _isNameEditable,
        title: isEditMode
            ? 'Edit Member'
            : isRenewMode
            ? 'Renew Member'
            : 'Add Member',
        primaryButtonLabel: isEditMode
            ? 'Save Changes'
            : isRenewMode
            ? 'Renew'
            : 'Save Member',
      );
    }

    if (width < 1024) {
      return AddMemberModalTabletView(
        fullNameController: _fullNameController,
        phoneController: _phoneController,
        emailController: _emailController,
        selectedPlan: _selectedPlan,
        startDate: _startDate,
        whatsApp: _whatsApp,
        email: _email,
        onPickStartDate: _pickStartDate,
        onPlanChanged: (v) => setState(() => _selectedPlan = v),
        onWhatsAppChanged: (v) => setState(() => _whatsApp = v),
        onEmailChanged: (v) => setState(() => _email = v),
        onCancel: () => Navigator.of(context).pop(),
        onSave: _onSave,
        isSaveEnabled: _isSaveEnabled,
        isNameEditable: _isNameEditable,
        title: isEditMode
            ? 'Edit Member'
            : isRenewMode
            ? 'Renew Member'
            : 'Add Member',
        primaryButtonLabel: isEditMode
            ? 'Save Changes'
            : isRenewMode
            ? 'Renew'
            : 'Save Member',
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Container(
        width: 869,
        height: 589,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildHeader(),
            Divider(thickness: 1, color: Color(0xFFCBD5E1)),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 8, 32, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Member Details'),
                    const SizedBox(height: AppConstants.spacingAfterLabel),
                    _buildMemberFields(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Subscription Details'),
                    const SizedBox(height: AppConstants.spacingAfterLabel),
                    _buildSubscriptionFields(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Reminder Channels'),
                    const SizedBox(height: AppConstants.spacingAfterLabel),
                    _buildReminderChannels(),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 1, height: 1, color: Color(0xFFCBD5E1)),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
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
                isEditMode
                    ? 'Edit Member'
                    : isRenewMode
                    ? 'Renew Member'
                    : 'Add Member',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
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
      style: Get.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppConstants.labelColor,
        fontSize: 16,
      ),
    );
  }

  Widget _buildMemberFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AuthFormFieldSection(
            label: 'Full Name',
            spacingAfterLabel: 8,
            child: SizedBox(
              height: AppConstants.fieldHeight,
              child: TextField(
                controller: _fullNameController,
                readOnly: !_isNameEditable,
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: AppConstants.textColor,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'E.g. John Doe',
                  hintStyle: Get.theme.textTheme.labelMedium?.copyWith(
                    color: AppConstants.hintColor,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: AppConstants.fieldFillColor,
                  hoverColor: AppConstants.lightGrayFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.fieldBorderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AppConstants.borderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.fieldBorderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AppConstants.borderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.fieldBorderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AppConstants.focusedBorderColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AuthFormFieldSection(
            label: 'Phone Number',
            spacingAfterLabel: 8,
            child: SizedBox(
              height: AppConstants.fieldHeight,
              child: TextField(
                controller: _phoneController,
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: AppConstants.textColor,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 4),
                    child: Align(
                      widthFactor: 1.0,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '+91 ',
                        style: Get.theme.textTheme.labelMedium?.copyWith(
                          color: AppConstants.labelColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  hintText: '00000 00000',
                  hintStyle: Get.theme.textTheme.labelMedium?.copyWith(
                    color: AppConstants.hintColor,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: AppConstants.fieldFillColor,
                  hoverColor: AppConstants.lightGrayFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.fieldBorderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AppConstants.borderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.fieldBorderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AppConstants.borderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.fieldBorderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AppConstants.focusedBorderColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AuthFormFieldSection(
            label: 'Email Address',
            spacingAfterLabel: 8,
            child: SizedBox(
              height: AppConstants.fieldHeight,
              child: TextField(
                controller: _emailController,
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: AppConstants.textColor,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'E.g. John.doe@gmail.com',
                  hintStyle: Get.theme.textTheme.labelMedium?.copyWith(
                    color: AppConstants.hintColor,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: AppConstants.fieldFillColor,
                  hoverColor: AppConstants.lightGrayFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.fieldBorderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AppConstants.borderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.fieldBorderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AppConstants.borderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.fieldBorderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AppConstants.focusedBorderColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _requiredLabel('Plan'),
              const SizedBox(height: 8),
              PlanDropdown(
                value: _selectedPlan,
                onChanged: (v) => setState(() => _selectedPlan = v),
                hint: 'Choose a Plan',
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _requiredLabel('Start Date'),
              const SizedBox(height: 8),
              SizedBox(
                height: AppConstants.fieldHeight,
                child: Material(
                  color: AppConstants.fieldFillColor,
                  borderRadius: BorderRadius.circular(
                    AppConstants.fieldBorderRadius,
                  ),
                  child: InkWell(
                    onTap: _pickStartDate,
                    hoverColor: AppConstants.lightGrayFillColor,
                    borderRadius: BorderRadius.circular(
                      AppConstants.fieldBorderRadius,
                    ),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        hintText: 'Select Date',
                        hintStyle: Get.theme.textTheme.labelMedium?.copyWith(
                          color: AppConstants.hintColor,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.fieldBorderRadius,
                          ),
                          borderSide: const BorderSide(
                            color: AppConstants.borderColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.fieldBorderRadius,
                          ),
                          borderSide: const BorderSide(
                            color: AppConstants.borderColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        suffixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: AppConstants.hintColor,
                        ),
                      ),
                      child: Text(
                        _startDate != null
                            ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                            : 'Select Date',
                        style: Get.theme.textTheme.bodySmall?.copyWith(
                          color: _startDate != null
                              ? AppConstants.textColor
                              : AppConstants.hintColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expiry Date',
                style: Get.theme.textTheme.labelMedium?.copyWith(
                  color: AppConstants.labelColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Builder(
                builder: (_) {
                  final expiry = calculateExpiryDate(_selectedPlan, _startDate);
                  return CustomPaint(
                    foregroundPainter: _DashedBorderPainter(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: AppConstants.fieldBorderRadius,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: AppConstants.fieldHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(
                          AppConstants.fieldBorderRadius,
                        ),
                      ),
                      child: Text(
                        expiry != null
                            ? '${expiry.day}/${expiry.month}/${expiry.year}'
                            : '—',
                        style: Get.theme.textTheme.bodySmall?.copyWith(
                          color: expiry != null
                              ? AppConstants.textColor
                              : AppConstants.hintColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _requiredLabel(String text) {
    return Text(
      text,
      style: Get.textTheme.bodySmall?.copyWith(
        color: AppConstants.labelColor,
        fontSize: 14,
      ),
    );
  }

  Widget _buildReminderChannels() {
    return Row(
      children: [
        _buildCheckbox(
          'WhatsApp',
          _whatsApp,
          (v) => setState(() => _whatsApp = v),
        ),
        const SizedBox(width: 32),
        _buildCheckbox('Email', _email, (v) => setState(() => _email = v)),
      ],
    );
  }

  Widget _buildCheckbox(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.transparent;
                }
                return null;
              }),
              checkColor: AppConstants.labelColor,
              side: WidgetStateBorderSide.resolveWith(
                (states) =>
                    const BorderSide(color: AppConstants.borderColor, width: 1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: AppConstants.labelColor,
            ),
          ),
        ],
      ),
    );
  }

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
              foregroundColor: AppConstants.supportTextColor,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              minimumSize: const Size(94, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  width: 1,
                  color: AppConstants.borderColor,
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
          child: AppModalPrimaryButton(
            label: isRenewMode ? 'Renew' : 'Save Member',
            onPressed: _isSaveEnabled ? _onSave : null,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            minimumSize: const Size(146, 44),
            borderRadius: 10,
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.borderRadius});

  final Color color;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
      Radius.circular(borderRadius - 1),
    );
    final path = Path()..addRRect(rrect);
    double distance = 0;
    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + dashSpace;
      }
      distance = 0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
