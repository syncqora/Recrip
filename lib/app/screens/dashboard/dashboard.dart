import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'views/dashboard/dashboard_controller.dart';
import 'modals/add_member_modal.dart';
import 'modals/help_support_modal.dart';
import 'views/dashboard/dashboard_mobile_view.dart';
import 'views/dashboard/dashboard_tablet_view.dart';
import 'views/members/members_view.dart';
import 'views/reminders/reminders_view.dart';
import 'views/renewals/renewals_view.dart';
import 'views/reports/reports_view.dart';
import 'views/settings/settings_view.dart';
import 'views/subscriptions/subscriptions_view.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'package:saas/shared/constants/app_icons.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({super.key});

  static const _sidebarWidth = 264.0;
  static const _menuContentWidth = 220.0;

  // Design colors (exact from image)
  static const _purple = Color(0xFF4F46E5);
  static const _purpleLight = Color(0xFFEEEDFB); // Active nav background
  static const _sidebarIconColor = Color(0xFF64748B);
  static const _sidebarTextColor = Color(0xFF475569);
  static const _textDark = Color(0xFF333333);
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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (width < _mobileBreakpoint) {
      return const DashboardMobileView();
    }
    // In landscape: always use drawer (tap to open/close) like mobile, never persistent sidebar
    if (isLandscape || width < _tabletBreakpoint) {
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
          AppStrings.footerAllRightsReserved,
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
          label: AppStrings.navDashboard,
          isActive: index == 0,
        ),
        _NavItem(
          iconPath: _menuIcons.members,
          label: AppStrings.navMembers,
          isActive: index == 1,
        ),
        _NavItem(
          iconPath: _menuIcons.subscriptions,
          label: AppStrings.navSubscriptions,
          isActive: index == 2,
        ),
        _NavItem(
          iconPath: _menuIcons.renewals,
          label: AppStrings.navRenewals,
          isActive: index == 3,
        ),
        _NavItem(
          iconPath: _menuIcons.reminders,
          label: AppStrings.navReminders,
          isActive: index == 4,
        ),
        _NavItem(
          iconPath: _menuIcons.reports,
          label: AppStrings.navReports,
          isActive: index == 5,
        ),
        _NavItem(
          iconPath: _menuIcons.settings,
          label: AppStrings.navSettings,
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
            _buildLogoutTile(),
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
                  color: item.isActive ? _purple : _sidebarIconColor,
                  colorBlendMode: BlendMode.srcIn,
                ),
                const SizedBox(width: 16),
                Text(
                  item.label,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontSize: 18,
                    color: item.isActive ? _purple : _sidebarTextColor,
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
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: controller.onLogout,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 17),
          child: Row(
            children: [
              SvgPicture.asset(
                AppIcons.logOut,
                width: 24,
                height: 24,
                color: _sidebarIconColor,
                colorBlendMode: BlendMode.srcIn,
              ),
              const SizedBox(width: 16),
              Text(
                AppStrings.logout,
                style: Get.textTheme.bodySmall?.copyWith(
                  fontSize: 18,
                  color: _sidebarTextColor,
                ),
              ),
            ],
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
              return _buildDashboardBody();
            }),
          ),
        ),
        _buildFooter(),
      ],
    );
  }

  Widget _buildDashboardBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDashboardHeader(),
          const SizedBox(height: 24),
          _buildSummaryCards(),
          const SizedBox(height: 33),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildRenewalsSection()),
              const SizedBox(width: 24),
              SizedBox(
                width: 280,
                child: Column(
                  children: [
                    _buildAiInsightsCard(),
                    const SizedBox(height: 16),
                    _buildUpcomingRemindersCard(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
              child: SvgPicture.asset(
                AppIcons.headset,
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
              AppStrings.dashboardTitle,
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.manageEverythingHere,
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
          child: const Text(AppStrings.addMember),
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
        label: AppStrings.summaryActiveMembers,
      ),
      _SummaryCard(
        iconPath: 'assets/icons/alarm-clock.png',
        iconColor: Colors.white,
        circleBg: _iconCircleOrange,
        value: '18',
        valueColor: Colors.black,
        label: AppStrings.summaryExpiring7Days,
      ),
      _SummaryCard(
        iconPath: 'assets/icons/shield-x.png',
        iconColor: Colors.white,
        circleBg: _iconCircleRed,
        value: '7',
        valueColor: Colors.black,
        label: AppStrings.expired,
      ),
      _SummaryCard(
        iconPath: 'assets/icons/book-check.png',
        iconColor: Colors.white,
        circleBg: _iconCircleGreen,
        value: '96',
        valueColor: Colors.black,
        label: AppStrings.summaryRenewedThisMonth,
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

  Widget _buildRenewalsSection() {
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
    ];
    return Container(
      constraints: const BoxConstraints(minHeight: 401),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: Color(0xFFE2E8F0)),
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
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    AppStrings.actionRequiredRenewals,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: controller.onViewAllRenewals,
                  child: Text(
                    AppStrings.viewAllRenewals,
                    style: Get.textTheme.labelMedium?.copyWith(
                      color: Color(0xFF4F46E5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 640),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1.2),
                  3: FlexColumnWidth(1),
                  4: FixedColumnWidth(96),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Color(0xFFEEF2FF),
                      border: Border.all(color: Color(0xFFE2E8F0)),
                    ),
                    children: [
                      _tableCell(
                        AppStrings.tableHeaderName,
                        isHeader: true,
                        horizontalPadding: 24,
                        align: Alignment.centerLeft,
                      ),
                      _tableCell(
                        AppStrings.plan,
                        isHeader: true,
                        horizontalPadding: 24,
                        align: Alignment.center,
                      ),
                      _tableCell(
                        AppStrings.tableHeaderExpiry,
                        isHeader: true,
                        horizontalPadding: 24,
                        align: Alignment.center,
                      ),
                      _tableCell(
                        AppStrings.status,
                        isHeader: true,
                        horizontalPadding: 24,
                        align: Alignment.center,
                      ),
                      _tableCell(
                        AppStrings.tableHeaderAction,
                        isHeader: true,
                        horizontalPadding: 24,
                        align: Alignment.center,
                      ),
                    ],
                  ),
                  ...rows.asMap().entries.map(
                    (e) => TableRow(
                      decoration: BoxDecoration(
                        color: e.key.isEven
                            ? Colors.white
                            : const Color(0xFFFAFAFA),
                        border: Border.all(color: Color(0xFFE2E8F0)),
                      ),
                      children: [
                        _tableCell(
                          e.value.name,
                          horizontalPadding: 24,
                          align: Alignment.centerLeft,
                        ),
                        _tableCell(
                          e.value.plan,
                          horizontalPadding: 24,
                          align: Alignment.center,
                        ),
                        _tableCell(
                          e.value.expiry,
                          horizontalPadding: 24,
                          align: Alignment.center,
                        ),
                        _tableCell(
                          e.value.status,
                          isBadge: true,
                          isExpired: e.value.isExpired,
                          horizontalPadding: 24,
                          align: Alignment.center,
                        ),
                        _tableCell(
                          '',
                          isActions: true,
                          horizontalPadding: 24,
                          align: Alignment.center,
                        ),
                      ],
                    ),
                  ),
                ],
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
    double horizontalPadding = 16,
    Alignment align = Alignment.centerLeft,
  }) {
    Widget content = isActions
        ? FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _actionImage('assets/icons/bell-ring.png'),
                const SizedBox(width: 8),
                _actionImage('assets/icons/renew.png'),
              ],
            ),
          )
        : isBadge
        ? Container(
            width: 91,
            height: 32,
            decoration: BoxDecoration(
              color: isExpired ? _expiredBadge : _expiringBadge,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                text,
                style: Get.textTheme.labelSmall?.copyWith(
                  color: isExpired ? Color(0xFF991B1B) : Color(0xFF92400E),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          )
        : Text(
            text,
            style: Get.textTheme.labelMedium?.copyWith(
              color: isHeader ? Color(0xFF475569) : Color(0xFF0F172A),
              fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          );
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 14,
      ),
      child: Align(alignment: align, child: content),
    );
  }

  Widget _actionImage(String assetPath) {
    return CircleAvatar(
      backgroundColor: const Color(0xFFEEF2FF),
      child: Image.asset(
        assetPath,
        width: 18,
        height: 18,
        color: _textMuted,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }

  Widget _buildAiInsightsCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 280, minHeight: 140),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xFFC7D2FE), width: 1),
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
        children: [
          Text(
            AppStrings.aiInsightsTitle,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.aiInsightsFullMessage,
            style: Get.textTheme.bodySmall?.copyWith(
              color: _textMuted,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: controller.onSendRemindersNow,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _purple,
                  side: const BorderSide(color: _purple),
                  backgroundColor: Color(0xFFEEF2FF),
                  //  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppStrings.sendRemindersNow,
                  style: Get.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const _donutGreen = Color(0xFF9CAF88);
  static const _donutSalmon = Color(0xFFE8A598);
  static const _labelBlue = Color(0xFF4F46E5);

  Widget _buildUpcomingRemindersCard() {
    const chartSize = 100.0;
    return Container(
      constraints: const BoxConstraints(minHeight: 180),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
            AppStrings.revenueInsightsTitle,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: chartSize,
              height: chartSize,
              child: CustomPaint(
                painter: _DonutChartPainter(
                  segments: [(_donutGreen, 0.72), (_donutSalmon, 0.28)],
                  strokeWidth: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildChartLabel(String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: _labelBlue,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 6),
        Icon(icon, color: _labelBlue, size: 18),
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
