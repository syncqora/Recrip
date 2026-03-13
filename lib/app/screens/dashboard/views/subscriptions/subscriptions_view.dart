import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saas/shared/widgets/primary_action_button.dart';

import '../../../../../shared/widgets/success_toast.dart';
import '../../dialogs/delete_plan_confirm_dialog.dart';
import '../../modals/create_plan_modal.dart';
import '../../modals/edit_plan_modal.dart';
import 'subscriptions_mobile_view.dart';
import 'subscriptions_tablet_view.dart';

/// Subscriptions page content: header, plans table.
/// Used inside the dashboard main content area when Subscriptions nav is selected.
class SubscriptionsView extends StatelessWidget {
  const SubscriptionsView({super.key});

  static const _purple = Color(0xFF4F46E5);
  static const _textDark = Color(0xFF333333);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _iconCircleGreen = Color(0xFF16A34A);

  static final _tableData = [
    SubscriptionPlanRow(
      planName: 'Monthly',
      duration: '30 Days',
      price: '₹1,499',
      activeMembers: '48',
    ),
    SubscriptionPlanRow(
      planName: 'Quarterly',
      duration: '3 Months',
      price: '₹3,999',
      activeMembers: '12',
    ),
    SubscriptionPlanRow(
      planName: 'Half Yearly',
      duration: '6 Months',
      price: '₹7,499',
      activeMembers: '06',
    ),
    SubscriptionPlanRow(
      planName: 'Yearly',
      duration: '12 Months',
      price: '₹14,499',
      activeMembers: '33',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    return SingleChildScrollView(
      padding: isMobile
          ? const EdgeInsets.all(16)
          : (isTablet ? const EdgeInsets.all(24) : EdgeInsets.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile),
          const SizedBox(height: 20),
          if (isMobile)
            SubscriptionsMobileView(
              tableData: _tableData,
              onEdit: (plan) => _showEditPlanDialog(context, plan),
              onDelete: (plan) => _showDeletePlanDialog(context),
            )
          else if (isTablet)
            SubscriptionsTabletView(
              tableData: _tableData,
              onEdit: (plan) => _showEditPlanDialog(context, plan),
              onDelete: (plan) => _showDeletePlanDialog(context),
            )
          else
            _buildDesktopTable(context),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Subscriptions',
                    style:
                        (isMobile
                                ? Get.textTheme.headlineSmall
                                : Get.textTheme.headlineMedium)
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _textDark,
                            ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage subscription plans and pricing',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: _textMuted,
                      fontSize: isMobile ? 13 : 14,
                    ),
                  ),
                ],
              ),
            ),
            if (!isMobile)
              PrimaryActionButton(
                label: 'Create Plan',
                onPressed: () => Get.dialog(const CreatePlanModal()),
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryActionButton(
              label: 'Create Plan',
              onPressed: () => Get.dialog(const CreatePlanModal()),
              useFixedSize: false,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDesktopTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.5),
          1: FlexColumnWidth(1.2),
          2: FlexColumnWidth(1.2),
          3: FlexColumnWidth(1.2),
          4: FlexColumnWidth(1),
          5: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
            children: [
              _tableCell('Plan Name',
                  isHeader: true, align: Alignment.centerLeft),
              _tableCell('Duration', isHeader: true, align: Alignment.center),
              _tableCell('Price', isHeader: true, align: Alignment.center),
              _tableCell('Active Members',
                  isHeader: true, align: Alignment.center),
              _tableCell('Status', isHeader: true, align: Alignment.center),
              _tableCell('Action', isHeader: true, align: Alignment.center),
            ],
          ),
          ..._tableData.map(
            (row) => TableRow(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
              ),
              children: [
                _tableCell(
                  row.planName,
                  align: Alignment.centerLeft,
                ),
                _tableCell(
                  row.duration,
                  align: Alignment.center,
                ),
                _tableCell(
                  row.price,
                  align: Alignment.center,
                ),
                _tableCell(
                  row.activeMembers,
                  align: Alignment.center,
                ),
                _tableCell(
                  _statusPill(row.isActive),
                  align: Alignment.center,
                ),
                _tableCell(
                  _actionIcons(context, row),
                  align: Alignment.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCell(
    dynamic content, {
    bool isHeader = false,
    Alignment align = Alignment.centerLeft,
  }) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Align(
          alignment: align,
          child: content is String
              ? Text(
                  content as String,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
                    color: _textDark,
                    fontSize: 14,
                  ),
                )
              : content as Widget,
        ),
      ),
    );
  }

  Widget _statusPill(bool isActive) {
    return Container(
      width: 92,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _iconCircleGreen,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        'Active',
        style: Get.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _actionIcons(BuildContext context, SubscriptionPlanRow row) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _actionIcon(
          'assets/icons/edit.svg',
          onTap: () => _showEditPlanDialog(context, row),
        ),
        _actionIcon(
          'assets/icons/trash.svg',
          onTap: () => _showDeletePlanDialog(context),
        ),
      ],
    );
  }

  void _showEditPlanDialog(BuildContext context, SubscriptionPlanRow row) {
    Get.dialog(
      EditPlanModal(
        plan: EditPlanData(
          planName: row.planName,
          duration: row.duration,
          price: row.price,
          isActive: row.isActive,
        ),
      ),
    );
  }

  void _showDeletePlanDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => DeletePlanConfirmDialog(
        onCancel: () => Navigator.of(ctx).pop(),
        onDelete: () {
          final overlayState = Overlay.of(ctx);
          Navigator.of(ctx).pop();
          SuccessToast.showWithOverlay(
            overlayState,
            title: 'Plan Deleted',
            iconColor: SuccessToast.iconColorRed,
          );
        },
      ),
    );
  }

  Widget _actionIcon(String assetPath, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF2FF),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              assetPath,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(_textMuted, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
