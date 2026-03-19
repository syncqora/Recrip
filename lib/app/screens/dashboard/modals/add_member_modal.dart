import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/app_close_button.dart';
import '../../../../shared/widgets/plan_dropdown.dart';
import '../../../../shared/widgets/success_toast.dart';
import '../../authentication/widgets/auth_constants.dart';
import '../../authentication/widgets/auth_form_field_section.dart';
import '../../authentication/widgets/auth_text_field.dart';
import 'add_member_modal_mobile_view.dart';
import 'add_member_modal_tablet_view.dart';
import 'subscription_utils.dart';

class AddMemberModal extends StatefulWidget {
  const AddMemberModal({
    super.key,
    this.initialFullName,
    this.initialPhone,
    this.initialPlan,
  });

  final String? initialFullName;
  final String? initialPhone;
  final String? initialPlan;

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

  @override
  void initState() {
    super.initState();
    if (isRenewMode) {
      _fullNameController.text = widget.initialFullName ?? '';
      _phoneController.text =
          (widget.initialPhone ?? '').replaceFirst(RegExp(r'^\+91\s*'), '').trim();
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
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select start date',
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
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        title: isRenewMode ? 'Renew Member' : 'Add Member',
        primaryButtonLabel: isRenewMode ? 'Renew' : 'Save Member',
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
        title: isRenewMode ? 'Renew Member' : 'Add Member',
        primaryButtonLabel: isRenewMode ? 'Renew' : 'Save Member',
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
                    const SizedBox(height: AuthConstants.spacingAfterLabel),
                    _buildMemberFields(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Subscription Details'),
                    const SizedBox(height: AuthConstants.spacingAfterLabel),
                    _buildSubscriptionFields(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Reminder Channels'),
                    const SizedBox(height: AuthConstants.spacingAfterLabel),
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
                isRenewMode ? 'Renew Member' : 'Add Member',
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
        color: AuthConstants.labelColor,
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
            label: 'Full Name*',
            spacingAfterLabel: 8,
            child: AuthTextField(
              controller: _fullNameController,
              hint: 'E.g. John Doe',
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AuthFormFieldSection(
            label: 'Phone Number',
            spacingAfterLabel: 8,
            child: SizedBox(
              height: AuthConstants.fieldHeight,
              child: TextField(
                controller: _phoneController,
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: AuthConstants.textColor,
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
                          color: AuthConstants.labelColor,
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
                    color: AuthConstants.hintColor,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: AuthConstants.fieldFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AuthConstants.fieldBorderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AuthConstants.borderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AuthConstants.fieldBorderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AuthConstants.borderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AuthConstants.fieldBorderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AuthConstants.focusedBorderColor,
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
            label: 'Email Address*',
            spacingAfterLabel: 8,
            child: AuthTextField(
              controller: _emailController,
              hint: 'E.g. John.doe@gmail.com',
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
                height: AuthConstants.fieldHeight,
                child: InkWell(
                  onTap: _pickStartDate,
                  borderRadius: BorderRadius.circular(
                    AuthConstants.fieldBorderRadius,
                  ),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: 'Select Date',
                      hintStyle: Get.theme.textTheme.labelMedium?.copyWith(
                        color: AuthConstants.hintColor,
                      ),
                      filled: true,
                      fillColor: AuthConstants.fieldFillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AuthConstants.fieldBorderRadius,
                        ),
                        borderSide: const BorderSide(
                          color: AuthConstants.borderColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AuthConstants.fieldBorderRadius,
                        ),
                        borderSide: const BorderSide(
                          color: AuthConstants.borderColor,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: AuthConstants.hintColor,
                      ),
                    ),
                    child: Text(
                      _startDate != null
                          ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                          : 'Select Date',
                      style: Get.theme.textTheme.bodySmall?.copyWith(
                        color: _startDate != null
                            ? AuthConstants.textColor
                            : AuthConstants.hintColor,
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
                  color: AuthConstants.labelColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Builder(
                builder: (_) {
                  final expiry = calculateExpiryDate(_selectedPlan, _startDate);
                  return Container(
                    width: double.infinity,
                    height: AuthConstants.fieldHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: AuthConstants.cardBackground,
                      borderRadius: BorderRadius.circular(
                        AuthConstants.fieldBorderRadius,
                      ),
                      border: Border.all(color: AuthConstants.borderColor),
                    ),
                    child: Text(
                      expiry != null
                          ? '${expiry.day}/${expiry.month}/${expiry.year}'
                          : '—',
                      style: Get.theme.textTheme.bodySmall?.copyWith(
                        color: expiry != null
                            ? AuthConstants.textColor
                            : AuthConstants.hintColor,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                'Calculated automatically',
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: AuthConstants.supportTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _requiredLabel(String text) {
    return RichText(
      text: TextSpan(
        style: Get.textTheme.bodySmall?.copyWith(
          color: AuthConstants.labelColor,
          fontSize: 14,
        ),
        children: [
          TextSpan(text: text),
          const TextSpan(
            text: '*',
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ],
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
              checkColor: AuthConstants.labelColor,
              side: WidgetStateBorderSide.resolveWith((states) =>
                  const BorderSide(
                    color: AuthConstants.borderColor,
                    width: 1,
                  )),
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
              color: AuthConstants.labelColor,
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
            onPressed: _isSaveEnabled ? _onSave : null,
            style: FilledButton.styleFrom(
              backgroundColor: _isSaveEnabled
                  ? AuthConstants.buttonEnabledColor
                  : AuthConstants.buttonDisabledColor,
              disabledBackgroundColor: AuthConstants.buttonDisabledColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              minimumSize: const Size(146, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              isRenewMode ? 'Renew' : 'Save Member',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
