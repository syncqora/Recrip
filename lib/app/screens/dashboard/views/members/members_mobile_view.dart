import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'package:saas/shared/widgets/app_close_button.dart';
import 'package:saas/shared/widgets/success_toast.dart';

enum MemberStatus { active, expired, expiring }

class MemberRow {
  final String name;
  final String phone;
  final String email;
  final String plan;
  final String expiry;
  final MemberStatus status;

  MemberRow({
    required this.name,
    required this.phone,
    required this.email,
    required this.plan,
    required this.expiry,
    required this.status,
  });
}

class MembersMobileView extends StatelessWidget {
  const MembersMobileView({
    super.key,
    required this.tableData,
    required this.onOpenViewMember,
  });

  final List<MemberRow> tableData;
  final Function(MemberRow) onOpenViewMember;

  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _dividerColor = Color(0xFFCBD5E1);
  static const _expiredBadge = Color(0xFFFEE2E2);
  static const _expiringBadge = Color(0xFFFEF3C7);
  static const _activeBadge = Color(0xFFDCFCE7);
  static const _actionCircleBg = Color(0xFFEEF2FF);
  static const _actionIconColor = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tableData
          .map((member) => _buildMemberCard(context, member))
          .toList(),
    );
  }

  Widget _buildMemberCard(BuildContext context, MemberRow member) {
    final (String label, Color bg, Color textColor) = switch (member.status) {
      MemberStatus.active => (
        AppStrings.active,
        _activeBadge,
        const Color(0xFF166534),
      ),
      MemberStatus.expired => (
        AppStrings.expired,
        _expiredBadge,
        const Color(0xFF991B1B),
      ),
      MemberStatus.expiring => (
        AppStrings.expiring,
        _expiringBadge,
        const Color(0xFF92400E),
      ),
    };

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _openMemberCard(context, member),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    member.name,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: _textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      label,
                      style: Get.textTheme.labelMedium?.copyWith(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                member.phone,
                style: const TextStyle(color: _textMuted, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                member.email,
                style: const TextStyle(color: _textMuted, fontSize: 13),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 0.5),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppStrings.plan,
                        style: TextStyle(color: _textMuted, fontSize: 11),
                      ),
                      Text(
                        member.plan,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: _textDark,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        AppStrings.tableHeaderExpiryDate,
                        style: TextStyle(color: _textMuted, fontSize: 11),
                      ),
                      Text(
                        member.expiry,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: _textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMemberCard(BuildContext context, MemberRow member) {
    final (String statusLabel, Color statusColor) = switch (member.status) {
      MemberStatus.active => (AppStrings.active, const Color(0xFF166534)),
      MemberStatus.expired => (AppStrings.expired, const Color(0xFF991B1B)),
      MemberStatus.expiring => (AppStrings.expiring, const Color(0xFF92400E)),
    };
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.16),
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 380),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 10, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: _textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            member.name,
                            style: Get.textTheme.bodyMedium?.copyWith(
                              color: _textDark,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 1, right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: statusLabel == AppStrings.active
                            ? _activeBadge
                            : statusColor.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        statusLabel,
                        style: Get.textTheme.labelMedium?.copyWith(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //  border: Border.all(color: _closeBorder),
                      ),
                      child: AppCloseButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        hitSize: 28,
                        iconSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _detailBlock('Phone Number', member.phone),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _detailBlock('Email Address', member.email),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _detailBlock('Plan', member.plan)),
                        const SizedBox(width: 16),
                        Expanded(child: _detailBlock('Expiry', member.expiry)),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: _dividerColor),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _actionItem(
                        icon: AppIcons.renew,
                        label: 'Renew',
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          SuccessToast.show(
                            context,
                            title: 'Renewal started',
                            popRoute: false,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: _actionItem(
                        icon: AppIcons.bellRing,
                        label: 'Send Reminder',
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          SuccessToast.show(
                            context,
                            title: 'Reminder Sent to ${member.name}',
                            popRoute: false,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: _actionItem(
                        icon: AppIcons.edit,
                        label: 'Edit',
                        onTap: () => Navigator.of(dialogContext).pop(),
                      ),
                    ),
                    Expanded(
                      child: _actionItem(
                        icon: AppIcons.trash,
                        label: 'Delete',
                        onTap: () => Navigator.of(dialogContext).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailBlock(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.bodySmall?.copyWith(
            color: _textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: _textDark,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _actionItem({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: _actionCircleBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    _actionIconColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: _actionIconColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
