import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'reminders_mobile_view.dart'; // For ReminderRuleRow

class RemindersTabletView extends StatelessWidget {
  const RemindersTabletView({
    super.key,
    required this.rulesData,
    required this.templatesData,
  });

  final List<ReminderRuleRow> rulesData;
  final List<ReminderRuleRow> templatesData;

  static const _textDark = Color(0xFF333333);
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
        _buildSectionTitle('Reminder Rules'),
        const SizedBox(height: 12),
        _buildRulesTable(rulesData),
        const SizedBox(height: 28),
        _buildSectionTitle('Message Templates'),
        const SizedBox(height: 12),
        _buildRulesTable(templatesData),
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

  Widget _buildRulesTable(List<ReminderRuleRow> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
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
        Icon(Icons.chat_bubble_outline, size: 20, color: _whatsAppGreen),
        const SizedBox(width: 8),
        Icon(Icons.email_outlined, size: 20, color: _emailBlue),
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

  Widget _actionIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _actionIcon(Icons.edit_outlined),
        const SizedBox(width: 4),
        _actionIcon(Icons.delete_outline),
      ],
    );
  }

  Widget _actionIcon(IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: _textMuted),
        ),
      ),
    );
  }
}
