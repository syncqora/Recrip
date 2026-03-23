import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'package:saas/shared/constants/app_icons.dart';

import 'subscription_plan_row.dart';

class SubscriptionsTabletView extends StatelessWidget {
  const SubscriptionsTabletView({
    super.key,
    required this.tableData,
    required this.onEdit,
    required this.onDelete,
  });

  final List<SubscriptionPlanRow> tableData;
  final void Function(SubscriptionPlanRow plan, int index) onEdit;
  final void Function(SubscriptionPlanRow plan, int index) onDelete;

  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _iconCircleGreen = Color(0xFF16A34A);
  static const _inactivePillBg = Color(0xFFFEE2E2);
  static const _inactivePillText = Color(0xFF991B1B);

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
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
            children: [
              _tableCell(AppStrings.planNameHeader, isHeader: true),
              _tableCell(AppStrings.tableHeaderDuration, isHeader: true),
              _tableCell(AppStrings.tableHeaderPrice, isHeader: true),
              _tableCell(AppStrings.status, isHeader: true),
              _tableCell(AppStrings.actionHeader, isHeader: true),
            ],
          ),
          ...tableData.asMap().entries.map(
            (entry) => TableRow(
              decoration: const BoxDecoration(color: Colors.white),
              children: [
                _tableCell(entry.value.planName),
                _tableCell(entry.value.duration),
                _tableCell(entry.value.price),
                _tableCell(_statusPill(entry.value.isActive)),
                _tableCell(_actionIcons(entry.value, entry.key)),
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
                content,
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
        color: isActive ? _iconCircleGreen : _inactivePillBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? AppStrings.active : AppStrings.inactive,
        style: Get.textTheme.bodySmall?.copyWith(
          color: isActive ? Colors.white : _inactivePillText,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _actionIcons(SubscriptionPlanRow row, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _actionIcon(AppIcons.edit, () => onEdit(row, index)),
        const SizedBox(width: 4),
        _actionIcon(AppIcons.trash, () => onDelete(row, index)),
      ],
    );
  }

  Widget _actionIcon(String assetPath, VoidCallback onTap) {
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
