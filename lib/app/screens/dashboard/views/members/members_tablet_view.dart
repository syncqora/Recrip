import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../authentication/widgets/app_constants.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'members_mobile_view.dart'; // For MemberRow and MemberStatus

class MembersTabletView extends StatelessWidget {
  const MembersTabletView({
    super.key,
    required this.tableData,
    required this.onOpenViewMember,
  });

  final List<MemberRow> tableData;
  final Function(MemberRow) onOpenViewMember;

  // Design colors from AuthConstants and Mobile reference
  static const _textDark = AppConstants.textColor;
  static const _border = AppConstants.borderColor;
  static const _dividerColor = Color(0xFFCBD5E1);

  // Status Badge Colors
  static const _activeBadge = Color(0xFFDCFCE7);
  static const _activeText = Color(0xFF166534);
  static const _expiredBadge = Color(0xFFFEE2E2);
  static const _expiredText = Color(0xFF991B1B);
  static const _expiringBadge = Color(0xFFFEF3C7);
  static const _expiringText = Color(0xFF92400E);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tableData.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 500, // Responsive grid: 2 columns on most tablets
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        mainAxisExtent: 240, // Fixed height for grid symmetry
      ),
      itemBuilder: (context, index) => _buildMemberCard(tableData[index]),
    );
  }

  Widget _buildMemberCard(MemberRow member) {
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
      child: InkWell(
        onTap: () => onOpenViewMember(member),
        borderRadius: BorderRadius.circular(24),
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
                      member.name,
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _statusPill(member.status),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                member.phone,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppConstants.supportTextColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                member.email,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppConstants.supportTextColor,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              const Divider(height: 1, thickness: 1, color: _dividerColor),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoColumn(AppStrings.plan, member.plan),
                  _infoColumn(
                    AppStrings.tableHeaderExpiryDate,
                    member.expiry,
                    alignRight: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoColumn(String label, String value, {bool alignRight = false}) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.labelSmall?.copyWith(
            color: AppConstants.supportTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: _textDark,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _statusPill(MemberStatus status) {
    final (String label, Color bg, Color textColor) = switch (status) {
      MemberStatus.active => (AppStrings.active, _activeBadge, _activeText),
      MemberStatus.expired => (AppStrings.expired, _expiredBadge, _expiredText),
      MemberStatus.expiring => (
        AppStrings.expiring,
        _expiringBadge,
        _expiringText,
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
}
