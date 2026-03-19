import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/widgets/success_toast.dart';
import '../../dialogs/delete_plan_confirm_dialog.dart';
import '../../modals/create_rule_modal.dart';
import '../../modals/create_template_modal.dart';
import '../../modals/modal_route_helper.dart';

class ReminderRuleRow {
  final String trigger;
  final String timing;
  final String audience;
  final bool isActive;

  ReminderRuleRow({
    required this.trigger,
    required this.timing,
    required this.audience,
    this.isActive = true,
  });
}

class RemindersMobileView extends StatelessWidget {
  const RemindersMobileView({
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
        _buildReminderRulesCard(context),
        const SizedBox(height: 24),
        _buildMessageTemplatesCard(context),
      ],
    );
  }

  Widget _buildReminderRulesCard(BuildContext context) {
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reminder Rules',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: _textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Define when and how reminders are sent automatically',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: _textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: _buildRulesTable(context, rulesData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTemplatesCard(BuildContext context) {
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Message Templates',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _textDark,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Customize the message sent to members.',
                          style: TextStyle(color: _textMuted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 168,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => openModalWithTransition(context, const CreateTemplateModal()),
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
                      child: const Text(
                        'Create Template',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: _buildRulesTable(
                context,
                templatesData,
                isMessageTemplates: true,
              ),
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
    return Column(
      children: rows
          .asMap()
          .entries
          .map(
            (entry) => _buildRuleCard(
              context,
              entry.value,
              entry.key,
              isMessageTemplates: isMessageTemplates,
            ),
          )
          .toList(),
    );
  }

  Widget _buildRuleCard(
    BuildContext context,
    ReminderRuleRow row,
    int index, {
    bool isMessageTemplates = false,
  }) {
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
              Expanded(
                child: Text(
                  row.trigger,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: _textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _statusPill(row.isActive),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoColumn('Timing', row.timing),
              _infoColumn('Audience', row.audience),
              if (!isMessageTemplates)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Channel',
                        style: TextStyle(color: _textMuted, fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                      _channelIcons(),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 12),
          ClipRect(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionIcons(context, row, isMessageTemplates),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }

  Widget _channelIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/icons/WhatsappLogo.svg',
          width: 18,
          height: 18,
          colorFilter: ColorFilter.mode(_whatsAppGreen, BlendMode.srcIn),
        ),
        const SizedBox(width: 8),
        SvgPicture.asset(
          'assets/icons/email.svg',
          width: 18,
          height: 18,
          colorFilter: ColorFilter.mode(_emailBlue, BlendMode.srcIn),
        ),
      ],
    );
  }

  Widget _statusPill(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Active',
        style: TextStyle(
          color: _iconCircleGreen,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _actionIcons(
    BuildContext context,
    ReminderRuleRow row,
    bool isMessageTemplates,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _actionIcon(
          'assets/icons/edit.svg',
          onTap: () {
            if (isMessageTemplates) {
              openModalWithTransition(
                context,
                CreateTemplateModal(
                  title: 'Edit Template',
                  initialTrigger: row.trigger,
                  initialTiming: row.timing,
                  initialAudience: row.audience,
                  initialStatus: row.isActive ? 'Active' : 'Inactive',
                ),
              );
            } else {
              openModalWithTransition(
                context,
                CreateRuleModal(
                  title: 'Edit Rule',
                  initialTrigger: row.trigger,
                  initialTiming: row.timing,
                  initialAudience: row.audience,
                  initialStatus: row.isActive ? 'Active' : 'Inactive',
                ),
              );
            }
          },
        ),
        const SizedBox(width: 12),
        _actionIcon(
          'assets/icons/trash.svg',
          onTap: () => _showDeleteConfirmDialog(
            context,
            row,
            isMessageTemplates: isMessageTemplates,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    ReminderRuleRow row, {
    required bool isMessageTemplates,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) => DeletePlanConfirmDialog(
        title: isMessageTemplates ? 'Delete Template?' : 'Delete Rule?',
        bodyText: isMessageTemplates
            ? 'You want to delete this message template.'
            : 'You want to delete this reminder rule.',
        onCancel: () => Navigator.of(ctx).pop(),
        onDelete: () {
          final overlayState = Overlay.of(ctx);
          Navigator.of(ctx).pop();
          SuccessToast.showWithOverlay(
            overlayState,
            title: isMessageTemplates ? 'Template Deleted' : 'Rule Deleted',
            iconColor: SuccessToast.iconColorRed,
          );
        },
      ),
    );
  }

  Widget _actionIcon(String assetPath, {VoidCallback? onTap}) {
    final child = Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(5),
      child: SvgPicture.asset(
        assetPath,
        width: 16,
        height: 16,
        colorFilter: ColorFilter.mode(_textMuted, BlendMode.srcIn),
      ),
    );
    if (onTap != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: child,
      );
    }
    return child;
  }

  Widget _tableCell(dynamic content, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: content is String
            ? Text(
                content as String,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
                  color: isHeader ? _textDark : _textMuted,
                ),
              )
            : content as Widget,
      ),
    );
  }
}
