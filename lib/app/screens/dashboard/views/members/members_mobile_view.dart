import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modals/add_member_modal.dart';
import '../../modals/view_member_modal.dart';

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

  static const _purple = Color(0xFF4F46E5);
  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _expiredBadge = Color(0xFFFEE2E2);
  static const _expiringBadge = Color(0xFFFEF3C7);
  static const _activeBadge = Color(0xFFDCFCE7);
  static const _iconCircleOrange = Color(0xFFF59E0B);
  static const _iconCircleRed = Color(0xFFDC2626);
  static const _iconCircleGreen = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tableData.map((member) => _buildMemberCard(member)).toList(),
    );
  }

  Widget _buildMemberCard(MemberRow member) {
    final (String label, Color bg, Color textColor) = switch (member.status) {
      MemberStatus.active => ('Active', _activeBadge, const Color(0xFF166534)),
      MemberStatus.expired => (
        'Expired',
        _expiredBadge,
        const Color(0xFF991B1B),
      ),
      MemberStatus.expiring => (
        'Expiring',
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
        onTap: () => onOpenViewMember(member),
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
                        'Plan',
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
                        'Expiry Date',
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
}
