import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/widgets/success_toast.dart';
import 'package:saas/shared/constants/app_strings.dart';

import '../../dialogs/delete_plan_confirm_dialog.dart';
import '../../modals/create_rule_modal.dart';
import '../../modals/create_template_modal.dart';
import '../../modals/modal_route_helper.dart';
import 'reminders_mobile_view.dart';
import 'package:saas/shared/constants/app_icons.dart';

class RemindersTabletView extends StatelessWidget {
  const RemindersTabletView({
    super.key,
    required this.rulesData,
    required this.templatesData,
  });

  final List<ReminderRuleRow> rulesData;
  final List<ReminderRuleRow> templatesData;

  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _iconCircleGreen = Color(0xFF16A34A);
  static const _whatsAppGreen = Color(0xFF25D366);
  static const _emailBlue = Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReminderRulesSection(context),
        const SizedBox(height: 28),
        _buildMessageTemplatesSection(context),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: _textDark,
        fontSize: 18,
      ),
    );
  }

  Widget _buildReminderRulesSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
            _buildRulesTable(context, rulesData),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTemplatesSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(12),
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
                        foregroundColor: _textDark,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
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
            _buildRulesTable(context, templatesData, isMessageTemplates: true),
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
          decoration: const BoxDecoration(
            color: Color(0xFFEEF2FF),
            border: Border(
              bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
          ),
          children: [
            _tableCell(AppStrings.triggerLabel, isHeader: true),
            _tableCell(AppStrings.timingLabel, isHeader: true),
            _tableCell(AppStrings.channelLabel, isHeader: true),
            _tableCell(AppStrings.audienceLabel, isHeader: true),
            _tableCell(AppStrings.status, isHeader: true),
            _tableCell(AppStrings.tableHeaderAction, isHeader: true),
          ],
        ),
        ...rows.map(
          (row) => TableRow(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            children: [
              _tableCell(row.trigger),
              _tableCell(row.timing),
              _tableCell(_channelIcons()),
              _tableCell(row.audience),
              _tableCell(_statusPill(row.isActive)),
              _tableCell(_actionIcons(context, row, isMessageTemplates)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _channelIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
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

  Widget _tableCell(dynamic content, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Align(
        alignment: Alignment.centerLeft,
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
    );
  }

  Widget _statusPill(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? AppStrings.active : AppStrings.inactive,
        style: Get.textTheme.bodySmall?.copyWith(
          color: _iconCircleGreen,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _actionIcons(
    BuildContext context,
    ReminderRuleRow row,
    bool isMessageTemplates,
  ) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(width: 4),
          _actionIcon(
            AppIcons.trash,
            onTap: () => _showDeleteConfirmDialog(
              context,
              isMessageTemplates: isMessageTemplates,
            ),
          ),
        ],
      ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
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
      ),
    );
  }
}
