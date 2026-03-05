import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'reminders_mobile_view.dart';
import 'reminders_tablet_view.dart';

/// Reminders page content: header, Reminder Rules table, Message Templates table.
/// Used inside the dashboard main content area when Reminders nav is selected.
class RemindersView extends StatelessWidget {
  const RemindersView({super.key});

  static const _purple = Color(0xFF4F46E5);
  static const _textDark = Color(0xFF333333);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _iconCircleGreen = Color(0xFF16A34A);
  static const _whatsAppGreen = Color(0xFF25D366);
  static const _emailBlue = Color(0xFF2196F3);

  static final _reminderRulesData = [
    ReminderRuleRow(
      trigger: 'Before Expiry',
      timing: '7 Days before',
      audience: 'All Members',
    ),
  ];

  static final _messageTemplatesData = [
    ReminderRuleRow(
      trigger: 'Before Expiry',
      timing: '7 Days before',
      audience: 'All Members',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    return SingleChildScrollView(
      padding: isMobile ? const EdgeInsets.all(16) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile),
          const SizedBox(height: 24),
          if (isMobile)
            RemindersMobileView(
              rulesData: _reminderRulesData,
              templatesData: _messageTemplatesData,
            )
          else if (isTablet)
            RemindersTabletView(
              rulesData: _reminderRulesData,
              templatesData: _messageTemplatesData,
            )
          else ...[
            _buildReminderRulesSection(),
            const SizedBox(height: 28),
            _buildMessageTemplatesSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reminders',
                    style: (isMobile
                            ? Get.textTheme.headlineSmall
                            : Get.textTheme.headlineMedium)
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Automate renewal reminders across WhatsApp and Email',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: _textMuted,
                      fontSize: isMobile ? 13 : 14,
                    ),
                  ),
                ],
              ),
            ),
            if (!isMobile)
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: _purple,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Create Reminder Rule'),
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: _purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Create Reminder Rule'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildReminderRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder Rules',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: _textDark,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Define when and how reminders are sent automatically',
          style: Get.textTheme.bodySmall?.copyWith(color: _textMuted),
        ),
        const SizedBox(height: 16),
        _buildRulesTable(_reminderRulesData),
      ],
    );
  }

  Widget _buildMessageTemplatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Message Templates',
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Customize the message sent to members.',
                  style: Get.textTheme.bodySmall?.copyWith(color: _textMuted),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: _textDark,
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Create Template'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildRulesTable(_messageTemplatesData),
      ],
    );
  }

  Widget _buildRulesTable(List<ReminderRuleRow> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Table(
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
            decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
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
              decoration: const BoxDecoration(color: Colors.white),
              children: [
                _tableCell(row.trigger),
                _tableCell(row.timing),
                _tableCell(_channelIcons()),
                _tableCell(row.audience),
                _tableCell(_statusPill(row.isActive)),
                _tableCell(_actionIcons()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _channelIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.chat_bubble_outline, size: 20, color: Color(0xFF25D366)),
        const SizedBox(width: 8),
        const Icon(Icons.email_outlined, size: 20, color: Color(0xFF2196F3)),
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
          color: const Color(0xFF16A34A),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _actionIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _actionIcon(Icons.edit_outlined),
        _actionIcon(Icons.delete_outline),
      ],
    );
  }

  Widget _actionIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 18, color: const Color(0xFF666666)),
          ),
        ),
      ),
    );
  }
}
