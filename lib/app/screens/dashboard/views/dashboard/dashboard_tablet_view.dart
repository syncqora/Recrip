import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/primary_action_button.dart';
import '../../../../../shared/widgets/success_toast.dart';
import '../../../../../shared/widgets/app_close_button.dart';
import 'dashboard_controller.dart';
import '../../modals/add_member_modal.dart';
import '../../modals/help_support_modal.dart';
import '../members/members_view.dart';
import '../reminders/reminders_view.dart';
import '../renewals/renewals_view.dart';
import '../reports/reports_view.dart';
import '../settings/settings_view.dart';
import '../subscriptions/subscriptions_view.dart';

/// Tablet layout: app bar with hamburger + drawer, no persistent sidebar.
/// Dashboard content: header, 2x2 KPI cards, AI Insights + Upcoming Reminders, renewals table.
class DashboardTabletView extends StatelessWidget {
  const DashboardTabletView({super.key});

  static const _purple = Color(0xFF4F46E5);
  static const _purpleLight = Color(0xFFEEEDFB);
  static const _sidebarIconColor = Color(0xFF64748B);
  static const _sidebarTextColor = Color(0xFF475569);
  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _expiredBadge = Color(0xFFFEE2E2);
  static const _expiringBadge = Color(0xFFFEF3C7);
  static const _iconCirclePurple = Color(0xFF4F46E5);
  static const _iconCircleOrange = Color(0xFFF59E0B);
  static const _iconCircleRed = Color(0xFFDC2626);
  static const _iconCircleGreen = Color(0xFF16A34A);

  /// Matches the natural height of [Revenue Insights] (padding + title + chart + legend).
  static const _insightsRowHeight = 260.0;

  static const _menuIcons = (
    dashboard: 'assets/icons/dashboard.svg',
    members: 'assets/icons/users-round.svg',
    subscriptions: 'assets/icons/calendar-days.svg',
    renewals: 'assets/icons/calendar-sync.svg',
    reminders: 'assets/icons/bell-ring.svg',
    reports: 'assets/icons/chart-column-big.svg',
    settings: 'assets/icons/settings.svg',
  );

  static final _renewalRows = [
    _RenewalRow(name: 'Rahul Kamath', plan: 'Quarterly', expiry: '01/01/2026', status: 'Expired', isExpired: true),
    _RenewalRow(name: 'Lina Benny Thomas', plan: 'Monthly', expiry: '15/01/2026', status: 'Expiring', isExpired: false),
    _RenewalRow(name: 'Ankith Rawat', plan: 'Yearly', expiry: '15/01/2026', status: 'Expiring', isExpired: false),
    _RenewalRow(name: 'Alex George', plan: 'Monthly', expiry: '15/01/2026', status: 'Expiring', isExpired: false),
    _RenewalRow(name: 'Mary Steenberg', plan: 'Yearly', expiry: '15/01/2026', status: 'Expiring', isExpired: false),
    _RenewalRow(name: 'Mary Steenberg', plan: 'Monthly', expiry: '15/01/2026', status: 'Expiring', isExpired: false),
    _RenewalRow(name: 'Mary Steenberg', plan: 'Quarterly', expiry: '15/01/2026', status: 'Expiring', isExpired: false),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            color: _textDark,
          ),
        ),
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/saas-logo.png', height: 36),
            ],
          ),
        ),
        actions: [
          InkWell(
            onTap: () => Get.dialog(const HelpSupportModal()),
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFEEF2FF),
                child: SvgPicture.asset(
                  'assets/icons/headset.svg',
                  width: 24,
                  height: 24,
                  color: _textMuted,
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFEEF2FF),
              child: Image.asset('assets/images/profile-icon.png'),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context, controller),
      body: Obx(() {
        final index = controller.selectedNavIndex.value;
        if (index == 1) return const MembersView();
        if (index == 2) return const SubscriptionsView();
        if (index == 3) return const RenewalsView();
        if (index == 4) return const RemindersView();
        if (index == 5) return const ReportsView();
        if (index == 6) return const SettingsView();
        return _buildDashboardContent(context, controller);
      }),
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSummaryGrid(),
          const SizedBox(height: 24),
          _buildInsightsRow(),
          const SizedBox(height: 24),
          _buildRenewalsSection(context, controller),
          const SizedBox(height: 32),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, DashboardController controller) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Close Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppCloseButton(
                  onPressed: () => Navigator.of(context).pop(),
                  iconColor: const Color(0xFF64748B),
                  iconSize: 28,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Navigation Items
            Expanded(
              child: Obx(() => ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: ['Dashboard', 'Members', 'Subscriptions', 'Renewals', 'Reminders', 'Reports', 'Settings']
                        .asMap()
                        .entries
                        .map((e) {
                      final isActive = controller.selectedNavIndex.value == e.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: isActive ? _purpleLight : Colors.transparent,
                          borderRadius: BorderRadius.circular(28),
                          child: ListTile(
                            onTap: () {
                              controller.onNavTap(e.key);
                              Navigator.of(context).pop();
                            },
                            dense: true,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            leading: SvgPicture.asset(
                              _getIconForIndex(e.key),
                              width: 24,
                              height: 24,
                              color: isActive ? _purple : _sidebarIconColor,
                              colorBlendMode: BlendMode.srcIn,
                            ),
                            title: Text(
                              e.value,
                              style: Get.textTheme.bodySmall?.copyWith(
                                fontSize: 18,
                                color: isActive ? _purple : _sidebarTextColor,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
            ),
            // Logout
            const Divider(thickness: 1, color: Color(0xFFCBD5E1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  controller.onLogout();
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                leading: SvgPicture.asset(
                  'assets/icons/log-out.svg',
                  width: 24,
                  height: 24,
                  color: _sidebarIconColor,
                  colorBlendMode: BlendMode.srcIn,
                ),
                title: Text(
                  'Logout',
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontSize: 18,
                    color: _sidebarTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getIconForIndex(int i) {
    switch (i) {
      case 0: return _menuIcons.dashboard;
      case 1: return _menuIcons.members;
      case 2: return _menuIcons.subscriptions;
      case 3: return _menuIcons.renewals;
      case 4: return _menuIcons.reminders;
      case 5: return _menuIcons.reports;
      case 6: return _menuIcons.settings;
      default: return _menuIcons.dashboard;
    }
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Dashboard',
              style: Get.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: _textDark),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage everything here',
              style: Get.textTheme.bodyMedium?.copyWith(color: _textMuted),
            ),
          ],
        ),
        PrimaryActionButton(
          label: 'Add Member',
          onPressed: () => Get.dialog(const AddMemberModal()),
        ),
      ],
    );
  }

  Widget _buildSummaryGrid() {
    final cards = [
      _SummaryItem('assets/icons/users_tab.svg', _iconCirclePurple, '284', 'Active Members'),
      _SummaryItem('assets/icons/alarm-clock_tab.svg', _iconCircleOrange, '18', 'Expiring (7 Days)'),
      _SummaryItem('assets/icons/shield-x_tab.svg', _iconCircleRed, '7', 'Expired'),
      _SummaryItem('assets/icons/book-check_tab.svg', _iconCircleGreen, '96', 'Renewed (This Month)'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.8,
      children: cards.map((c) => _summaryCard(c)).toList(),
    );
  }

  Widget _summaryCard(_SummaryItem c) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: c.bgColor, borderRadius: BorderRadius.circular(24)),
            alignment: Alignment.center,
            child: SvgPicture.asset(c.iconPath, width: 24, height: 24, color: Colors.white, colorBlendMode: BlendMode.srcIn),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(c.value, style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: _textDark), overflow: TextOverflow.ellipsis, maxLines: 1),
                const SizedBox(height: 4),
                Text(c.label, style: Get.textTheme.bodySmall?.copyWith(color: _textMuted, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis, maxLines: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsRow() {
    return SizedBox(
      height: _insightsRowHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFC7D2FE), width: 1),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('AI Insights', style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: Get.textTheme.bodySmall?.copyWith(color: _textMuted, fontWeight: FontWeight.w400),
                      children: [
                        const TextSpan(text: 'You may lose '),
                        TextSpan(text: '₹18,000', style: Get.textTheme.bodySmall?.copyWith(color: _textDark, fontWeight: FontWeight.w600)),
                        const TextSpan(text: ' this week due to 6 memberships expiring. Sending reminders today could recover '),
                        TextSpan(text: '₹12,500', style: Get.textTheme.bodySmall?.copyWith(color: _textDark, fontWeight: FontWeight.w600)),
                        const TextSpan(text: '.'),
                      ],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Get.find<DashboardController>().onSendRemindersNow(),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: _purpleLight,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 1)),
                            ],
                          ),
                          child: Text(
                            'Send Reminders Now',
                            style: Get.theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: _purple),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _buildRevenueInsightsCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildRenewalsSection(BuildContext context, DashboardController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Action Required - Renewals',
                    style: Get.textTheme.titleMedium?.copyWith(color: const Color(0xFF0F172A), fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: controller.onViewAllRenewals,
                  child: Text(
                    'View All Renewals',
                    style: Get.textTheme.labelMedium?.copyWith(
                      color: _purple,
                      fontWeight: FontWeight.w600,
                      decorationColor: _purple,
                    ),
                  ),
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1.2),
                  3: FlexColumnWidth(1),
                  4: FixedColumnWidth(96),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
                    ),
                    children: [
                      _tableCell('Name', isHeader: true),
                      _tableCell('Plan', isHeader: true),
                      _tableCell('Expiry', isHeader: true),
                      _tableCell('Status', isHeader: true),
                      _tableCell('Action', isHeader: true),
                    ],
                  ),
                  ..._renewalRows.asMap().entries.map(
                    (e) =>                   TableRow(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
                    ),
                      children: [
                        _tableCell(e.value.name),
                        _tableCell(e.value.plan),
                        _tableCell(e.value.expiry),
                        _tableCellBadge(e.value.status, e.value.isExpired),
                        _tableCellActions(context, e.value),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: isHeader ? const Color(0xFF475569) : const Color(0xFF0F172A),
            fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _tableCellBadge(String text, bool isExpired) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Container(
        width: 91,
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isExpired ? _expiredBadge : _expiringBadge,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: Get.textTheme.labelMedium?.copyWith(
            color: isExpired ? const Color(0xFF991B1B) : const Color(0xFF92400E),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _tableCellActions(BuildContext context, _RenewalRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            _actionButton(iconPath: 'assets/icons/bell-ring.svg', onTap: () => SuccessToast.show(context, title: 'Reminders Sent')),
            const SizedBox(width: 8),
            _actionButton(
              iconPath: 'assets/icons/renew.svg',
              onTap: () => Get.dialog(
                AddMemberModal(
                  initialFullName: row.name,
                  initialPlan: row.plan,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _revenueRecoveredBlue = Color(0xFF4DA5F2);
  static const _revenueLostRed = Color(0xFFFF7373);

  Widget _buildRevenueInsightsCard() {
    const chartSize = 100.0;
    final recoveredFraction = 18624 / (18624 + 2540);
    final lostFraction = 2540 / (18624 + 2540);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('Revenue Insights', style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: _textDark)),
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: chartSize,
              height: chartSize,
              child: CustomPaint(
                painter: _DonutChartPainter(
                  segments: [(_revenueRecoveredBlue, recoveredFraction), (_revenueLostRed, lostFraction)],
                  strokeWidth: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _revenueLegendItem(color: _revenueRecoveredBlue, label: 'Revenue Recovered', value: '₹18,624'),
              const SizedBox(width: 34),
              _revenueLegendItem(color: _revenueLostRed, label: 'Revenue Lost', value: '₹2,540'),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _revenueLegendItem({required Color color, required String label, required String value}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: Get.textTheme.bodySmall?.copyWith(color: _textMuted, fontSize: 11, fontWeight: FontWeight.w400)),
            const SizedBox(height: 2),
            Text(value, style: Get.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _actionButton({required String iconPath, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFE0E7FF),
          child: SvgPicture.asset(
            iconPath,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(_textDark, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          '© 2026 All rights reserved',
          style: Get.textTheme.bodySmall?.copyWith(
            color: _textMuted,
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}

class _SummaryItem {
  final String iconPath;
  final Color bgColor;
  final String value;
  final String label;
  _SummaryItem(this.iconPath, this.bgColor, this.value, this.label);
}

class _RenewalRow {
  final String name;
  final String plan;
  final String expiry;
  final String status;
  final bool isExpired;
  _RenewalRow({required this.name, required this.plan, required this.expiry, required this.status, required this.isExpired});
}

class _DonutChartPainter extends CustomPainter {
  final List<(Color, double)> segments;
  final double strokeWidth;
  _DonutChartPainter({required this.segments, this.strokeWidth = 20});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - strokeWidth / 2;
    var startAngle = -math.pi / 2;
    for (final (color, fraction) in segments) {
      final sweepAngle = 2 * math.pi * fraction;
      final rect = Rect.fromCircle(center: center, radius: radius);
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.segments != segments || oldDelegate.strokeWidth != strokeWidth;
  }
}
