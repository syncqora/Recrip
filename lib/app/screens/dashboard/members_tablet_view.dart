import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'members_mobile_view.dart'; // For MemberRow and MemberStatus

class MembersTabletView extends StatelessWidget {
  const MembersTabletView({
    super.key,
    required this.tableData,
    required this.onOpenViewMember,
  });

  final List<MemberRow> tableData;
  final Function(MemberRow) onOpenViewMember;

  static const _textDark = Color(0xFF333333);
  static const _border = Color(0xFFE5E7EB);
  static const _iconCircleOrange = Color(0xFFF59E0B);
  static const _iconCircleRed = Color(0xFFDC2626);
  static const _iconCircleGreen = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.5),
          1: FlexColumnWidth(1.4),
          2: FlexColumnWidth(1.8),
          3: FlexColumnWidth(0.9),
          4: FlexColumnWidth(1.1),
          5: FlexColumnWidth(1),
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
              _tableCell('Name', isHeader: true),
              _tableCell('Phone Number', isHeader: true),
              _tableCell('Email Address', isHeader: true),
              _tableCell('Plan', isHeader: true),
              _tableCell('Expiry Date', isHeader: true),
              _tableCell('Status', isHeader: true),
            ],
          ),
          ...tableData.asMap().entries.map(
                (entry) => TableRow(
                  decoration: BoxDecoration(
                    color: entry.key.isEven
                        ? Colors.white
                        : const Color(0xFFFAFAFA),
                    border:
                        Border(bottom: BorderSide(color: _border, width: 1)),
                  ),
                  children: [
                    _tapableCell(entry.value, entry.value.name),
                    _tapableCell(entry.value, entry.value.phone),
                    _tapableCell(entry.value, entry.value.email),
                    _tapableCell(entry.value, entry.value.plan),
                    _tapableCell(entry.value, entry.value.expiry),
                    _tapableCell(entry.value, _statusPill(entry.value.status)),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  Widget _tapableCell(MemberRow row, dynamic content) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onOpenViewMember(row),
        child: _tableCell(content),
      ),
    );
  }

  Widget _tableCell(dynamic content, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: content is String
            ? Text(
                content as String,
                style: Get.textTheme.bodySmall?.copyWith(
                  fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
                  color: isHeader ? const Color(0xFF475569) : _textDark,
                  fontSize: 14,
                ),
              )
            : content as Widget,
      ),
    );
  }

  Widget _statusPill(MemberStatus status) {
    final (String label, Color bg) = switch (status) {
      MemberStatus.active => ('Active', _iconCircleGreen),
      MemberStatus.expired => ('Expired', _iconCircleRed),
      MemberStatus.expiring => ('Expiring', _iconCircleOrange),
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
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}
