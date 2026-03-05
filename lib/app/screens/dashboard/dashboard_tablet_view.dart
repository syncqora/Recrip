import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_member_modal.dart';
import 'dashboard_controller.dart';
import 'members_view.dart';
import 'reminders_view.dart';
import 'renewals_view.dart';
import 'reports_view.dart';
import 'settings_view.dart';
import 'subscriptions_view.dart';

/// Tablet layout: app bar with hamburger + drawer, no persistent sidebar.
/// Dashboard content: header, 2x2 KPI cards, AI Insights + Upcoming Reminders, renewals table.
class DashboardTabletView extends StatelessWidget {
  const DashboardTabletView({super.key});

  static const _purple = Color(0xFF4F46E5);
  static const _purpleLight = Color(0xFFEEEDFB);
  static const _textDark = Color(0xFF333333);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _expiredBadge = Color(0xFFFEE2E2);
  static const _expiringBadge = Color(0xFFFEF3C7);
  static const _iconCirclePurple = Color(0xFF4F46E5);
  static const _iconCircleOrange = Color(0xFFF59E0B);
  static const _iconCircleRed = Color(0xFFDC2626);
  static const _iconCircleGreen = Color(0xFF16A34A);

  static const _menuIcons = (
    dashboard: 'assets/icons/dashboard.png',
    members: 'assets/icons/users-round.png',
    subscriptions: 'assets/icons/calendar-days.png',
    renewals: 'assets/icons/calendar-sync.png',
    reminders: 'assets/icons/bell-ring.png',
    reports: 'assets/icons/chart-column-big.png',
    settings: 'assets/icons/settings.png',
  );

  static final _renewalRows = [
    _RenewalRow(name: 'Rahul Kamath', plan: 'Quarterly', expiry: '01/01/2026', status: 'Expired', isExpired: true),
    _RenewalRow(name: 'Lina Benny Thomas', plan: 'Monthly', expiry: '15/01/2026', status: 'Expiring', isExpired: false),
    _RenewalRow(name: 'Ankith Rawat', plan: 'Yearly', expiry: '15/01/2026', status: 'Expiring', isExpired: false),
    _RenewalRow(name: 'Alex George', plan: 'Monthly', expiry: '15/01/2026', status: 'Expiring', isExpired: false),
    _RenewalRow(name: 'Mary Steenberg', plan: 'Yearly', expiry: '15/01/2026', status: 'Expiring', isExpired: false),
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
              Image.asset('assets/images/saas-logo.png', height: 32),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            color: _textMuted,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFEEF2FF),
              child: Image.asset('assets/images/profile-icon.png', width: 24, height: 24),
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
        return _buildDashboardContent(controller);
      }),
    );
  }

  Widget _buildDashboardContent(DashboardController controller) {
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
          _buildRenewalsSection(controller),
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
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 28),
                  onPressed: () => Navigator.of(context).pop(),
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
                          color: isActive ? const Color(0xFFEEF2FF) : Colors.transparent,
                          borderRadius: BorderRadius.circular(32),
                          child: ListTile(
                            onTap: () {
                              controller.onNavTap(e.key);
                              Navigator.of(context).pop();
                            },
                            dense: true,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            leading: Image.asset(
                              _getIconForIndex(e.key),
                              width: 24,
                              height: 24,
                              color: isActive ? _purple : const Color(0xFF64748B),
                              colorBlendMode: BlendMode.srcIn,
                            ),
                            title: Text(
                              e.value,
                              style: TextStyle(
                                fontSize: 17,
                                color: isActive ? _purple : const Color(0xFF475569),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(height: 1, color: Color(0xFFF1F5F9)),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                controller.onLogout();
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 44, vertical: 12),
              leading: Image.asset(
                'assets/icons/log-out.png',
                width: 24,
                height: 24,
                color: const Color(0xFF64748B),
                colorBlendMode: BlendMode.srcIn,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
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
        FilledButton(
          onPressed: () => Get.dialog(const AddMemberModal()),
          style: FilledButton.styleFrom(
            backgroundColor: _purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Add Member'),
        ),
      ],
    );
  }

  Widget _buildSummaryGrid() {
    final cards = [
      _SummaryItem('assets/icons/users.png', _iconCirclePurple, '284', 'Active Members'),
      _SummaryItem('assets/icons/book-check.png', _iconCircleGreen, '96', 'Renewed (This Month)'),
      _SummaryItem('assets/icons/alarm-clock.png', _iconCircleOrange, '18', 'Expiring (7 Days)'),
      _SummaryItem('assets/icons/shield-x.png', _iconCircleRed, '7', 'Expired'),
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
            child: Image.asset(c.iconPath, width: 24, height: 24, color: Colors.white, colorBlendMode: BlendMode.srcIn),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(c.value, style: Get.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: _textDark)),
              const SizedBox(height: 4),
              Text(c.label, style: Get.textTheme.bodySmall?.copyWith(color: _textMuted, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFC7D2FE)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Insights', style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: _textDark)),
                const SizedBox(height: 12),
                Text(
                  'You may lose ₹18,000 this week due to 6 memberships expiring. Sending reminders today could recover ₹12,500.',
                  style: Get.textTheme.bodySmall?.copyWith(color: _textMuted),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () => Get.find<DashboardController>().onSendRemindersNow(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _purple,
                      side: const BorderSide(color: _purple),
                      backgroundColor: const Color(0xFFEEF2FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Send Reminders Now'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _border),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upcoming Reminders', style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: _textDark)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('John Doe', style: Get.textTheme.bodyMedium?.copyWith(color: _textDark)),
                    Text('WhatsApp . 18:20:36', style: Get.textTheme.bodySmall?.copyWith(color: _textMuted)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRenewalsSection(DashboardController controller) {
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
                Text(
                  'Action Required - Renewals',
                  style: Get.textTheme.titleMedium?.copyWith(color: const Color(0xFF0F172A), fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: controller.onViewAllRenewals,
                  child: Text(
                    'View All Renewals',
                    style: Get.textTheme.labelMedium?.copyWith(color: _purple, fontWeight: FontWeight.w600),
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
              4: FlexColumnWidth(1.2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: const Color(0xFFEEF2FF), border: Border(bottom: BorderSide(color: _border))),
                children: [
                  _tableCell('Name', isHeader: true),
                  _tableCell('Plan', isHeader: true),
                  _tableCell('Expiry', isHeader: true),
                  _tableCell('Status', isHeader: true),
                  _tableCell('Action', isHeader: true),
                ],
              ),
              ..._renewalRows.asMap().entries.map(
                    (e) => TableRow(
                      decoration: BoxDecoration(
                        color: e.key.isEven ? Colors.white : const Color(0xFFFAFAFA),
                        border: Border(bottom: BorderSide(color: _border)),
                      ),
                      children: [
                        _tableCell(e.value.name),
                        _tableCell(e.value.plan),
                        _tableCell(e.value.expiry),
                        _tableCellBadge(e.value.status, e.value.isExpired),
                        _tableCellActions(),
                      ],
                    ),
                  ),
            ],
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
        decoration: BoxDecoration(
          color: isExpired ? _expiredBadge : _expiringBadge,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: Get.textTheme.labelSmall?.copyWith(
            color: isExpired ? const Color(0xFF991B1B) : const Color(0xFF92400E),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _tableCellActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _actionIcon(Icons.notifications_outlined),
          const SizedBox(width: 4),
          _actionIcon(Icons.refresh),
          const SizedBox(width: 4),
          _actionIcon(Icons.visibility_outlined),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: const Color(0xFFEEF2FF),
      child: Icon(icon, size: 18, color: _textMuted),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          '© 2026 All rights reserved',
          style: Get.textTheme.bodySmall?.copyWith(color: _textMuted, fontSize: 12),
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
