import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../authentication/widgets/auth_constants.dart';

class CreateRuleModalTabletView extends StatelessWidget {
  const CreateRuleModalTabletView({
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
                    _buildSectionTitle('Reminder Rule Details'),
                    const SizedBox(height: 16),
                    _buildGridFields(),
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
                'Create Rule',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AuthConstants.labelColor,
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
              colorFilter: const ColorFilter.mode(AuthConstants.hintColor, BlendMode.srcIn),
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

  Widget _buildGridFields() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildLabeledSelect('Trigger', selectedTrigger ?? 'Select Trigger', onTriggerTap)),
            const SizedBox(width: 16),
            Expanded(child: _buildLabeledSelect('Timing', selectedTiming ?? 'Select Timing', onTimingTap)),
            const SizedBox(width: 16),
            Expanded(child: _buildLabeledSelect('Audience', selectedAudience ?? 'Select Audience', onAudienceTap)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildLabeledSelect('Status', selectedStatus ?? 'Select Status', onStatusTap)),
            const SizedBox(width: 16),
            const Spacer(flex: 2),
          ],
        ),
      ],
    );
  }

  Widget _buildLabeledSelect(String label, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _requiredLabel(label),
        const SizedBox(height: 8),
        InkWell(
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
                    value,
                    style: Get.theme.textTheme.bodySmall?.copyWith(
                      color: value.contains('Select') ? AuthConstants.hintColor : AuthConstants.labelColor,
                      fontWeight: value.contains('Select') ? FontWeight.w500 : FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AuthConstants.hintColor),
              ],
            ),
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

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool> onChanged) {
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
                if (states.contains(WidgetState.selected)) return Colors.transparent;
                return null;
              }),
              checkColor: AuthConstants.labelColor,
              side: const BorderSide(color: AuthConstants.borderColor, width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 10),
          Text(label, style: Get.textTheme.bodyMedium?.copyWith(color: AuthConstants.labelColor)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AuthConstants.fieldBorderRadius)),
          ),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 160,
          height: 44,
          child: FilledButton(
            onPressed: isCreateEnabled ? onCreate : null,
            style: FilledButton.styleFrom(
              backgroundColor: isCreateEnabled ? AuthConstants.buttonEnabledColor : AuthConstants.buttonDisabledColor,
              disabledBackgroundColor: AuthConstants.buttonDisabledColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Create Rule'),
          ),
        ),
      ],
    );
  }
}
