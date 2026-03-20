import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../authentication/widgets/app_constants.dart';
import 'package:saas/shared/constants/app_strings.dart';
import '../../modals/add_member_modal.dart';
import '../../../../../shared/widgets/success_toast.dart';
import 'renewals_mobile_view.dart';
import 'package:saas/shared/constants/app_icons.dart';

class RenewalsTabletView extends StatelessWidget {
  const RenewalsTabletView({super.key, required this.tableData});

  final List<RenewalRow> tableData;

  // Design colors from AuthConstants and reference
  static const _textDark = AppConstants.textColor;
  static const _textMuted = AppConstants.supportTextColor;
  static const _border = AppConstants.borderColor;
  static const _dividerColor = Color(0xFFCBD5E1);

  static const _expiringBadge = Color(0xFFFEF3C7);
  static const _expiredBadge = Color(0xFFFEE2E2);
  static const _expiredTextRed = Color(0xFFDC2626);
  static const _renewedBadge = Color(0xFFD1FAE5);
  static const _renewedText = Color(0xFF059669);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tableData.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 500, // Two columns on standard tablets
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        mainAxisExtent: 280, // Consistent height for grid items
      ),
      itemBuilder: (context, index) =>
          _buildRenewalCard(context, tableData[index]),
    );
  }

  Widget _buildRenewalCard(BuildContext context, RenewalRow row) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    row.name,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _statusPill(row.status),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              row.phone,
              style: Get.textTheme.bodySmall?.copyWith(
                color: _textMuted,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoColumn(AppStrings.tableHeaderExpiryDate, row.expiryDate),
                _infoColumn(
                  AppStrings.tableHeaderDaysLeft,
                  row.daysLeft == 0
                      ? '0'
                      : row.daysLeft.toString().padLeft(2, '0'),
                  isAlert: row.daysLeft == 0,
                ),
                _infoColumn(AppStrings.plan, row.plan, alignRight: true),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: _dividerColor),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionIcon(
                  AppIcons.renew,
                  onTap: () => Get.dialog(
                    AddMemberModal(
                      initialFullName: row.name,
                      initialPhone: row.phone,
                      initialPlan: row.plan,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _actionIcon(
                  AppIcons.bellRing,
                  onTap: () => SuccessToast.show(
                    context,
                    title: AppStrings.reminderSentTo(row.name),
                    popRoute: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(
    String label,
    String value, {
    bool alignRight = false,
    bool isAlert = false,
  }) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.labelSmall?.copyWith(
            color: _textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: isAlert ? _expiredTextRed : _textDark,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _statusPill(RenewalStatus status) {
    final (String label, Color bg, Color textColor) = switch (status) {
      RenewalStatus.expiring => (
        AppStrings.expiring,
        _expiringBadge,
        const Color(0xFFB45309),
      ),
      RenewalStatus.expired => (
        AppStrings.expired,
        _expiredBadge,
        _expiredTextRed,
      ),
      RenewalStatus.renewed => (
        AppStrings.renewed,
        _renewedBadge,
        _renewedText,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: Get.textTheme.labelMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
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
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFFEEF2FF),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset(
            assetPath,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(_textMuted, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
