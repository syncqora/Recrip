import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:saas/shared/widgets/primary_action_button.dart';

import '../../modals/create_rule_modal.dart';
import '../../modals/create_template_modal.dart';
import 'reminders_mobile_view.dart';
import 'reminders_tablet_view.dart';

/// Reminders page content: header, Reminder Rules table, Message Templates table.
/// Used inside the dashboard main content area when Reminders nav is selected.
class RemindersView extends StatelessWidget {
  const RemindersView({super.key});

  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF475569);
  static const _border = Color(0xFFE5E7EB);
  static const _iconCircleGreen = Color(0xFF16A34A);
  static const _whatsAppGreen = Color(0xFF25D366);
  static const _emailBlue = Color(0xFF2196F3);

  static final _reminderRulesData = [
    ReminderRuleRow(
      trigger: 'Before Expiry',
      timing: '7 Days before',
      audience: 'All Members',
    ),
  ];

  static final _messageTemplatesData = [
    ReminderRuleRow(
      trigger: 'Before Expiry',
      timing: '7 Days before',
      audience: 'All Members',
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
            _buildReminderRulesSection(),
            const SizedBox(height: 28),
            _buildMessageTemplatesSection(),
          ],
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
                    'Reminders',
                    style:
                        (isMobile
                                ? Get.textTheme.headlineSmall
                                : Get.textTheme.bodyLarge)
                            ?.copyWith(color: _textDark),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Automate renewal reminders across WhatsApp and Email',
                    style: Get.textTheme.bodySmall?.copyWith(color: _textMuted),
                  ),
                ],
              ),
            ),
            if (!isMobile)
              PrimaryActionButton(
                label: 'Create Reminder Rule',
                onPressed: () => Get.dialog(const CreateRuleModal()),
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryActionButton(
              label: 'Create Reminder Rule',
              onPressed: () => Get.dialog(const CreateRuleModal()),
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

  Widget _buildReminderRulesSection() {
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
            const SizedBox(height: 16),
            _buildRulesTable(_reminderRulesData),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTemplatesSection() {
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
                        'Message Templates',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: _textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Customize the message sent to members.',
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () => Get.dialog(const CreateTemplateModal()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _textDarkTable,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(168, 44),
                      maximumSize: const Size(168, 44),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      side: const BorderSide(
                        color: Color(0xFFE2E8F0),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Create Template'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildRulesTable(_messageTemplatesData, isMessageTemplates: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRulesTable(List<ReminderRuleRow> rows,
      {bool isMessageTemplates = false}) {
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
            _tableCell('Trigger', isHeader: true, align: Alignment.center),
            _tableCell('Timing', isHeader: true, align: Alignment.center),
            _tableCell('Channel', isHeader: true, align: Alignment.center),
            _tableCell('Audience', isHeader: true, align: Alignment.center),
            _tableCell('Status', isHeader: true, align: Alignment.center),
            _tableCell('Action', isHeader: true, align: Alignment.center),
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
                _actionIcons(row, isMessageTemplates),
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
        _channelCircle(
          assetPath: 'assets/icons/WhatsappLogo.svg',
          color: _whatsAppGreen,
        ),
        const SizedBox(width: 4),
        _channelCircle(assetPath: 'assets/icons/email.svg', color: _emailBlue),
      ],
    );
  }

  Widget _channelCircle({required String assetPath, required Color color}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Color(0xFFEEF2FF),
        shape: BoxShape.circle,
      ),
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
        'Active',
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

  Widget _actionIcons(ReminderRuleRow row, bool isMessageTemplates) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _actionIcon(
          'assets/icons/edit.svg',
          onTap: () {
            Get.dialog(
              CreateTemplateModal(
                title: 'Edit Template',
                initialTrigger: row.trigger,
                initialTiming: row.timing,
                initialAudience: row.audience,
                initialStatus: row.isActive ? 'Active' : 'Inactive',
              ),
            );
          },
        ),
        _actionIcon('assets/icons/trash.svg'),
      ],
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
