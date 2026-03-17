import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/primary_action_button.dart';
import '../../../../../shared/widgets/success_toast.dart';
import 'dashboard_controller.dart';
import '../../modals/add_member_modal.dart';
import '../../modals/help_support_modal.dart';
import '../../modals/modal_route_helper.dart';
import '../../modals/modal_route_helper.dart';
import '../members/members_view.dart';
import '../reminders/reminders_view.dart';
import '../renewals/renewals_view.dart';
import '../reports/reports_view.dart';
import '../settings/settings_view.dart';
import '../subscriptions/subscriptions_view.dart';

/// Mobile layout: compact app bar + drawer, single-column scroll.
/// Dashboard content: header, 2x2 KPI cards, AI Insights, Revenue Insights, renewals as list cards, footer.
class DashboardMobileView extends StatelessWidget {
  const DashboardMobileView({super.key});

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
            mainAxisAlignment: MainAxisAlignment.center,
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
            padding: const EdgeInsets.only(right: 12),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildSummaryGrid(),
          const SizedBox(height: 20),
          _buildInsightsCard(),
          const SizedBox(height: 16),
          _buildRevenueInsightsCard(),
          const SizedBox(height: 20),
          _buildRenewalsSection(context, controller),
          const SizedBox(height: 24),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, DashboardController controller) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Image.asset('assets/images/saas-logo.png', height: 36),
                  const Spacer(),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFEEF2FF),
                    child: Image.asset('assets/images/profile-icon.png'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Navigation Items
            Expanded(
              child: Obx(() => ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: ['Dashboard', 'Members', 'Subscriptions', 'Renewals', 'Reminders', 'Reports', 'Settings']
                        .asMap()
                        .entries
                        .map((e) {
                      final isActive = controller.selectedNavIndex.value == e.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
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
            // Logout and Footer
            const Divider(thickness: 1, color: Color(0xFFCBD5E1)),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                controller.onLogout();
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 8),
              child: Text(
                '© 2026 All rights reserved',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: _textMuted,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
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

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: _textDark),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage everything here',
          style: Get.textTheme.bodyMedium?.copyWith(color: _textMuted, fontSize: 14),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: PrimaryActionButton(
            label: 'Add Member',
            onPressed: () => openModalWithTransition(context, const AddMemberModal()),
          ),
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
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: cards.map((c) => _summaryCard(c)).toList(),
    );
  }

  Widget _summaryCard(_SummaryItem c) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: c.bgColor, borderRadius: BorderRadius.circular(18)),
            alignment: Alignment.center,
            child: SvgPicture.asset(c.iconPath, width: 24, height: 24, color: Colors.white, colorBlendMode: BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(c.value, style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: _textDark), overflow: TextOverflow.ellipsis, maxLines: 1),
                const SizedBox(height: 2),
                Text(c.label, style: Get.textTheme.bodySmall?.copyWith(color: _textMuted, fontSize: 11, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis, maxLines: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC7D2FE), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }

  static const _revenueRecoveredBlue = Color(0xFF4DA5F2);
  static const _revenueLostRed = Color(0xFFFF7373);

  Widget _buildRevenueInsightsCard() {
    const chartSize = 100.0;
    final recoveredFraction = 18624 / (18624 + 2540);
    final lostFraction = 2540 / (18624 + 2540);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildRenewalsSection(BuildContext context, DashboardController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Action Required - Renewals',
                    style: Get.textTheme.titleSmall?.copyWith(color: const Color(0xFF0F172A), fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: controller.onViewAllRenewals,
                  child: Text(
                    'View All Renewals',
                    style: Get.textTheme.labelMedium?.copyWith(
                      color: _purple,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      decorationColor: _purple,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ..._renewalRows.map((row) => _renewalCard(context, row)),
        ],
      ),
    );
  }

  Widget _renewalCard(BuildContext context, _RenewalRow row) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _border, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.name, style: Get.textTheme.bodyMedium?.copyWith(color: _textDark, fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 4),
                Text('${row.plan} · ${row.expiry}', style: Get.textTheme.bodySmall?.copyWith(color: _textMuted, fontSize: 12)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: row.isExpired ? _expiredBadge : _expiringBadge,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    row.status,
                    style: Get.textTheme.labelMedium?.copyWith(
                      color: row.isExpired ? const Color(0xFF991B1B) : const Color(0xFF92400E),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _actionButton(iconPath: 'assets/icons/bell-ring.svg', onTap: () => SuccessToast.show(context, title: 'Reminders Sent')),
              const SizedBox(width: 8),
              _actionButton(iconPath: 'assets/icons/renew.svg'),
            ],
          ),
        ],
      ),
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
