import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/app_close_button.dart';

class ViewMemberMobileModal extends StatelessWidget {
  const ViewMemberMobileModal({
    super.key,
    required this.memberName,
    required this.phone,
    required this.email,
    required this.plan,
    required this.expiry,
    required this.statusLabel,
    required this.statusColor,
    required this.onClose,
    required this.onRenew,
    required this.onSendReminder,
    required this.onEdit,
    required this.onDelete,
  });

  final String memberName;
  final String phone;
  final String email;
  final String plan;
  final String expiry;
  final String statusLabel;
  final Color statusColor;
  final VoidCallback onClose;
  final VoidCallback onRenew;
  final VoidCallback onSendReminder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static const _dividerColor = Color(0xFFE2E8F0);
  static const _labelColor = Color(0xFF64748B);
  static const _valueColor = Color(0xFF0F172A);
  static const _activeGreenBg = Color(0xFFDCFCE7);
  static const _activeGreenText = Color(0xFF166534);
  static const _actionTextColor = Color(0xFF334155);
  static const _sectionTitleColor = Color(0xFF334155);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 10, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      memberName,
                      style: Get.textTheme.headlineSmall?.copyWith(
                        color: _valueColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AppCloseButton(onPressed: onClose),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                children: [
                  _statusPill(),
                  const SizedBox(height: 16),
                  _sectionTitle('Member Details'),
                  const SizedBox(height: 10),
                  _listItem('Phone Number', phone),
                  _listItem('Email Address', email),
                  const SizedBox(height: 18),
                  _sectionTitle('Subscription'),
                  const SizedBox(height: 10),
                  _listItem('Plan', plan),
                  _listItem('Expiry', expiry),
                  const SizedBox(height: 18),
                  _actionList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusPill() {
    final isActive = statusLabel == 'Active';
    final bg = isActive ? _activeGreenBg : statusColor.withValues(alpha: 0.18);
    final fg = isActive ? _activeGreenText : statusColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        statusLabel,
        style: Get.textTheme.labelMedium?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.titleSmall?.copyWith(
        color: _sectionTitleColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _listItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Get.textTheme.bodySmall?.copyWith(
              color: _labelColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: _valueColor,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, thickness: 1, color: _dividerColor),
        ],
      ),
    );
  }

  Widget _actionList() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _dividerColor),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _actionButton('Renew', onRenew),
          const SizedBox(height: 10),
          _actionButton('Send Reminder', onSendReminder),
          const SizedBox(height: 10),
          _actionButton('Edit', onEdit),
          const SizedBox(height: 10),
          _actionButton(
            'Delete',
            onDelete,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDestructive
              ? const Color(0xFFB91C1C)
              : _actionTextColor,
          side: BorderSide(
            color: isDestructive
                ? const Color(0xFFFECACA)
                : const Color(0xFFCBD5E1),
          ),
          backgroundColor: isDestructive
              ? const Color(0xFFFEF2F2)
              : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Get.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
