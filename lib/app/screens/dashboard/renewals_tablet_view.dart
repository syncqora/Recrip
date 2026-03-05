import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'renewals_mobile_view.dart'; // For RenewalRow and RenewalStatus

class RenewalsTabletView extends StatelessWidget {
  const RenewalsTabletView({super.key, required this.tableData});

  final List<RenewalRow> tableData;

  static const _textDark = Color(0xFF333333);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _headerBg = Color(0xFFF1F5F9);
  static const _expiringBadge = Color(0xFFFEF3C7);
  static const _expiredBadge = Color(0xFFFEE2E2);
  static const _expiredTextRed = Color(0xFFDC2626);
  static const _renewedBadge = Color(0xFFD1FAE5);
  static const _renewedText = Color(0xFF059669);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(1.3),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(0.8),
          4: FlexColumnWidth(0.9),
          5: FlexColumnWidth(1),
          6: FlexColumnWidth(0.9),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: _headerBg),
            children: [
              _tableCell('Name', isHeader: true),
              _tableCell('Phone Number', isHeader: true),
              _tableCell('Expiry Date', isHeader: true),
              _tableCell('Days Left', isHeader: true),
              _tableCell('Plan', isHeader: true),
              _tableCell('Status', isHeader: true),
              _tableCell('Action', isHeader: true),
            ],
          ),
          ...tableData.map(
            (row) => TableRow(
              decoration: const BoxDecoration(color: Colors.white),
              children: [
                _tableCell(row.name),
                _tableCell(row.phone),
                _tableCell(row.expiryDate),
                _tableCell(
                  Text(
                    row.daysLeft == 0 ? '0' : row.daysLeft.toString().padLeft(2, '0'),
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: row.daysLeft == 0 ? _expiredTextRed : _textDark,
                      fontWeight: row.daysLeft == 0 ? FontWeight.w600 : null,
                      fontSize: 14,
                    ),
                  ),
                ),
                _tableCell(row.plan),
                _tableCell(_statusPill(row.status)),
                _tableCell(_actionIcons()),
              ],
            ),
          ),
        ],
      ),
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
        style: Get.textTheme.bodySmall?.copyWith(
          color: textColor,
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
        _actionIcon(Icons.refresh),
        const SizedBox(width: 4),
        _actionIcon(Icons.notifications_outlined),
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
