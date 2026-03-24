import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/core/controllers/app_settings_controller.dart';
import 'package:saas/core/di/get_injector.dart';
import 'package:saas/core/services/auth_service.dart';
import 'package:saas/routes/app_pages.dart';
import 'package:saas/shared/widgets/primary_action_button.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/widgets/hover_elevated_card.dart';

import '../business/admin_business_content.dart';
import 'admin_dashboard_mobile_view.dart';
import 'admin_dashboard_tablet_view.dart';
import '../business/admin_add_business_content.dart';
import '../business/view_business_modal.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedNavIndex = 0;
  bool _isAddingBusiness = false;
  ViewBusinessData? _editingBusiness;

  static const _sidebarWidth = 264.0;
  static const _purple = Color(0xFF4F46E5);
  static const _purpleLight = Color(0xFFF0F4FF);
  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _activeBadge = Color(0xFFDCFCE7);
  static const _activeText = Color(0xFF166534);
  static const _expiringBadge = Color(0xFFFEF3C7);
  static const _expiringText = Color(0xFF92400E);
  static const _expiredBadge = Color(0xFFFEE2E2);
  static const _expiredText = Color(0xFF991B1B);
  static const _dashboardVisibleRows = 6;

  Future<void> _onLogout() async {
    await Get.find<AuthService>().logout();
    if (!mounted) return;
    Get.find<AppSettingsController>().isUserLoggedIn.value = false;
    appNav.changePage(AppRoutes.home);
  }

  static const _recentBusinessRows = [
    (
      business: 'T-rex Fitness Club',
      owner: 'Kattapadi Suresh',
      plan: 'Yearly',
      status: 'Active',
      expiry: '18/03/2027',
    ),
    (
      business: 'Iron Forge Gym',
      owner: 'Rahul Menon',
      plan: 'Half Yearly',
      status: 'Expiring',
      expiry: '02/04/2026',
    ),
    (
      business: 'Urban Pulse Fitness',
      owner: 'Nikhil Shetty',
      plan: 'Quarterly',
      status: 'Expired',
      expiry: '14/02/2026',
    ),
    (
      business: 'Alpha Strength Studio',
      owner: 'Pranav Nair',
      plan: 'Yearly',
      status: 'Active',
      expiry: '11/11/2026',
    ),
    (
      business: 'Spartan Arena Gym',
      owner: 'Akhil Raj',
      plan: 'Monthly',
      status: 'Expiring',
      expiry: '28/03/2026',
    ),
    (
      business: 'Core Nation Fitness',
      owner: 'Arjun Pillai',
      plan: 'Yearly',
      status: 'Active',
      expiry: '30/12/2026',
    ),
    (
      business: 'LiftLab Performance',
      owner: 'Dinesh Kumar',
      plan: 'Quarterly',
      status: 'Expired',
      expiry: '05/01/2026',
    ),
    (
      business: 'Beast Mode Club',
      owner: 'Midhun Das',
      plan: 'Half Yearly',
      status: 'Active',
      expiry: '19/08/2026',
    ),
    (
      business: 'PeakFit Training Hub',
      owner: 'Srinath R',
      plan: 'Monthly',
      status: 'Expiring',
      expiry: '25/03/2026',
    ),
    (
      business: 'PowerHouse Athletics',
      owner: 'Vivek Balan',
      plan: 'Yearly',
      status: 'Active',
      expiry: '09/10/2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    const tabletBreakpoint = 1024.0;
    const mobileBreakpoint = 600.0;

    if (width < mobileBreakpoint) {
      return AdminDashboardMobileView(
        selectedNavIndex: _selectedNavIndex,
        isAddingBusiness: _isAddingBusiness,
        editingBusiness: _editingBusiness,
        onNavTap: (index) => setState(() {
          _selectedNavIndex = index;
          _isAddingBusiness = false;
          _editingBusiness = null;
        }),
        onLogout: _onLogout,
        onAddBusinessTap: () => setState(() {
          _editingBusiness = null;
          _isAddingBusiness = true;
        }),
        onBackFromAddBusiness: () => setState(() {
          _isAddingBusiness = false;
          _editingBusiness = null;
        }),
        onEditBusinessTap: (business) => setState(() {
          _editingBusiness = business;
          _isAddingBusiness = true;
        }),
      );
    }

    if (width < tabletBreakpoint) {
      return AdminDashboardTabletView(
        selectedNavIndex: _selectedNavIndex,
        isAddingBusiness: _isAddingBusiness,
        editingBusiness: _editingBusiness,
        onNavTap: (index) => setState(() {
          _selectedNavIndex = index;
          _isAddingBusiness = false;
          _editingBusiness = null;
        }),
        onLogout: _onLogout,
        onAddBusinessTap: () => setState(() {
          _editingBusiness = null;
          _isAddingBusiness = true;
        }),
        onBackFromAddBusiness: () => setState(() {
          _isAddingBusiness = false;
          _editingBusiness = null;
        }),
        onEditBusinessTap: (business) => setState(() {
          _editingBusiness = business;
          _isAddingBusiness = true;
        }),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSidebar(),
          Expanded(
            child: Container(
              color: const Color(0xFFFAFAFA),
              child: _buildMainContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: _sidebarWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: _border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'ADMIN',
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: _purple,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 48),
          _buildNavTile('Dashboard', index: 0),
          _buildNavTile('Business', index: 1),
          const Spacer(),
          const Divider(thickness: 1, color: _border, height: 1),
          _buildLogoutTile(),
        ],
      ),
    );
  }

  Widget _buildNavTile(String label, {required int index}) {
    final isActive = _selectedNavIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Material(
        color: isActive ? _purpleLight : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () => setState(() {
            _selectedNavIndex = index;
            _isAddingBusiness = false;
          }),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Text(
              label,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? _purple : _textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutTile() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: _onLogout,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.logOut,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    _textMuted,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Logout',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTopBar(),
        Expanded(
          child: _isAddingBusiness
              ? AdminAddBusinessContent(
                  isMobile: false,
                  isEditMode: _editingBusiness != null,
                  initialBusiness: _editingBusiness,
                  onBack: () => setState(() {
                    _isAddingBusiness = false;
                    _editingBusiness = null;
                  }),
                )
              : _selectedNavIndex == 0
              ? _buildDashboardBody()
              : AdminBusinessContent(
                  isMobile: false,
                  onAddBusinessTap: () =>
                      setState(() {
                    _editingBusiness = null;
                    _isAddingBusiness = true;
                  }),
                  onEditBusinessTap: (business) => setState(() {
                    _editingBusiness = business;
                    _isAddingBusiness = true;
                  }),
                ),
        ),
      ],
    );
  }

  Widget _buildDashboardBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildSummaryCards(),
          const SizedBox(height: 32),
          _buildTableCard(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFF1F5F9),
            radius: 20,
            child: SvgPicture.asset(
              AppIcons.headset,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(_textMuted, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor: const Color(0xFFF1F5F9),
            radius: 20,
            child: Image.asset(
              'assets/images/profile-icon.png',
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person, color: _textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage Platform Business',
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: _textMuted,
              ),
            ),
          ],
        ),
        PrimaryActionButton(
          label: 'Add Business',
          onPressed: () => setState(() => _isAddingBusiness = true),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: '15',
            label: 'Total Business',
            color: _purple,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: const _StatCard(
            value: '12',
            label: 'Active',
            color: Color(0xFF16A34A),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: const _StatCard(
            value: '08',
            label: 'Expiring',
            color: Color(0xFFF59E0B),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: const _StatCard(
            value: '02',
            label: 'Suspended',
            color: Color(0xFFDC2626),
          ),
        ),
      ],
    );
  }

  Widget _buildTableCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recently Added Business',
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _selectedNavIndex = 1;
                    _isAddingBusiness = false;
                    _editingBusiness = null;
                  }),
                  child: Text(
                    'View All Business',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: _purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildRecentBusinessTable(),
        ],
      ),
    );
  }

  Widget _buildRecentBusinessTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFEEF2FF)),
          children: [
            _headerCell('Business'),
            _headerCell('Owner'),
            _headerCell('Plan'),
            _headerCell('Status', align: Alignment.center),
            _headerCell('Expiry', align: Alignment.center),
          ],
        ),
        for (final row in _recentBusinessRows.take(_dashboardVisibleRows))
          TableRow(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: _border.withValues(alpha: 0.9)),
              ),
            ),
            children: [
              _dataCell(row.business),
              _dataCell(row.owner),
              _dataCell(row.plan),
              _statusCell(row.status),
              _dataCell(row.expiry, align: Alignment.center),
            ],
          ),
      ],
    );
  }

  Widget _headerCell(String text, {Alignment align = Alignment.centerLeft}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Align(
        alignment: align,
        child: Text(
          text,
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _dataCell(String text, {Alignment align = Alignment.centerLeft}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Align(
        alignment: align,
        child: Text(
          text,
          style: Get.textTheme.bodyMedium?.copyWith(color: _textDark),
        ),
      ),
    );
  }

  Widget _statusCell(String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: _statusBadgeColor(status),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            status,
            style: Get.textTheme.labelMedium?.copyWith(
              color: _statusTextColor(status),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Color _statusBadgeColor(String status) {
    switch (status.toLowerCase()) {
      case 'expired':
        return _expiredBadge;
      case 'expiring':
        return _expiringBadge;
      default:
        return _activeBadge;
    }
  }

  Color _statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'expired':
        return _expiredText;
      case 'expiring':
        return _expiringText;
      default:
        return _activeText;
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return HoverElevatedCard(
      accentColor: color,
      borderRadius: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
