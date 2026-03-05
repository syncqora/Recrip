import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'subscriptions_mobile_view.dart'; // For SubscriptionPlanRow

class SubscriptionsTabletView extends StatelessWidget {
  const SubscriptionsTabletView({
    super.key,
    required this.tableData,
    required this.onEdit,
    required this.onDelete,
  });

  final List<SubscriptionPlanRow> tableData;
  final Function(SubscriptionPlanRow) onEdit;
  final Function(SubscriptionPlanRow) onDelete;

  static const _textDark = Color(0xFF333333);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _iconCircleGreen = Color(0xFF16A34A);

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
          0: FlexColumnWidth(1.5),
          1: FlexColumnWidth(1.2),
          2: FlexColumnWidth(1.2),
          3: FlexColumnWidth(1.2),
          4: FlexColumnWidth(1),
          5: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
            children: [
              _tableCell('Plan Name', isHeader: true),
              _tableCell('Duration', isHeader: true),
              _tableCell('Price', isHeader: true),
              _tableCell('Active Members', isHeader: true),
              _tableCell('Status', isHeader: true),
              _tableCell('Action', isHeader: true),
            ],
          ),
          ...tableData.map(
            (row) => TableRow(
              decoration: const BoxDecoration(color: Colors.white),
              children: [
                _tableCell(row.planName),
                _tableCell(row.duration),
                _tableCell(row.price),
                _tableCell(row.activeMembers),
                _tableCell(_statusPill(row.isActive)),
                _tableCell(_actionIcons(row)),
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

  Widget _statusPill(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _iconCircleGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Active',
        style: Get.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _actionIcons(SubscriptionPlanRow row) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _actionIcon(Icons.edit_outlined, () => onEdit(row)),
        const SizedBox(width: 4),
        _actionIcon(Icons.delete_outline, () => onDelete(row)),
      ],
    );
  }

  Widget _actionIcon(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: _textMuted),
        ),
      ),
    );
  }
}
