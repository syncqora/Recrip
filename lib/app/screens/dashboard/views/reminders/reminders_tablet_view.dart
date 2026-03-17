import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../modals/create_template_modal.dart';
import 'reminders_mobile_view.dart';

class RemindersTabletView extends StatelessWidget {
  const RemindersTabletView({
    super.key,
    required this.rulesData,
    required this.templatesData,
  });

  final List<ReminderRuleRow> rulesData;
  final List<ReminderRuleRow> templatesData;

  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _iconCircleGreen = Color(0xFF16A34A);
  static const _whatsAppGreen = Color(0xFF25D366);
  static const _emailBlue = Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReminderRulesSection(context),
        const SizedBox(height: 28),
        _buildMessageTemplatesSection(context),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: _textDark,
        fontSize: 18,
      ),
    );
  }

  Widget _buildReminderRulesSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reminder Rules',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: _textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Define when and how reminders are sent automatically',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: _textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildRulesTable(context, rulesData),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTemplatesSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Message Templates',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: _textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Customize the message sent to members.',
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 168,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => Get.dialog(const CreateTemplateModal()),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _textDark,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                        side: const BorderSide(
                          color: Color(0xFFE2E8F0),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Create Template'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildRulesTable(context, templatesData, isMessageTemplates: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRulesTable(
    BuildContext context,
    List<ReminderRuleRow> rows, {
    bool isMessageTemplates = false,
  }) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(0.9),
        5: FlexColumnWidth(0.9),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(
            color: Color(0xFFEEF2FF),
            border: Border(
              bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
          ),
          children: [
            _tableCell('Trigger', isHeader: true),
            _tableCell('Timing', isHeader: true),
            _tableCell('Channel', isHeader: true),
            _tableCell('Audience', isHeader: true),
            _tableCell('Status', isHeader: true),
            _tableCell('Action', isHeader: true),
          ],
        ),
        ...rows.map(
          (row) => TableRow(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            children: [
              _tableCell(row.trigger),
              _tableCell(row.timing),
              _tableCell(_channelIcons()),
              _tableCell(row.audience),
              _tableCell(_statusPill(row.isActive)),
              _tableCell(_actionIcons(context, row, isMessageTemplates)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _channelIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/icons/WhatsappLogo.svg',
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(_whatsAppGreen, BlendMode.srcIn),
        ),
        const SizedBox(width: 8),
        SvgPicture.asset(
          'assets/icons/email.svg',
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(_emailBlue, BlendMode.srcIn),
        ),
      ],
    );
  }

  Widget _tableCell(dynamic content, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: content is String
            ? Text(
                content as String,
                style: Get.textTheme.bodySmall?.copyWith(
                  fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
                  color: _textDark,
                  fontSize: 14,
                ),
              )
            : content as Widget,
      ),
    );
  }

  Widget _statusPill(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Active',
        style: Get.textTheme.bodySmall?.copyWith(
          color: _iconCircleGreen,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _actionIcons(
    BuildContext context,
    ReminderRuleRow row,
    bool isMessageTemplates,
  ) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _actionIcon(
            'assets/icons/edit.svg',
            onTap: isMessageTemplates
                ? () {
                    Get.dialog(
                      CreateTemplateModal(
                        title: 'Edit Template',
                        initialTrigger: row.trigger,
                        initialTiming: row.timing,
                        initialAudience: row.audience,
                        initialStatus: row.isActive ? 'Active' : 'Inactive',
                      ),
                    );
                  }
                : null,
          ),
          const SizedBox(width: 4),
          _actionIcon('assets/icons/trash.svg'),
        ],
      ),
    );
  }

  Widget _actionIcon(String assetPath, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Color(0xFFF1F5F9),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            assetPath,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(_textMuted, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
