import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../authentication/widgets/auth_constants.dart';

class CreateRuleModalMobileView extends StatelessWidget {
  const CreateRuleModalMobileView({
    super.key,
    required this.selectedTrigger,
    required this.selectedTiming,
    required this.selectedAudience,
    required this.selectedStatus,
    required this.whatsApp,
    required this.email,
    required this.onTriggerTap,
    required this.onTimingTap,
    required this.onAudienceTap,
    required this.onStatusTap,
    required this.onWhatsAppChanged,
    required this.onEmailChanged,
    required this.onCancel,
    required this.onCreate,
    required this.isCreateEnabled,
  });

  final String? selectedTrigger;
  final String? selectedTiming;
  final String? selectedAudience;
  final String? selectedStatus;
  final bool whatsApp;
  final bool email;
  final VoidCallback onTriggerTap;
  final VoidCallback onTimingTap;
  final VoidCallback onAudienceTap;
  final VoidCallback onStatusTap;
  final ValueChanged<bool> onWhatsAppChanged;
  final ValueChanged<bool> onEmailChanged;
  final VoidCallback onCancel;
  final VoidCallback onCreate;
  final bool isCreateEnabled;

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
          icon: const Icon(Icons.arrow_back, color: AuthConstants.labelColor),
        ),
        title: Text(
          'Create Rule',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AuthConstants.labelColor,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(thickness: 1, color: Color(0xFFCBD5E1), height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Reminder Rule Details'),
                  const SizedBox(height: 16),
                  _buildLabel('Trigger'),
                  const SizedBox(height: 8),
                  _buildSelectField(selectedTrigger ?? 'Select Trigger', onTriggerTap),
                  const SizedBox(height: 16),
                  _buildLabel('Timing'),
                  const SizedBox(height: 8),
                  _buildSelectField(selectedTiming ?? 'Select Timing', onTimingTap),
                  const SizedBox(height: 16),
                  _buildLabel('Audience'),
                  const SizedBox(height: 8),
                  _buildSelectField(selectedAudience ?? 'Select Audience', onAudienceTap),
                  const SizedBox(height: 16),
                  _buildLabel('Status'),
                  const SizedBox(height: 8),
                  _buildSelectField(selectedStatus ?? 'Select Status', onStatusTap),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Reminder Channels'),
                  const SizedBox(height: 16),
                  _buildCheckbox('WhatsApp', whatsApp, onWhatsAppChanged),
                  const SizedBox(height: 12),
                  _buildCheckbox('Email', email, onEmailChanged),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1, height: 1, color: Color(0xFFCBD5E1)),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: _buildActions(),
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
        fontSize: 15,
      ),
    );
  }

  Widget _buildLabel(String text) {
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

  Widget _buildSelectField(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AuthConstants.fieldBorderRadius),
      child: Container(
        height: AuthConstants.fieldHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AuthConstants.fieldFillColor,
          borderRadius: BorderRadius.circular(AuthConstants.fieldBorderRadius),
          border: Border.all(color: AuthConstants.borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: text.contains('Select') ? AuthConstants.hintColor : AuthConstants.labelColor,
                  fontWeight: text.contains('Select') ? FontWeight.w500 : FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AuthConstants.hintColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool> onChanged) {
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
                if (states.contains(WidgetState.selected)) return Colors.transparent;
                return null;
              }),
              checkColor: AuthConstants.labelColor,
              side: const BorderSide(color: AuthConstants.borderColor, width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 12),
          Text(label, style: Get.textTheme.bodyMedium?.copyWith(color: AuthConstants.labelColor)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AuthConstants.fieldBorderRadius)),
              side: const BorderSide(color: AuthConstants.borderColor),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: isCreateEnabled ? onCreate : null,
            style: FilledButton.styleFrom(
              backgroundColor: isCreateEnabled ? AuthConstants.buttonEnabledColor : AuthConstants.buttonDisabledColor,
              disabledBackgroundColor: AuthConstants.buttonDisabledColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Create Rule'),
          ),
        ),
      ],
    );
  }
}
