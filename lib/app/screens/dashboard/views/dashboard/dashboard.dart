import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../../modals/add_member_modal.dart';
import '../../modals/help_support_modal.dart';
import 'dashboard_mobile_view.dart';
import 'dashboard_tablet_view.dart';
import '../members/members_view.dart';
import '../reminders/reminders_view.dart';
import '../renewals/renewals_view.dart';
import '../reports/reports_view.dart';
import '../settings/settings_view.dart';
import '../subscriptions/subscriptions_view.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({super.key});

  static const _sidebarWidth = 264.0;
  static const _menuContentWidth = 220.0;

  // Design colors (exact from image)
  static const _purple = Color(0xFF4F46E5);
  static const _purpleLight = Color(0xFFEEEDFB); // Active nav background
  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _expiredBadge = Color(0xFFFEE2E2);
  static const _expiringBadge = Color(0xFFFEF3C7);
  static const _renewedGreen = Color(0xFF5AC464);
  static const _iconCirclePurple = Color(0xFF4F46E5);
  static const _iconCircleOrange = Color(0xFFF59E0B);
  static const _iconCircleRed = Color(0xFFDC2626);
  static const _iconCircleGreen = Color(0xFF16A34A);

  /// Breakpoint below which tablet layout (app bar + drawer) is used instead of web (sidebar).
  static const _tabletBreakpoint = 1024.0;

  /// Breakpoint below which mobile layout (compact app bar + single column) is used.
  static const _mobileBreakpoint = 600.0;

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());
    final width = MediaQuery.sizeOf(context).width;
    if (width < _mobileBreakpoint) {
      return const DashboardMobileView();
    }
    if (width < _tabletBreakpoint) {
      return const DashboardTabletView();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildSidebar(context),
          Expanded(child: _buildMainContent(context)),
        ],
      ),
    );
  }

  /// Footer shown only in the main content area (right of sidebar), centered, at the end of the column.
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

  static const _menuIcons = (
    dashboard: 'assets/icons/dashboard.png',
    members: 'assets/icons/users-round.png',
    subscriptions: 'assets/icons/calendar-days.png',
    renewals: 'assets/icons/calendar-sync.png',
    reminders: 'assets/icons/bell-ring.png',
    reports: 'assets/icons/chart-column-big.png',
    settings: 'assets/icons/settings.png',
  );

  Widget _buildSidebar(BuildContext context) {
    return Obx(() {
      final index = controller.selectedNavIndex.value;
      final navItems = [
        _NavItem(
          iconPath: _menuIcons.dashboard,
          label: 'Dashboard',
          isActive: index == 0,
        ),
        _NavItem(
          iconPath: _menuIcons.members,
          label: 'Members',
          isActive: index == 1,
        ),
        _NavItem(
          iconPath: _menuIcons.subscriptions,
          label: 'Subscriptions',
          isActive: index == 2,
        ),
        _NavItem(
          iconPath: _menuIcons.renewals,
          label: 'Renewals',
          isActive: index == 3,
        ),
        _NavItem(
          iconPath: _menuIcons.reminders,
          label: 'Reminders',
          isActive: index == 4,
        ),
        _NavItem(
          iconPath: _menuIcons.reports,
          label: 'Reports',
          isActive: index == 5,
        ),
        _NavItem(
          iconPath: _menuIcons.settings,
          label: 'Settings',
          isActive: index == 6,
        ),
      ];
      return Container(
        width: _sidebarWidth,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: _menuContentWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/saas-logo.png',
                              height: 36,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      ...navItems.asMap().entries.map(
                        (e) => _buildNavTile(e.value, e.key),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(thickness: 1, color: Color(0xFFCBD5E1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: _buildLogoutTile(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNavTile(_NavItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: item.isActive ? _purpleLight : Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          onTap: () => controller.onNavTap(index),
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 17),
            child: Row(
              children: [
                Image.asset(
                  item.iconPath,
                  width: 24,
                  height: 24,
                  color: item.isActive ? _purple : _textMuted,
                  colorBlendMode: BlendMode.srcIn,
                ),
                const SizedBox(width: 16),
                Text(
                  item.label,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontSize: 18,
                    color: item.isActive ? _purple : _textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          onTap: controller.onLogout,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 17),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/log-out.png',
                  width: 24,
                  height: 24,
                  color: _textMuted,
                  colorBlendMode: BlendMode.srcIn,
                ),
                const SizedBox(width: 16),
                Text(
                  'Logout',
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontSize: 18,
                    color: _textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildTopBar()],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
            ),
            child: Obx(() {
              final index = controller.selectedNavIndex.value;
              if (index == 1) return const MembersView();
              if (index == 2) return const SubscriptionsView();
              if (index == 3) return const RenewalsView();
              if (index == 4) return const RemindersView();
              if (index == 5) return const ReportsView();
              if (index == 6) return const SettingsView();
              return _buildDashboardBody(context);
            }),
          ),
        ),
        _buildFooter(),
      ],
    );
  }

  Widget _buildDashboardBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDashboardHeader(),
        const SizedBox(height: 24),
        _buildSummaryCards(),
        const SizedBox(height: 33),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 2, child: _buildRenewalsSection(context)),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAiInsightsCard(),
                    const SizedBox(height: 16),
                    _buildRevenueInsightsCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.only(right: 24, top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => Get.dialog(const HelpSupportModal()),
            borderRadius: BorderRadius.circular(24),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFEEF2FF),
              child: Image.asset(
                'assets/icons/headset.png',
                width: 24,
                height: 24,
                color: _textMuted,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 32),
          CircleAvatar(
            backgroundColor: const Color(0xFFEEF2FF),
            child: Image.asset('assets/images/profile-icon.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardHeader() {
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
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage everything here',
              style: Get.textTheme.bodyMedium?.copyWith(color: _textMuted),
            ),
          ],
        ),
        FilledButton(
          onPressed: () => Get.dialog(const AddMemberModal()),
          style: FilledButton.styleFrom(
            backgroundColor: _purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Add Member'),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final cards = [
      _SummaryCard(
        iconPath: 'assets/icons/users.png',
        iconColor: Colors.white,
        circleBg: _iconCirclePurple,
        value: '284',
        valueColor: Colors.black,
        label: 'Active Members',
      ),
      _SummaryCard(
        iconPath: 'assets/icons/alarm-clock.png',
        iconColor: Colors.white,
        circleBg: _iconCircleOrange,
        value: '18',
        valueColor: Colors.black,
        label: 'Expiring (7 Days)',
      ),
      _SummaryCard(
        iconPath: 'assets/icons/shield-x.png',
        iconColor: Colors.white,
        circleBg: _iconCircleRed,
        value: '7',
        valueColor: Colors.black,
        label: 'Expired',
      ),
      _SummaryCard(
        iconPath: 'assets/icons/book-check.png',
        iconColor: Colors.white,
        circleBg: _iconCircleGreen,
        value: '96',
        valueColor: Colors.black,
        label: 'Renewed (This Month)',
      ),
    ];
    return Row(
      children: [
        for (int i = 0; i < cards.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < cards.length - 1 ? 25 : 0),
              child: _summaryCard(cards[i]),
            ),
          ),
      ],
    );
  }

  Widget _summaryCard(_SummaryCard c) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.circleBg,
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              c.iconPath,
              width: 24,
              height: 24,
              color: c.iconColor,
              colorBlendMode: BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text(
                  c.value,
                  style: Get.textTheme.bodyLarge?.copyWith(
                    color: c.valueColor,
                    fontSize: 24,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                Text(
                  c.label,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: _textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRenewalsSection(BuildContext context) {
    final rows = [
      _RenewalRow(
        name: 'Rahul Kamath',
        plan: 'Quarterly',
        expiry: '01/01/2026',
        status: 'Expired',
        isExpired: true,
      ),
      _RenewalRow(
        name: 'Lina Benny Thomas',
        plan: 'Monthly',
        expiry: '15/01/2026',
        status: 'Expiring',
        isExpired: false,
      ),
      _RenewalRow(
        name: 'Ankith Rawat',
        plan: 'Yearly',
        expiry: '15/01/2026',
        status: 'Expiring',
        isExpired: false,
      ),
      _RenewalRow(
        name: 'Alex George',
        plan: 'Monthly',
        expiry: '15/01/2026',
        status: 'Expiring',
        isExpired: false,
      ),
      _RenewalRow(
        name: 'Mary Steenberg',
        plan: 'Yearly',
        expiry: '15/01/2026',
        status: 'Expiring',
        isExpired: false,
      ),
      _RenewalRow(
        name: 'Mary Steenberg',
        plan: 'Monthly',
        expiry: '15/01/2026',
        status: 'Expiring',
        isExpired: false,
      ),
      _RenewalRow(
        name: 'Mary Steenberg',
        plan: 'Quarterly',
        expiry: '15/01/2026',
        status: 'Expiring',
        isExpired: false,
      ),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Action Required - Renewals',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: _textDark,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                GestureDetector(
                  onTap: controller.onViewAllRenewals,
                  child: Text(
                    'View All Renewals',
                    style: Get.textTheme.labelMedium?.copyWith(
                      color: _purple,
                      fontWeight: FontWeight.w600,
                      //decoration: TextDecoration.underline,
                      decorationColor: _purple,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1),
              4: FixedColumnWidth(120),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  ),
                ),
                children: [
                  _tableCell(
                    'Name',
                    isHeader: true,
                    align: Alignment.centerLeft,
                  ),
                  _tableCell('Plan', isHeader: true, align: Alignment.center),
                  _tableCell('Expiry', isHeader: true, align: Alignment.center),
                  _tableCell('Status', isHeader: true, align: Alignment.center),
                  _tableCell('Action', isHeader: true, align: Alignment.center),
                ],
              ),
            ],
          ),
          Expanded(
            child: Scrollbar(
              thickness: 4,
              radius: const Radius.circular(2),
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1.2),
                    3: FlexColumnWidth(1),
                    4: FixedColumnWidth(120),
                  },
                  children: rows
                      .map(
                        (row) => TableRow(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                          ),
                          children: [
                            _tableCell(row.name, align: Alignment.centerLeft),
                            _tableCell(row.plan, align: Alignment.center),
                            _tableCell(row.expiry, align: Alignment.center),
                            _tableCell(
                              row.status,
                              isBadge: true,
                              isExpired: row.isExpired,
                              align: Alignment.center,
                            ),
                            _tableCell(
                              '',
                              isActions: true,
                              align: Alignment.center,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCell(
    String text, {
    bool isHeader = false,
    bool isBadge = false,
    bool isExpired = false,
    bool isActions = false,
    Alignment align = Alignment.centerLeft,
  }) {
    const horizontalPadding = 20.0;
    const verticalPadding = 12.0;

    Widget content = isActions
        ? FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _actionButton(iconPath: 'assets/icons/bell-ring.svg'),
                const SizedBox(width: 8),
                _actionButton(iconPath: 'assets/icons/renew.svg'),
              ],
            ),
          )
        : isBadge
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isExpired
                  ? const Color(0xFFDC2626)
                  : const Color(0xFFF59E0B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              text,
              style: Get.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        : Text(
            text,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: isHeader
                  ? const Color(0xFF475569)
                  : const Color(0xFF0F172A),
              fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Align(alignment: align, child: content),
    );
  }

  Widget _actionButton({required String iconPath}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
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

  Widget _buildAiInsightsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC7D2FE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'AI Insights',
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: Get.textTheme.bodySmall?.copyWith(
                color: _textMuted,
                fontWeight: FontWeight.w400,
              ),
              children: [
                const TextSpan(text: 'You may lose '),
                TextSpan(
                  text: '₹18,000',
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: _textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(
                  text:
                      ' this week due to 6 memberships expiring. Sending reminders today could recover ',
                ),
                TextSpan(
                  text: '₹12,500',
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: _textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                onTap: controller.onSendRemindersNow,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEDFB),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    'Send Reminders Now',
                    style: Get.theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _purple,
                    ),
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
    const chartSize = 140.0;
    // ₹18,624 recovered, ₹2,540 lost → blue ~88%, red ~12%
    final recoveredFraction = 18624 / (18624 + 2540);
    final lostFraction = 2540 / (18624 + 2540);
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Revenue Insights',
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: chartSize,
              height: chartSize,
              child: CustomPaint(
                painter: _DonutChartPainter(
                  segments: [
                    (_revenueRecoveredBlue, recoveredFraction),
                    (_revenueLostRed, lostFraction),
                  ],
                  strokeWidth: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _revenueLegendItem(
                color: _revenueRecoveredBlue,
                label: 'Revenue Recovered',
                value: '₹18,624',
              ),
              const SizedBox(width: 34),
              _revenueLegendItem(
                color: _revenueLostRed,
                label: 'Revenue Lost',
                value: '₹2,540',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _revenueLegendItem({
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Get.textTheme.bodySmall?.copyWith(
                color: _textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Get.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
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
    return oldDelegate.segments != segments ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _NavItem {
  final String iconPath;
  final String label;
  final bool isActive;

  _NavItem({
    required this.iconPath,
    required this.label,
    this.isActive = false,
  });
}

class _SummaryCard {
  final String iconPath;
  final Color iconColor;
  final Color circleBg;
  final String value;
  final Color valueColor;
  final String label;

  _SummaryCard({
    required this.iconPath,
    required this.iconColor,
    required this.circleBg,
    required this.value,
    required this.valueColor,
    required this.label,
  });
}

class _RenewalRow {
  final String name;
  final String plan;
  final String expiry;
  final String status;
  final bool isExpired;

  _RenewalRow({
    required this.name,
    required this.plan,
    required this.expiry,
    required this.status,
    required this.isExpired,
  });
}
