import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../authentication/widgets/app_constants.dart';
import '../../../../shared/widgets/app_modal_primary_button.dart';
import 'package:saas/shared/constants/app_icons.dart';

class CreateRuleModalMobileView extends StatelessWidget {
  const CreateRuleModalMobileView({
    super.key,
    required this.modalTitle,
    required this.primaryButtonLabel,
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

  final String modalTitle;
  final String primaryButtonLabel;
  final String? selectedTrigger;
  final String? selectedTiming;
  final String? selectedAudience;
  final String? selectedStatus;
  final bool whatsApp;
  final bool email;
  final void Function(BuildContext anchorContext) onTriggerTap;
  final void Function(BuildContext anchorContext) onTimingTap;
  final void Function(BuildContext anchorContext) onAudienceTap;
  final void Function(BuildContext anchorContext) onStatusTap;
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
          icon: SvgPicture.asset(AppIcons.backButton, width: 20, height: 20),
          style: IconButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.all(12),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        title: Text(
          modalTitle,
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
            _buildSectionTitle('Reminder Rule Details'),
            const SizedBox(height: 16),
            _buildLabel('Trigger'),
            const SizedBox(height: 8),
            _buildSelectField(
              selectedTrigger ?? 'Select Trigger',
              onTriggerTap,
            ),
            const SizedBox(height: 16),
            _buildLabel('Timing'),
            const SizedBox(height: 8),
            _buildSelectField(selectedTiming ?? 'Select Timing', onTimingTap),
            const SizedBox(height: 16),
            _buildLabel('Audience'),
            const SizedBox(height: 8),
            _buildSelectField(
              selectedAudience ?? 'Select Audience',
              onAudienceTap,
            ),
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
        fontWeight: FontWeight.bold,
        color: AppConstants.labelColor,
        fontSize: 14,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return RichText(
      text: TextSpan(
        style: Get.textTheme.bodySmall?.copyWith(
          color: AppConstants.labelColor,
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

  Widget _buildSelectField(
    String text,
    void Function(BuildContext anchorContext) onTap,
  ) {
    return Builder(
      builder: (anchorContext) {
        return InkWell(
          onTap: () => onTap(anchorContext),
          borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
          child: Container(
            height: AppConstants.fieldHeight,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppConstants.fieldFillColor,
              borderRadius: BorderRadius.circular(
                AppConstants.fieldBorderRadius,
              ),
              border: Border.all(color: AppConstants.borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: Get.theme.textTheme.bodySmall?.copyWith(
                      color: text.contains('Select')
                          ? AppConstants.hintColor
                          : AppConstants.labelColor,
                      fontWeight: text.contains('Select')
                          ? FontWeight.w500
                          : FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppConstants.hintColor,
                ),
              ],
            ),
          ),
        );
      },
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
                if (states.contains(WidgetState.selected))
                  return Colors.transparent;
                return null;
              }),
              checkColor: AppConstants.labelColor,
              side: const BorderSide(color: AppConstants.borderColor, width: 1),
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
              color: AppConstants.labelColor,
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
            label: primaryButtonLabel,
            onPressed: isCreateEnabled ? onCreate : null,
            padding: const EdgeInsets.symmetric(vertical: 12),
            borderRadius: 10,
          ),
        ),
      ],
    );
  }
}
