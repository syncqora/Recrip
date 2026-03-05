import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum RenewalStatus { expiring, expired, renewed }

class RenewalRow {
  final String name;
  final String phone;
  final String expiryDate;
  final int daysLeft;
  final String plan;
  final RenewalStatus status;

  RenewalRow({
    required this.name,
    required this.phone,
    required this.expiryDate,
    required this.daysLeft,
    required this.plan,
    required this.status,
  });
}

class RenewalsMobileView extends StatelessWidget {
  const RenewalsMobileView({super.key, required this.tableData});

  final List<RenewalRow> tableData;

  static const _textDark = Color(0xFF333333);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _expiringBadge = Color(0xFFFEF3C7);
  static const _expiredBadge = Color(0xFFFEE2E2);
  static const _expiredTextRed = Color(0xFFDC2626);
  static const _renewedBadge = Color(0xFFD1FAE5);
  static const _renewedText = Color(0xFF059669);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tableData.map((row) => _buildRenewalCard(row)).toList(),
    );
  }

  Widget _buildRenewalCard(RenewalRow row) {
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
                row.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _textDark,
                ),
              ),
              _statusPill(row.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(row.phone, style: const TextStyle(color: _textMuted, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn('Expiry Date', row.expiryDate),
              _infoColumn('Days Left', row.daysLeft == 0 ? '0' : row.daysLeft.toString().padLeft(2, '0')),
              _infoColumn('Plan', row.plan),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _actionIcon(Icons.refresh),
              const SizedBox(width: 12),
              _actionIcon(Icons.notifications_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _textMuted, fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: _textDark,
          ),
        ),
      ],
    );
  }

  Widget _statusPill(RenewalStatus status) {
    final (String label, Color bg, Color textColor) = switch (status) {
      RenewalStatus.expiring => ('Expiring', _expiringBadge, const Color(0xFFB45309)),
      RenewalStatus.expired => ('Expired', _expiredBadge, _expiredTextRed),
      RenewalStatus.renewed => ('Renewed', _renewedBadge, _renewedText),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
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
        color: Color(0xFFEEF2FF),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: _textMuted),
    );
  }
}
