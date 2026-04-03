import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/dashboard/dialogs/delete_plan_confirm_dialog.dart';
import 'package:saas/app/screens/dashboard/modals/create_plan_modal.dart';
import 'package:saas/app/screens/dashboard/modals/edit_plan_modal.dart';
import 'package:saas/app/screens/dashboard/modals/modal_route_helper.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'package:saas/shared/widgets/success_toast.dart';

import 'subscriptions_binding.dart';
import 'subscriptions_controller.dart';
import 'widgets/subscription_plan_row.dart';
import 'widgets/subscriptions_desktop_table.dart';
import 'widgets/subscriptions_error_banner.dart';
import 'widgets/subscriptions_header.dart';
import 'widgets/subscriptions_mobile_view.dart';
import 'widgets/subscriptions_tablet_view.dart';

/// Shell: registers binding. [SubscriptionsController.onReady] loads data; use
/// [SubscriptionsController.refreshView] for pull-to-retry only.
///
/// Body: [GetView] + nested [Obx] boundaries per GetX feature template.
class SubscriptionsView extends StatefulWidget {
  const SubscriptionsView({super.key});

  @override
  State<SubscriptionsView> createState() => _SubscriptionsViewState();
}

class _SubscriptionsViewState extends State<SubscriptionsView> {
  @override
  void initState() {
    super.initState();
    SubscriptionsBinding.ensureRegistered();
  }

  @override
  Widget build(BuildContext context) {
    return const SubscriptionsViewBody();
  }
}

class SubscriptionsViewBody extends GetView<SubscriptionsController> {
  const SubscriptionsViewBody({super.key});

  static const _textMuted = Color(0xFF666666);

  @override
  Widget build(BuildContext context) {
    SubscriptionsBinding.ensureRegistered();

    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    return RefreshIndicator(
      onRefresh: controller.refreshView,
      child: Obx(() {
        final _ = controller.plans.length;
        final err = controller.errorMessage.value;
        final tableData = List<SubscriptionPlanRow>.from(controller.plans);
        final loading = controller.isLoading.value;

        return SingleChildScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: isMobile
              ? const EdgeInsets.all(16)
              : (isTablet ? const EdgeInsets.all(24) : EdgeInsets.zero),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubscriptionsHeader(
                isMobile: isMobile,
                onCreatePlan: () => _showCreatePlanDialog(context),
              ),
              if (err != null) ...[
                const SizedBox(height: 12),
                SubscriptionsErrorBanner(
                  message: err,
                  onRetry: controller.refreshView,
                ),
              ],
              const SizedBox(height: 20),
              if (loading && tableData.isEmpty)
                const SizedBox(
                  height: 220,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (!loading && tableData.isEmpty && err == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      AppStrings.subscriptionsEmptyState,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: _textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else if (isMobile)
                SubscriptionsMobileView(
                  tableData: tableData,
                  onEdit: (plan, index) =>
                      _showEditPlanDialog(context, plan, index),
                  onDelete: (plan, index) =>
                      _showDeletePlanDialog(context, plan, index),
                )
              else if (isTablet)
                SubscriptionsTabletView(
                  tableData: tableData,
                  onEdit: (plan, index) =>
                      _showEditPlanDialog(context, plan, index),
                  onDelete: (plan, index) =>
                      _showDeletePlanDialog(context, plan, index),
                )
              else
                SubscriptionsDesktopTable(
                  tableData: tableData,
                  onEdit: (plan, index) =>
                      _showEditPlanDialog(context, plan, index),
                  onDelete: (plan, index) =>
                      _showDeletePlanDialog(context, plan, index),
                ),
            ],
          ),
        );
      }),
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
          controller.updatePlanAt(
            index,
            SubscriptionPlanRow(
              planName: updated.planName,
              duration: updated.duration,
              price: updated.price,
              isActive: updated.isActive,
              remoteId: row.remoteId,
            ),
          );
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
          controller.removePlanAt(index);
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
          controller.addPlan(
            SubscriptionPlanRow(
              planName: result.planName,
              duration: result.duration,
              price: result.price,
              isActive: result.isActive,
            ),
          );
          Navigator.of(context).pop();
          SuccessToast.show(
            context,
            title: AppStrings.planCreatedSuccessfullyTitle,
          );
        },
      ),
    );
  }
}
