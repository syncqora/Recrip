import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'package:saas/shared/constants/app_icons.dart';

import 'subscription_plan_row.dart';

class SubscriptionsDesktopTable extends StatelessWidget {
  const SubscriptionsDesktopTable({
    super.key,
    required this.tableData,
    required this.onEdit,
    required this.onDelete,
  });

  final List<SubscriptionPlanRow> tableData;
  final void Function(SubscriptionPlanRow plan, int index) onEdit;
  final void Function(SubscriptionPlanRow plan, int index) onDelete;

  static const _textDark = Color(0xFF0F172A);
  static const _border = Color(0xFFE5E7EB);
  static const _iconCircleGreen = Color(0xFFDCFCE7);
  static const _inactivePillBg = Color(0xFFFEE2E2);
  static const _inactivePillText = Color(0xFF991B1B);
  static const _planNameColumnLeftPadding = 40.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
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
            decoration: const BoxDecoration(color: Color(0xFFEEF2FF)),
            children: [
              _tableCell(
                AppStrings.planNameHeader,
                isHeader: true,
                align: Alignment.centerLeft,
                isPlanNameColumn: true,
              ),
              _tableCell(
                AppStrings.tableHeaderDuration,
                isHeader: true,
                align: Alignment.center,
              ),
              _tableCell(
                AppStrings.tableHeaderPrice,
                isHeader: true,
                align: Alignment.center,
              ),
              _tableCell(
                AppStrings.status,
                isHeader: true,
                align: Alignment.center,
              ),
              _tableCell(
                AppStrings.actionHeader,
                isHeader: true,
                align: Alignment.center,
              ),
            ],
          ),
          ...tableData.asMap().entries.map(
            (entry) => TableRow(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              children: [
                _tableCell(
                  entry.value.planName,
                  align: Alignment.centerLeft,
                  isPlanNameColumn: true,
                ),
                _tableCell(entry.value.duration, align: Alignment.center),
                _tableCell(entry.value.price, align: Alignment.center),
                _tableCell(
                  _statusPill(entry.value.isActive),
                  align: Alignment.center,
                ),
                _tableCell(
                  _actionIcons(context, entry.value, entry.key),
                  align: Alignment.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCell(
    dynamic content, {
    bool isHeader = false,
    bool isPlanNameColumn = false,
    Alignment align = Alignment.centerLeft,
  }) {
    const horizontalPadding = 12.0;
    final padding = isPlanNameColumn
        ? EdgeInsets.fromLTRB(
            horizontalPadding + _planNameColumnLeftPadding,
            0,
            horizontalPadding,
            0,
          )
        : const EdgeInsets.symmetric(horizontal: 12);
    return SizedBox(
      height: 50,
      child: Padding(
        padding: padding,
        child: Align(
          alignment: align,
          child: content is String
              ? Text(
                  content,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: isHeader ? FontWeight.w500 : FontWeight.normal,
                    color: _textDark,
                  ),
                )
              : content as Widget,
        ),
      ),
    );
  }

  Widget _statusPill(bool isActive) {
    return Container(
      width: 92,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? _iconCircleGreen : _inactivePillBg,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        isActive ? AppStrings.active : AppStrings.inactive,
        style: Get.textTheme.bodySmall?.copyWith(
          color: isActive ? const Color(0xFF166534) : _inactivePillText,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _actionIcons(
    BuildContext context,
    SubscriptionPlanRow row,
    int index,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _actionIcon(
          AppIcons.edit,
          onTap: () => onEdit(row, index),
        ),
        _actionIcon(
          AppIcons.trash,
          onTap: () => onDelete(row, index),
        ),
      ],
    );
  }

  Widget _actionIcon(String assetPath, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF2FF),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              assetPath,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Color(0xFF64748B),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
