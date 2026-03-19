import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/plan_dropdown.dart';
import '../../authentication/widgets/auth_constants.dart';
import 'subscription_utils.dart';
import '../../authentication/widgets/auth_form_field_section.dart';
import '../../authentication/widgets/auth_text_field.dart';

class AddMemberModalMobileView extends StatelessWidget {
  const AddMemberModalMobileView({
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
    this.title = 'Add Member',
    this.primaryButtonLabel = 'Save Member',
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
  final String title;
  final String primaryButtonLabel;

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
          icon: SvgPicture.asset(
            'assets/icons/back-button.svg',
            width: 20,
            height: 20,
          ),
          style: IconButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.all(12),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        title: Text(
          title,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AuthConstants.labelColor,
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
            _buildSectionTitle('Member Details'),
            const SizedBox(height: 16),
            AuthFormFieldSection(
              label: 'Full Name*',
              spacingAfterLabel: 8,
              child: AuthTextField(
                controller: fullNameController,
                hint: 'E.g. John Doe',
                dismissKeyboardOnTapOutside: false,
              ),
            ),
            const SizedBox(height: 16),
            AuthFormFieldSection(
              label: 'Phone Number',
              spacingAfterLabel: 8,
              child: SizedBox(
                height: AuthConstants.fieldHeight,
                child: TextField(
                  controller: phoneController,
                  onTapOutside: (_) {},
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
            const SizedBox(height: 16),
            AuthFormFieldSection(
              label: 'Email Address*',
              spacingAfterLabel: 8,
              child: AuthTextField(
                controller: emailController,
                hint: 'E.g. John.doe@gmail.com',
                dismissKeyboardOnTapOutside: false,
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Subscription Details'),
            const SizedBox(height: 16),
            _requiredLabel('Plan'),
            const SizedBox(height: 8),
            _buildPlanDropdown(),
            const SizedBox(height: 16),
            _requiredLabel('Start Date'),
            const SizedBox(height: 8),
            _buildStartDatePicker(),
            const SizedBox(height: 16),
            Text(
              'Expiry Date',
              style: Get.theme.textTheme.labelMedium?.copyWith(
                color: AuthConstants.labelColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildExpiryDisplay(),
            const SizedBox(height: 24),
            _buildSectionTitle('Reminder Channels'),
            const SizedBox(height: 16),
            _buildReminderChannels(),
            const SizedBox(height: 140),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                thickness: 1,
                height: 1,
                color: Color(0xFFCBD5E1),
              ),
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
        fontWeight: FontWeight.bold,
        color: AuthConstants.labelColor,
        fontSize: 14,
      ),
    );
  }

  Widget _buildPlanDropdown() {
    return PlanDropdown(
      value: selectedPlan,
      onChanged: onPlanChanged,
      hint: 'Choose a Plan',
    );
  }

  Widget _buildStartDatePicker() {
    return SizedBox(
      height: AuthConstants.fieldHeight,
      child: InkWell(
        onTap: onPickStartDate,
        borderRadius: BorderRadius.circular(AuthConstants.fieldBorderRadius),
        child: InputDecorator(
          decoration: InputDecoration(
            hintText: 'Select Date',
            filled: true,
            fillColor: AuthConstants.fieldFillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AuthConstants.fieldBorderRadius,
              ),
              borderSide: const BorderSide(color: AuthConstants.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AuthConstants.fieldBorderRadius,
              ),
              borderSide: const BorderSide(color: AuthConstants.borderColor),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              size: 18,
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
    );
  }

  Widget _buildExpiryDisplay() {
    final expiry = calculateExpiryDate(selectedPlan, startDate);
    return Container(
      width: double.infinity,
      height: AuthConstants.fieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AuthConstants.cardBackground,
        borderRadius: BorderRadius.circular(AuthConstants.fieldBorderRadius),
        border: Border.all(color: AuthConstants.borderColor),
      ),
      child: Text(
        expiry != null ? '${expiry.day}/${expiry.month}/${expiry.year}' : '—',
        style: Get.theme.textTheme.bodySmall?.copyWith(
          color: expiry != null
              ? AuthConstants.textColor
              : AuthConstants.hintColor,
        ),
      ),
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
    return Column(
      children: [
        _buildCheckbox('WhatsApp', whatsApp, onWhatsAppChanged),
        const SizedBox(height: 12),
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
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
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
              side: WidgetStateBorderSide.resolveWith(
                (states) => const BorderSide(
                  color: AuthConstants.borderColor,
                  width: 1,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 12),
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
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: AuthConstants.supportTextColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AuthConstants.fieldBorderRadius,
                ),
              ),
              side: const BorderSide(color: AuthConstants.borderColor),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: isSaveEnabled ? onSave : null,
            style: FilledButton.styleFrom(
              backgroundColor: isSaveEnabled
                  ? AuthConstants.buttonEnabledColor
                  : AuthConstants.buttonDisabledColor,
              disabledBackgroundColor: AuthConstants.buttonDisabledColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              primaryButtonLabel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
