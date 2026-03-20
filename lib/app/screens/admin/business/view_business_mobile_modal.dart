import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/widgets/app_close_button.dart';
import 'view_business_modal.dart';

class ViewBusinessMobileModal extends StatelessWidget {
  const ViewBusinessMobileModal({
    super.key,
    required this.business,
    required this.onClose,
    required this.onRenew,
    required this.onSendReminder,
    required this.onEdit,
    required this.onDelete,
  });

  final ViewBusinessData business;
  final VoidCallback onClose;
  final VoidCallback onRenew;
  final VoidCallback onSendReminder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static const _dividerColor = Color(0xFFE2E8F0);
  static const _labelColor = Color(0xFF64748B);
  static const _valueColor = Color(0xFF0F172A);
  static const _sectionTitleColor = Color(0xFF334155);
  static const _activeGreenBg = Color(0xFFDCFCE7);
  static const _activeGreenText = Color(0xFF166534);
  static const _actionIconColor = Color(0xFF475569);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 10, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      business.businessName,
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
                  _sectionTitle('Business Details'),
                  const SizedBox(height: 10),
                  _listItem('Owner Name', business.ownerName),
                  _listItem('Phone Number', business.phoneNumber),
                  _listItem('Email Address', business.emailAddress),
                  _listItem('GST Number', business.gstNumber),
                  const SizedBox(height: 18),
                  _sectionTitle('Business Address'),
                  const SizedBox(height: 10),
                  _listItem('Building Name', business.buildingName),
                  _listItem('Street Address', business.streetAddress),
                  _listItem('City', business.city),
                  _listItem('State', business.state),
                  _listItem('Pincode', business.pincode),
                  const SizedBox(height: 18),
                  _sectionTitle('Subscription Details'),
                  const SizedBox(height: 10),
                  _listItem('Plan', business.plan),
                  _listItem('Start Date', business.startDate),
                  _listItem('Expiry', business.expiryDate),
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
    final bg = business.isActive
        ? _activeGreenBg
        : business.statusColor.withValues(alpha: 0.18);
    final fg = business.isActive ? _activeGreenText : business.statusColor;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          business.statusLabel,
          style: Get.textTheme.labelMedium?.copyWith(
            color: fg,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
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
          _actionButton(AppIcons.renew, 'Renew', onRenew),
          const SizedBox(height: 10),
          _actionButton(AppIcons.bellRing, 'Send Reminder', onSendReminder),
          const SizedBox(height: 10),
          _actionButton(AppIcons.edit, 'Edit', onEdit),
          const SizedBox(height: 10),
          _actionButton(
            AppIcons.trash,
            'Delete',
            onDelete,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    String iconPath,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final fg = isDestructive ? const Color(0xFFB91C1C) : _actionIconColor;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: SvgPicture.asset(
          iconPath,
          width: 18,
          height: 18,
          colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
        ),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: fg,
          side: BorderSide(
            color: isDestructive
                ? const Color(0xFFFECACA)
                : const Color(0xFFCBD5E1),
          ),
          backgroundColor: isDestructive
              ? const Color(0xFFFEF2F2)
              : Colors.white,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
