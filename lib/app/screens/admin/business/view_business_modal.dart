import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:saas/app/screens/dashboard/dialogs/delete_plan_confirm_dialog.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/widgets/success_toast.dart';
import 'package:saas/shared/widgets/app_close_button.dart';
import 'view_business_mobile_modal.dart';

class ViewBusinessData {
  const ViewBusinessData({
    required this.businessName,
    required this.ownerName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.gstNumber,
    required this.buildingName,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.pincode,
    required this.plan,
    required this.startDate,
    required this.expiryDate,
    required this.statusLabel,
    required this.statusColor,
    required this.isActive,
  });

  final String businessName;
  final String ownerName;
  final String phoneNumber;
  final String emailAddress;
  final String gstNumber;
  final String buildingName;
  final String streetAddress;
  final String city;
  final String state;
  final String pincode;
  final String plan;
  final String startDate;
  final String expiryDate;
  final String statusLabel;
  final Color statusColor;
  final bool isActive;
}

/// Modal shown when clicking a business name in the admin Businesses screen.
class ViewBusinessModal extends StatelessWidget {
  const ViewBusinessModal({
    super.key,
    required this.business,
    this.onEditBusinessTap,
  });

  final ViewBusinessData business;
  final ValueChanged<ViewBusinessData>? onEditBusinessTap;

  static const _dividerColor = Color(0xFFE2E8F0);
  static const _labelColor = Color(0xFF64748B);
  static const _valueColor = Color(0xFF0F172A);

  static const _activeGreenBg = Color(0xFFDCFCE7);
  static const _activeGreenText = Color(0xFF166534);

  static const _actionIconColor = Color(0xFF475569);
  static const _actionCircleBg = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    if (isMobile) {
      return ViewBusinessMobileModal(
        business: business,
        onClose: () => Navigator.of(context).pop(),
        onRenew: () {
          SuccessToast.show(context, title: 'Renewal started', popRoute: false);
        },
        onSendReminder: () {
          SuccessToast.show(
            context,
            title: 'Reminder Sent to Business',
            popRoute: false,
          );
        },
        onEdit: () {
          Navigator.of(context).pop();
          onEditBusinessTap?.call(business);
        },
        onDelete: () => _showDeleteConfirmDialog(context),
      );
    }

    final bg = business.isActive ? _activeGreenBg : business.statusColor.withValues(alpha: 0.18);
    final fg = business.isActive ? _activeGreenText : business.statusColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        business.businessName,
                        style: Get.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _valueColor,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    AppCloseButton(onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      business.statusLabel,
                      style: Get.textTheme.labelMedium?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Divider(height: 1, thickness: 1, color: _dividerColor),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                child: _buildOwnerGrid(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(height: 1, thickness: 1, color: _dividerColor),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detailSectionTitle('Address'),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _detailColumn('Building Name', business.buildingName)),
                        const SizedBox(width: 18),
                        Expanded(child: _detailColumn('Street Address', business.streetAddress)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _detailColumn('City', business.city)),
                        const SizedBox(width: 18),
                        Expanded(child: _detailColumn('State', business.state)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _detailColumn('Pincode', business.pincode),
                    const SizedBox(height: 18),
                    _buildPlanDatesRow(),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: _dividerColor),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: _buildActionButtons(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerGrid() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            _gridCell('Owner Name', business.ownerName),
            _gridCell('Phone Number', business.phoneNumber),
            _gridCell('Email Address', business.emailAddress),
            _gridCell('GST Number', business.gstNumber),
          ],
        ),
      ],
    );
  }

  Widget _gridCell(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Get.textTheme.bodySmall?.copyWith(
              color: _labelColor,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: _valueColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _detailSectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.bodySmall?.copyWith(
        color: _labelColor,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildPlanDatesRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _detailColumn('Plan', business.plan),
        ),
        const SizedBox(width: 26),
        Expanded(
          child: _detailColumn('Start Date', business.startDate),
        ),
        const SizedBox(width: 26),
        Expanded(
          child: _detailColumn('Expiry', business.expiryDate),
        ),
      ],
    );
  }

  Widget _detailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.bodySmall?.copyWith(
            color: _labelColor,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: _valueColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    const actions = [
      (iconPath: AppIcons.renew, label: 'Renew'),
      (iconPath: AppIcons.bellRing, label: 'Send Reminder'),
      (iconPath: AppIcons.edit, label: 'Edit'),
      (iconPath: AppIcons.trash, label: 'Delete'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final a in actions) Expanded(child: _actionButton(context, a.iconPath, a.label)),
      ],
    );
  }

  Widget _actionButton(BuildContext context, String iconPath, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (label == 'Send Reminder') {
                SuccessToast.show(
                  context,
                  title: 'Reminder Sent to Business',
                  popRoute: false,
                );
              } else if (label == 'Renew') {
                SuccessToast.show(context, title: 'Renewal started', popRoute: false);
              } else if (label == 'Edit') {
                Navigator.of(context).pop();
                onEditBusinessTap?.call(business);
              } else if (label == 'Delete') {
                _showDeleteConfirmDialog(context);
              }
            },
            borderRadius: BorderRadius.circular(28),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _actionCircleBg,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  _actionIconColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: Get.textTheme.labelSmall?.copyWith(
            color: _actionIconColor,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => DeletePlanConfirmDialog(
        title: 'Delete Business?',
        bodyTitle: 'Are you sure?',
        bodyText: 'You want to delete this business.',
        onCancel: () => Navigator.of(ctx).pop(),
        onDelete: () {
          Navigator.of(ctx).pop();
          SuccessToast.show(context, title: 'Business deleted', popRoute: false);
          Navigator.of(context).pop(); // close ViewBusinessModal
        },
      ),
    );
  }
}
