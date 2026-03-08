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
  static const _textDark = Color(0xFF333333);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
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
    final (String label, Color bg) = switch (member.status) {
      MemberStatus.active => ('Active', _iconCircleGreen),
      MemberStatus.expired => ('Expired', _iconCircleRed),
      MemberStatus.expiring => ('Expiring', _iconCircleOrange),
    };

    return Container(
      width: 92,
      height: 32,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: InkWell(
        onTap: () => onOpenViewMember(member),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _textDark,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
