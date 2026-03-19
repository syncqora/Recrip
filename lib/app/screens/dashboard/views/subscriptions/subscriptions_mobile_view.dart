import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SubscriptionPlanRow {
  final String planName;
  final String duration;
  final String price;
  final String activeMembers;
  final bool isActive;

  SubscriptionPlanRow({
    required this.planName,
    required this.duration,
    required this.price,
    required this.activeMembers,
    this.isActive = true,
  });
}

class SubscriptionsMobileView extends StatelessWidget {
  const SubscriptionsMobileView({
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
    return Column(
      children: tableData.asMap().entries.map((e) => _buildPlanCard(e.value, e.key)).toList(),
    );
  }

  Widget _buildPlanCard(SubscriptionPlanRow plan, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.planName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: _textDark,
                ),
              ),
              _statusPill(plan.isActive),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn('Duration', plan.duration),
              _infoColumn('Price', plan.price),
              _infoColumn('Members', plan.activeMembers),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _actionButton('assets/icons/edit.svg', () => onEdit(plan, index)),
              const SizedBox(width: 12),
              _actionButton('assets/icons/trash.svg', () => onDelete(plan, index)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _textMuted, fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: _textDark,
          ),
        ),
      ],
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
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: isActive ? Colors.white : _inactivePillText,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _actionButton(String assetPath, VoidCallback onTap) {
    return InkWell(
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
    );
  }
}
