import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:saas/shared/widgets/primary_action_button.dart';
import 'package:saas/shared/widgets/success_toast.dart';
import 'package:saas/shared/constants/app_strings.dart';

import '../../dialogs/delete_plan_confirm_dialog.dart';
import '../../modals/create_rule_modal.dart';
import '../../modals/create_template_modal.dart';
import '../../modals/modal_route_helper.dart';
import 'reminders_mobile_view.dart';
import 'reminders_tablet_view.dart';
import 'package:saas/shared/constants/app_icons.dart';

/// Reminders page content: header, Reminder Rules table, Message Templates table.
/// Used inside the dashboard main content area when Reminders nav is selected.
class RemindersView extends StatelessWidget {
  const RemindersView({super.key});

  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _iconCircleGreen = Color(0xFF16A34A);
  static const _whatsAppGreen = Color(0xFF25D366);
  static const _emailBlue = Color(0xFF2196F3);

  static final _reminderRulesData = [
    ReminderRuleRow(
      trigger: AppStrings.reminderTriggerBeforeExpiry,
      timing: AppStrings.reminderTiming7DaysBefore,
      audience: AppStrings.reminderAudienceAllMembers,
    ),
  ];

  static final _messageTemplatesData = [
    ReminderRuleRow(
      trigger: AppStrings.reminderTriggerBeforeExpiry,
      timing: AppStrings.reminderTiming7DaysBefore,
      audience: AppStrings.reminderAudienceAllMembers,
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
          _buildHeader(context, isMobile),
          const SizedBox(height: 32),
          if (isMobile)
            RemindersMobileView(
              rulesData: _reminderRulesData,
              templatesData: _messageTemplatesData,
            )
          else if (isTablet)
            RemindersTabletView(
              rulesData: _reminderRulesData,
              templatesData: _messageTemplatesData,
            )
          else ...[
            _buildReminderRulesSection(context),
            const SizedBox(height: 28),
            _buildMessageTemplatesSection(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
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
                    AppStrings.remindersTitle,
                    style: Get.textTheme.bodyLarge?.copyWith(color: _textDark),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.remindersSubtitle,
                    style: Get.textTheme.bodySmall?.copyWith(color: _textMuted),
                  ),
                ],
              ),
            ),
            if (!isMobile)
              PrimaryActionButton(
                label: AppStrings.createReminderRuleLabel,
                onPressed: () =>
                    openModalWithTransition(context, const CreateRuleModal()),
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryActionButton(
              label: AppStrings.createReminderRuleLabel,
              onPressed: () =>
                  openModalWithTransition(context, const CreateRuleModal()),
              useFixedSize: false,
            ),
          ),
        ],
      ],
    );
  }

  static const _rulesCardBorderRadius = 12.0;
  static const _headerRowColor = Color(0xFFEEF2FF);
  static const _rowBorderColor = Color(0xFFE2E8F0);
  static const _textDarkTable = Color(0xFF475569);
  static const _tableValueTextColor = Color(0xFF0F172A);

  Widget _buildReminderRulesSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_rulesCardBorderRadius),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_rulesCardBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.reminderRulesTitle,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: _textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.reminderRulesSubtitle,
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: _textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildRulesTable(context, _reminderRulesData),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTemplatesSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_rulesCardBorderRadius),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_rulesCardBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.messageTemplatesTitle,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: _textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.messageTemplatesSubtitle,
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 168,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => openModalWithTransition(
                        context,
                        const CreateTemplateModal(),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _textDarkTable,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                        minimumSize: const Size(168, 44),
                        side: const BorderSide(
                          color: Color(0xFFE2E8F0),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(AppStrings.createTemplateLabel),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildRulesTable(
              context,
              _messageTemplatesData,
              isMessageTemplates: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRulesTable(
    BuildContext context,
    List<ReminderRuleRow> rows, {
    bool isMessageTemplates = false,
  }) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(0.9),
        5: FlexColumnWidth(0.9),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: _headerRowColor),
          children: [
            _tableCell(
              AppStrings.triggerLabel,
              isHeader: true,
              align: Alignment.center,
            ),
            _tableCell(
              AppStrings.timingLabel,
              isHeader: true,
              align: Alignment.center,
            ),
            _tableCell(
              AppStrings.channelLabel,
              isHeader: true,
              align: Alignment.center,
            ),
            _tableCell(
              AppStrings.audienceLabel,
              isHeader: true,
              align: Alignment.center,
            ),
            _tableCell(
              AppStrings.status,
              isHeader: true,
              align: Alignment.center,
            ),
            _tableCell(
              AppStrings.tableHeaderAction,
              isHeader: true,
              align: Alignment.center,
            ),
          ],
        ),
        ...rows.map(
          (row) => TableRow(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: _rowBorderColor, width: 1),
              ),
            ),
            children: [
              _tableCell(row.trigger, align: Alignment.center),
              _tableCell(row.timing, align: Alignment.center),
              _tableCell(_channelIcons(), align: Alignment.center),
              _tableCell(row.audience, align: Alignment.center),
              _tableCell(_statusPill(row.isActive), align: Alignment.center),
              _tableCell(
                _actionIcons(context, row, isMessageTemplates),
                align: Alignment.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _channelIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _channelCircle(assetPath: AppIcons.whatsappLogo, color: _whatsAppGreen),
        const SizedBox(width: 4),
        _channelCircle(assetPath: AppIcons.email, color: _emailBlue),
      ],
    );
  }

  Widget _channelCircle({required String assetPath, required Color color}) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(color: Color(0xFFEEF2FF), shape: BoxShape.circle),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(6),
      child: SvgPicture.asset(
        assetPath,
        width: 18,
        height: 18,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  static const _cellPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );

  Widget _tableCell(
    dynamic content, {
    bool isHeader = false,
    Alignment align = Alignment.center,
  }) {
    final inner = content is String
        ? Text(
            content as String,
            textAlign: TextAlign.center,
            // style: TextStyle(
            //   fontFamily: 'Inter',
            //   fontWeight: isHeader ? FontWeight.w500 : FontWeight.w400,
            //   fontSize: 14,
            //   height: 1.0,
            //   letterSpacing: 0,
            //   color: isHeader ? _textDarkTable : _tableValueTextColor,
            // ),
            style: Get.textTheme.bodySmall?.copyWith(
              color: isHeader ? _textDarkTable : _tableValueTextColor,
              fontWeight: isHeader ? FontWeight.w500 : FontWeight.w400,
            ),
          )
        : content as Widget;
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        width: double.infinity,
        padding: _cellPadding,
        alignment: Alignment.center,
        child: content is String
            ? SizedBox(width: double.infinity, child: inner)
            : inner,
      ),
    );
  }

  static const _statusPillWidth = 92.0;
  static const _statusPillHeight = 32.0;
  static const _statusPillBorderRadius = 32.0;

  Widget _statusPill(bool isActive) {
    return Container(
      width: _statusPillWidth,
      height: _statusPillHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(_statusPillBorderRadius),
      ),
      child: Text(
        isActive ? AppStrings.active : AppStrings.inactive,
        style: Get.textTheme.bodySmall?.copyWith(
          color: const Color(0xFF166534),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  static const _actionIconColor = Color(0xFF64748B);
  static const _actionIconBgColor = Color(0xFFEEF2FF);

  Widget _actionIcons(
    BuildContext context,
    ReminderRuleRow row,
    bool isMessageTemplates,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _actionIcon(
          AppIcons.edit,
          onTap: () {
            if (isMessageTemplates) {
              openModalWithTransition(
                context,
                CreateTemplateModal(
                  title: AppStrings.editTemplateTitle,
                  initialTrigger: row.trigger,
                  initialTiming: row.timing,
                  initialAudience: row.audience,
                  initialStatus: row.isActive
                      ? AppStrings.active
                      : AppStrings.inactive,
                ),
              );
            } else {
              openModalWithTransition(
                context,
                CreateRuleModal(
                  title: AppStrings.editRuleTitle,
                  initialTrigger: row.trigger,
                  initialTiming: row.timing,
                  initialAudience: row.audience,
                  initialStatus: row.isActive
                      ? AppStrings.active
                      : AppStrings.inactive,
                ),
              );
            }
          },
        ),
        _actionIcon(
          AppIcons.trash,
          onTap: () => _showDeleteConfirmDialog(
            context,
            isMessageTemplates: isMessageTemplates,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context, {
    required bool isMessageTemplates,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) => DeletePlanConfirmDialog(
        title: isMessageTemplates
            ? AppStrings.deleteTemplateTitle
            : AppStrings.deleteRuleTitle,
        bodyText: isMessageTemplates
            ? AppStrings.reminderTemplateDeletePrompt
            : AppStrings.reminderRuleDeletePrompt,
        onCancel: () => Navigator.of(ctx).pop(),
        onDelete: () {
          final overlayState = Overlay.of(ctx);
          Navigator.of(ctx).pop();
          SuccessToast.showWithOverlay(
            overlayState,
            title: isMessageTemplates
                ? AppStrings.templateDeletedTitle
                : AppStrings.ruleDeletedTitle,
            iconColor: SuccessToast.iconColorRed,
          );
        },
      ),
    );
  }

  Widget _actionIcon(String assetPath, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: _actionIconBgColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(6),
          child: SvgPicture.asset(
            assetPath,
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              _actionIconColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
