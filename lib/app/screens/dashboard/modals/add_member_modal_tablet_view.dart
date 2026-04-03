import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/app_close_button.dart';
import '../../../../shared/widgets/plan_dropdown.dart';
import '../../../../shared/widgets/app_modal_primary_button.dart';
import '../../authentication/widgets/app_constants.dart';
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
    required this.isNameEditable,
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
  final bool isNameEditable;
  final String title;
  final String primaryButtonLabel;

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
                title,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.labelColor,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          AppCloseButton(onPressed: onCancel),
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
            child: AuthTextField(
              controller: fullNameController,
              hint: 'E.g. John Doe',
              readOnly: !isNameEditable,
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
                controller: phoneController,
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
                height: AppConstants.fieldHeight,
                child: InkWell(
                  onTap: onPickStartDate,
                  borderRadius: BorderRadius.circular(
                    AppConstants.fieldBorderRadius,
                  ),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: 'Select Date',
                      filled: true,
                      fillColor: AppConstants.fieldFillColor,
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
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: AppConstants.hintColor,
                      ),
                    ),
                    child: Text(
                      startDate != null
                          ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                          : 'Select Date',
                      style: Get.theme.textTheme.bodySmall?.copyWith(
                        color: startDate != null
                            ? AppConstants.textColor
                            : AppConstants.hintColor,
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
                  final expiry = calculateExpiryDate(selectedPlan, startDate);
                  return Container(
                    width: double.infinity,
                    height: AppConstants.fieldHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: AppConstants.cardBackground,
                      borderRadius: BorderRadius.circular(
                        AppConstants.fieldBorderRadius,
                      ),
                      border: Border.all(color: AppConstants.borderColor),
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
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(
            foregroundColor: AppConstants.supportTextColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.fieldBorderRadius,
              ),
            ),
          ),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 160,
          height: 44,
          child: AppModalPrimaryButton(
            label: primaryButtonLabel,
            onPressed: isSaveEnabled ? onSave : null,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            minimumSize: const Size(160, 44),
            borderRadius: 10,
          ),
        ),
      ],
    );
  }
}
