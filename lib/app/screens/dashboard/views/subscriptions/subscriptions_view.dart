import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saas/shared/widgets/primary_action_button.dart';
import 'package:saas/shared/constants/app_strings.dart';

import '../../../../../shared/widgets/success_toast.dart';
import '../../dialogs/delete_plan_confirm_dialog.dart';
import '../../modals/create_plan_modal.dart';
import '../../modals/edit_plan_modal.dart';
import '../../modals/modal_route_helper.dart';
import 'subscriptions_mobile_view.dart';
import 'subscriptions_tablet_view.dart';
import 'package:saas/shared/constants/app_icons.dart';

/// Subscriptions page content: header, plans table.
/// Used inside the dashboard main content area when Subscriptions nav is selected.
class SubscriptionsView extends StatefulWidget {
  const SubscriptionsView({super.key});

  @override
  State<SubscriptionsView> createState() => _SubscriptionsViewState();
}

class _SubscriptionsViewState extends State<SubscriptionsView> {
  static const _purple = Color(0xFF4F46E5);
  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _iconCircleGreen = Color(0xFFDCFCE7);
  static const _inactivePillBg = Color(0xFFFEE2E2);
  static const _inactivePillText = Color(0xFF991B1B);

  late List<SubscriptionPlanRow> _tableData;

  @override
  void initState() {
    super.initState();
    _tableData = [
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
        isActive: false,
      ),
    ];
  }

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
              onEdit: (plan, index) =>
                  _showEditPlanDialog(context, plan, index),
              onDelete: (plan, index) =>
                  _showDeletePlanDialog(context, plan, index),
            )
          else if (isTablet)
            SubscriptionsTabletView(
              tableData: _tableData,
              onEdit: (plan, index) =>
                  _showEditPlanDialog(context, plan, index),
              onDelete: (plan, index) =>
                  _showDeletePlanDialog(context, plan, index),
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
                    AppStrings.subscriptionsTitle,
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
                    AppStrings.subscriptionsSubtitle,
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
                label: AppStrings.createPlanLabel,
                onPressed: () => _showCreatePlanDialog(context),
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryActionButton(
              label: AppStrings.createPlanLabel,
              onPressed: () => _showCreatePlanDialog(context),
              useFixedSize: false,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDesktopTable(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
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
            decoration: const BoxDecoration(color: Color(0xFFEEF2FF)),
            children: [
              _tableCell(
                AppStrings.planNameHeader,
                isHeader: true,
                align: Alignment.centerLeft,
                isPlanNameColumn: true,
              ),
              _tableCell(
                AppStrings.tableHeaderDuration,
                isHeader: true,
                align: Alignment.center,
              ),
              _tableCell(
                AppStrings.tableHeaderPrice,
                isHeader: true,
                align: Alignment.center,
              ),
              _tableCell(
                AppStrings.activeMembersHeader,
                isHeader: true,
                align: Alignment.center,
              ),
              _tableCell(
                AppStrings.status,
                isHeader: true,
                align: Alignment.center,
              ),
              _tableCell(
                AppStrings.actionHeader,
                isHeader: true,
                align: Alignment.center,
              ),
            ],
          ),
          ..._tableData.asMap().entries.map(
            (entry) => TableRow(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              children: [
                _tableCell(
                  entry.value.planName,
                  align: Alignment.centerLeft,
                  isPlanNameColumn: true,
                ),
                _tableCell(entry.value.duration, align: Alignment.center),
                _tableCell(entry.value.price, align: Alignment.center),
                _tableCell(entry.value.activeMembers, align: Alignment.center),
                _tableCell(
                  _statusPill(entry.value.isActive),
                  align: Alignment.center,
                ),
                _tableCell(
                  _actionIcons(context, entry.value, entry.key),
                  align: Alignment.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _planNameColumnLeftPadding = 40.0;

  Widget _tableCell(
    dynamic content, {
    bool isHeader = false,
    bool isPlanNameColumn = false,
    Alignment align = Alignment.centerLeft,
  }) {
    const horizontalPadding = 12.0;
    final padding = isPlanNameColumn
        ? EdgeInsets.fromLTRB(
            horizontalPadding + _planNameColumnLeftPadding,
            0,
            horizontalPadding,
            0,
          )
        : const EdgeInsets.symmetric(horizontal: 12);
    return SizedBox(
      height: 50,
      child: Padding(
        padding: padding,
        child: Align(
          alignment: align,
          child: content is String
              ? Text(
                  content as String,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: isHeader ? FontWeight.w500 : FontWeight.normal,
                    color: _textDark,
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
        color: isActive ? _iconCircleGreen : _inactivePillBg,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        isActive ? AppStrings.active : AppStrings.inactive,
        style: Get.textTheme.bodySmall?.copyWith(
          color: isActive ? const Color(0xFF166534) : _inactivePillText,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _actionIcons(
    BuildContext context,
    SubscriptionPlanRow row,
    int index,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _actionIcon(
          AppIcons.edit,
          onTap: () => _showEditPlanDialog(context, row, index),
        ),
        _actionIcon(
          AppIcons.trash,
          onTap: () => _showDeletePlanDialog(context, row, index),
        ),
      ],
    );
  }

  void _showEditPlanDialog(
    BuildContext context,
    SubscriptionPlanRow row,
    int index,
  ) {
    openModalWithTransition(
      context,
      EditPlanModal(
        plan: EditPlanData(
          planName: row.planName,
          duration: row.duration,
          price: row.price,
          isActive: row.isActive,
        ),
        onSave: (updated) {
          setState(() {
            _tableData[index] = SubscriptionPlanRow(
              planName: updated.planName,
              duration: updated.duration,
              price: updated.price,
              activeMembers: row.activeMembers,
              isActive: updated.isActive,
            );
          });
        },
      ),
    );
  }

  void _showDeletePlanDialog(
    BuildContext context,
    SubscriptionPlanRow row,
    int index,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => DeletePlanConfirmDialog(
        onCancel: () => Navigator.of(ctx).pop(),
        onDelete: () {
          final overlayState = Overlay.of(ctx);
          Navigator.of(ctx).pop();
          setState(() => _tableData.removeAt(index));
          SuccessToast.showWithOverlay(
            overlayState,
            title: AppStrings.planDeletedTitle,
            iconColor: SuccessToast.iconColorRed,
          );
        },
      ),
    );
  }

  void _showCreatePlanDialog(BuildContext context) {
    openModalWithTransition(
      context,
      CreatePlanModal(
        onCreate: (result) {
          setState(() {
            _tableData = [
              ..._tableData,
              SubscriptionPlanRow(
                planName: result.planName,
                duration: result.duration,
                price: result.price,
                activeMembers: '0',
                isActive: result.isActive,
              ),
            ];
          });
          Navigator.of(context).pop();
          SuccessToast.show(
            context,
            title: AppStrings.planCreatedSuccessfullyTitle,
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
              colorFilter: const ColorFilter.mode(
                Color(0xFF64748B),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
