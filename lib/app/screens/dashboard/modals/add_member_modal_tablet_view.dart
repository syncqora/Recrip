import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/plan_dropdown.dart';
import '../../authentication/widgets/auth_constants.dart';
import 'subscription_utils.dart';
import '../../authentication/widgets/auth_form_field_section.dart';
import '../../authentication/widgets/auth_text_field.dart';

class AddMemberModalTabletView extends StatelessWidget {
  const AddMemberModalTabletView({
    super.key,
    required this.fullNameController,
    required this.phoneController,
    required this.emailController,
    required this.selectedPlan,
    required this.startDate,
    required this.whatsApp,
    required this.email,
    required this.onPickStartDate,
    required this.onPlanChanged,
    required this.onWhatsAppChanged,
    required this.onEmailChanged,
    required this.onCancel,
    required this.onSave,
    required this.isSaveEnabled,
  });

  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final String? selectedPlan;
  final DateTime? startDate;
  final bool whatsApp;
  final bool email;
  final VoidCallback onPickStartDate;
  final ValueChanged<String?> onPlanChanged;
  final ValueChanged<bool> onWhatsAppChanged;
  final ValueChanged<bool> onEmailChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isSaveEnabled;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
      child: Container(
        width: 760,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const Divider(thickness: 1, color: Color(0xFFCBD5E1), height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Member Details'),
                    const SizedBox(height: 16),
                    _buildMemberFields(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Subscription Details'),
                    const SizedBox(height: 16),
                    _buildSubscriptionFields(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Reminder Channels'),
                    const SizedBox(height: 16),
                    _buildReminderChannels(),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 1, height: 1, color: Color(0xFFCBD5E1)),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 20, 32, 24),
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
                'Add Member',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onCancel,
            icon: SvgPicture.asset(
              'assets/icons/close-button.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AuthConstants.hintColor,
                BlendMode.srcIn,
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
              controller: fullNameController,
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
                controller: phoneController,
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: AuthConstants.textColor,
                ),
                cursorColor: AuthConstants.textColor,
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
              controller: emailController,
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
                value: selectedPlan,
                onChanged: onPlanChanged,
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
                  onTap: onPickStartDate,
                  borderRadius: BorderRadius.circular(
                    AuthConstants.fieldBorderRadius,
                  ),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: 'Select Date',
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
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: AuthConstants.hintColor,
                      ),
                    ),
                    child: Text(
                      startDate != null
                          ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                          : 'Select Date',
                      style: Get.theme.textTheme.bodySmall?.copyWith(
                        color: startDate != null
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
                  final expiry = calculateExpiryDate(selectedPlan, startDate);
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
        _buildCheckbox('WhatsApp', whatsApp, onWhatsAppChanged),
        const SizedBox(width: 32),
        _buildCheckbox('Email', email, onEmailChanged),
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
              activeColor: AuthConstants.buttonEnabledColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
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
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(
            foregroundColor: AuthConstants.supportTextColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AuthConstants.fieldBorderRadius,
              ),
            ),
          ),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 160,
          height: 44,
          child: FilledButton(
            onPressed: isSaveEnabled ? onSave : null,
            style: FilledButton.styleFrom(
              backgroundColor: isSaveEnabled
                  ? AuthConstants.buttonEnabledColor
                  : AuthConstants.buttonDisabledColor,
              disabledBackgroundColor: AuthConstants.buttonDisabledColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Save Member',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
