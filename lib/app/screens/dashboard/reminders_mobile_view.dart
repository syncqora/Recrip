import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReminderRuleRow {
  final String trigger;
  final String timing;
  final String audience;
  final bool isActive;

  ReminderRuleRow({
    required this.trigger,
    required this.timing,
    required this.audience,
    this.isActive = true,
  });
}

class RemindersMobileView extends StatelessWidget {
  const RemindersMobileView({
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
        ...rulesData.map((row) => _buildRuleCard(row)).toList(),
        const SizedBox(height: 24),
        _buildSectionTitle('Message Templates'),
        const SizedBox(height: 12),
        ...templatesData.map((row) => _buildRuleCard(row)).toList(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: _textDark,
        fontSize: 16,
      ),
    );
  }

  Widget _buildRuleCard(ReminderRuleRow row) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                row.trigger,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: _textDark,
                ),
              ),
              _statusPill(row.isActive),
            ],
          ),
          const SizedBox(height: 8),
          Text(row.timing, style: const TextStyle(color: _textMuted, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn('Audience', row.audience),
              _infoColumn('Channels', _channelIcons()),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _actionIcon(Icons.edit_outlined),
              const SizedBox(width: 12),
              _actionIcon(Icons.delete_outline),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _textMuted, fontSize: 11)),
        const SizedBox(height: 4),
        if (value is String)
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textDark),
          )
        else
          value as Widget,
      ],
    );
  }

  Widget _channelIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.chat_bubble_outline, size: 18, color: _whatsAppGreen),
        const SizedBox(width: 8),
        Icon(Icons.email_outlined, size: 18, color: _emailBlue),
      ],
    );
  }

  Widget _statusPill(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Active',
        style: TextStyle(
          color: _iconCircleGreen,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: _textMuted),
    );
  }
}
