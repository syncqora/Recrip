import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../authentication/widgets/app_constants.dart';
import '../../../../shared/widgets/app_close_button.dart';
import '../../../../shared/widgets/app_modal_primary_button.dart';
import 'package:saas/shared/constants/app_icons.dart';

class CreateTemplateModalTabletView extends StatelessWidget {
  const CreateTemplateModalTabletView({
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
      child: Container(
        width: 860,
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
                    _buildSectionTitle('Message Rule Details'),
                    const SizedBox(height: 16),
                    _buildTopGrid(),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Attachment'),
                              const SizedBox(height: 12),
                              _buildUploadArea(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Message Content'),
                              const SizedBox(height: 12),
                              _buildMessageContentField(),
                            ],
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildTopGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildLabeledSelect(
                'Trigger',
                selectedTrigger ?? 'Select Trigger',
                onTriggerTap,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLabeledSelect(
                'Timing',
                selectedTiming ?? 'Select Timing',
                onTimingTap,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLabeledSelect(
                'Audience',
                selectedAudience ?? 'Select Audience',
                onAudienceTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildLabeledSelect(
                'Status',
                selectedStatus ?? 'Select Status',
                onStatusTap,
              ),
            ),
            const SizedBox(width: 16),
            const Spacer(flex: 2),
          ],
        ),
      ],
    );
  }

  Widget _buildLabeledSelect(
    String label,
    String value,
    void Function(BuildContext anchorContext) onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _requiredLabel(label),
        const SizedBox(height: 8),
        Builder(
          builder: (anchorContext) {
            return InkWell(
              onTap: () => onTap(anchorContext),
              borderRadius: BorderRadius.circular(
                AppConstants.fieldBorderRadius,
              ),
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
                        value,
                        style: Get.theme.textTheme.bodySmall?.copyWith(
                          color: value.contains('Select')
                              ? AppConstants.hintColor
                              : AppConstants.labelColor,
                          fontWeight: value.contains('Select')
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
        ),
      ],
    );
  }

  Widget _requiredLabel(String text) {
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

  Widget _buildUploadArea() {
    return InkWell(
      onTap: onUploadAttachment,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        height: 120,
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
                width: 32,
                height: 32,
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
        color: AppConstants.fieldFillColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppConstants.borderColor),
      ),
      child: TextField(
        controller: messageController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: Get.textTheme.bodyMedium?.copyWith(
          color: AppConstants.textColor,
        ),
        decoration: InputDecoration(
          hintText: 'Type your message here....',
          hintStyle: Get.theme.textTheme.labelMedium?.copyWith(
            color: AppConstants.hintColor,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
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
          width: 180,
          height: 44,
          child: AppModalPrimaryButton(
            label: title.contains('Edit')
                ? 'Update Template'
                : 'Create Template',
            onPressed: isCreateEnabled ? onCreate : null,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            minimumSize: const Size(180, 44),
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
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
