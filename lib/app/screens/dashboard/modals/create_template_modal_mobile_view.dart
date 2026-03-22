import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/themes/popup_menu_interaction_theme.dart';
import '../../authentication/widgets/app_constants.dart';
import '../../../../shared/widgets/app_modal_primary_button.dart';
import 'package:saas/shared/constants/app_icons.dart';

class CreateTemplateModalMobileView extends StatelessWidget {
  const CreateTemplateModalMobileView({
    super.key,
    required this.title,
    required this.selectedTrigger,
    required this.selectedTiming,
    required this.selectedAudience,
    required this.selectedStatus,
    required this.messageController,
    required this.whatsApp,
    required this.email,
    required this.onTriggerTap,
    required this.onTimingTap,
    required this.onAudienceTap,
    required this.onStatusTap,
    required this.onUploadAttachment,
    required this.onWhatsAppChanged,
    required this.onEmailChanged,
    required this.onCancel,
    required this.onCreate,
    required this.isCreateEnabled,
  });

  final String title;
  final String? selectedTrigger;
  final String? selectedTiming;
  final String? selectedAudience;
  final String? selectedStatus;
  final TextEditingController messageController;
  final bool whatsApp;
  final bool email;
  final void Function(BuildContext anchorContext) onTriggerTap;
  final void Function(BuildContext anchorContext) onTimingTap;
  final void Function(BuildContext anchorContext) onAudienceTap;
  final void Function(BuildContext anchorContext) onStatusTap;
  final VoidCallback onUploadAttachment;
  final ValueChanged<bool> onWhatsAppChanged;
  final ValueChanged<bool> onEmailChanged;
  final VoidCallback onCancel;
  final VoidCallback onCreate;
  final bool isCreateEnabled;

  static const _filledFieldColor = Color(0xFFF8FAFC);
  static const _dropdownPlaceholderColor = Color(0xFF64748B);

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
          title,
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
            _buildSectionTitle('Message Rule Details'),
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
            _buildSectionTitle('Attachment'),
            const SizedBox(height: 12),
            _buildUploadArea(),
            const SizedBox(height: 24),
            _buildSectionTitle('Message Content'),
            const SizedBox(height: 12),
            _buildMessageContentField(),
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
        style: Get.theme.textTheme.labelMedium?.copyWith(
          color: AppConstants.labelColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(text: text),
          const TextSpan(
            text: '*',
            style: TextStyle(color: Colors.red),
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
        return Theme(
          data: popupMenuInteractionTheme(anchorContext),
          child: InkWell(
            onTap: () => onTap(anchorContext),
            borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
            child: Container(
              height: AppConstants.fieldHeight,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: text.contains('Select')
                    ? Colors.white
                    : _filledFieldColor,
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
                      style: Get.theme.textTheme.labelMedium?.copyWith(
                        color: text.contains('Select')
                            ? _dropdownPlaceholderColor
                            : AppConstants.textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1,
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
          ),
        );
      },
    );
  }

  Widget _buildUploadArea() {
    return InkWell(
      onTap: onUploadAttachment,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: AppConstants.fieldFillColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: AppConstants.borderColor,
            borderRadius: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.upload,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppConstants.hintColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload Attachment',
                style: Get.textTheme.labelMedium?.copyWith(
                  color: AppConstants.hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContentField() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: messageController.text.trim().isNotEmpty
            ? _filledFieldColor
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppConstants.borderColor),
      ),
      child: TextField(
        controller: messageController,
        onTapOutside: (_) {},
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: Get.textTheme.bodyMedium?.copyWith(
          color: AppConstants.textColor,
        ),
        decoration: InputDecoration(
          hintText: 'Type your message here....',
          hintStyle: Get.theme.textTheme.labelMedium?.copyWith(
            color: _dropdownPlaceholderColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
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
          const SizedBox(width: 12),
          Text(
            label,
            style: Get.textTheme.labelMedium?.copyWith(
              color: AppConstants.labelColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderChannels() {
    return Row(
      children: [
        Expanded(
          child: _buildCheckbox('WhatsApp', whatsApp, onWhatsAppChanged),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildCheckbox('Email', email, onEmailChanged)),
      ],
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
            label: title.contains('Edit')
                ? 'Update Template'
                : 'Create Template',
            onPressed: isCreateEnabled ? onCreate : null,
            padding: const EdgeInsets.symmetric(vertical: 12),
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
