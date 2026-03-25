import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/success_toast.dart';
import '../../../../shared/widgets/app_close_button.dart';
import 'view_member_mobile_modal.dart';
import 'add_member_modal.dart';
import 'modal_route_helper.dart';

/// Data for the View Member modal.
class ViewMemberData {
  const ViewMemberData({
    required this.name,
    required this.phone,
    required this.email,
    required this.plan,
    required this.expiry,
    required this.statusLabel,
    required this.statusColor,
  });

  final String name;
  final String phone;
  final String email;
  final String plan;
  final String expiry;
  final String statusLabel;
  final Color statusColor;
}

/// Modal shown when a member row is tapped in the members table.
class ViewMemberModal extends StatelessWidget {
  const ViewMemberModal({super.key, required this.member});

  final ViewMemberData member;

  static const _labelColor = Color(0xFF64748B);
  static const _valueColor = Color(0xFF0F172A);

  static const _dividerColor = Color(0xFFE2E8F0);
  static const _activeGreenBg = Color(0xFFDCFCE7);
  static const _activeGreenText = Color(0xFF166534);
  static const _actionIconColor = Color(0xFF475569);
  static const _actionCircleBg = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    if (isMobile) {
      return ViewMemberMobileModal(
        memberName: member.name,
        phone: member.phone,
        email: member.email,
        plan: member.plan,
        expiry: member.expiry,
        statusLabel: member.statusLabel,
        statusColor: member.statusColor,
        onClose: () => Navigator.of(context).pop(),
        onRenew: () {
          SuccessToast.show(context, title: 'Renewal started', popRoute: false);
        },
        onSendReminder: () {
          SuccessToast.show(
            context,
            title: 'Reminder Sent to ${member.name}',
            popRoute: false,
          );
        },
        onEdit: () {
          Navigator.of(context).pop();
          openModalWithTransition(
            context,
            AddMemberModal(
              initialFullName: member.name,
              initialPhone: member.phone,
              initialPlan: member.plan,
              isEditMode: true,
            ),
          );
        },
        onDelete: () => _showRemoveUserDialog(context),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
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
                      member.name,
                      style: Get.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _valueColor,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  _buildCloseButton(context),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [_statusPill()],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Divider(height: 1, thickness: 1, color: _dividerColor),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: _buildDetailsGrid(),
            ),
            const Divider(height: 1, thickness: 1, color: _dividerColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: _buildActionButtons(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return AppCloseButton(onPressed: () => Navigator.of(context).pop());
  }

  Widget _statusPill() {
    final isActive = member.statusLabel == 'Active';
    final bg = isActive
        ? _activeGreenBg
        : member.statusColor.withValues(alpha: 0.18);
    final fg = isActive ? _activeGreenText : member.statusColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        member.statusLabel,
        style: Get.textTheme.labelMedium?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildDetailsGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Phone Number', member.phone, bold: true),
              const SizedBox(height: 20),
              _detailRow('Plan', member.plan, bold: true),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Email Address', member.email, bold: false),
              const SizedBox(height: 20),
              _detailRow('Expiry', member.expiry, bold: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value, {bool bold = true}) {
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
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    const actions = [
      (icon: Icons.refresh, label: 'Renew'),
      (icon: Icons.notifications_outlined, label: 'Send Reminder'),
      (icon: Icons.edit_outlined, label: 'Edit'),
      (icon: Icons.delete_outlined, label: 'Delete'),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final a in actions)
          Expanded(child: _actionButton(context, a.icon, a.label)),
      ],
    );
  }

  Widget _actionButton(BuildContext context, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (label == 'Delete') {
                _showRemoveUserDialog(context);
              } else if (label == 'Send Reminder') {
                SuccessToast.show(
                  context,
                  title: 'Reminder Sent to ${member.name}',
                  popRoute: false,
                );
              } else if (label == 'Edit') {
                Navigator.of(context).pop();
                openModalWithTransition(
                  context,
                  AddMemberModal(
                    initialFullName: member.name,
                    initialPhone: member.phone,
                    initialPlan: member.plan,
                    isEditMode: true,
                  ),
                );
              } else {
                // TODO: handle Renew
                Navigator.of(context).pop();
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
              child: Icon(icon, size: 22, color: _actionIconColor),
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

  void _showRemoveUserDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => RemoveUserConfirmDialog(
        userName: member.name,
        onCancel: () => Navigator.of(ctx).pop(),
        onDelete: () {
          final overlayState = Overlay.of(ctx);
          Navigator.of(ctx).pop();
          Navigator.of(context).pop(); // close View Member modal
          SuccessToast.showRemoved(overlayState, member.name);
        },
      ),
    );
  }
}

/// Confirmation dialog shown when removing a user.
class RemoveUserConfirmDialog extends StatelessWidget {
  const RemoveUserConfirmDialog({
    super.key,
    required this.userName,
    required this.onCancel,
    required this.onDelete,
  });

  final String userName;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  static const _dividerColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
              padding: const EdgeInsets.fromLTRB(24, 24, 12, 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'Remove User?',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: AppCloseButton(onPressed: onCancel),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: _dividerColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Are you sure?',
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'You want to remove $userName.',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF334155),
                          side: const BorderSide(color: _dividerColor),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: onDelete,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
