import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/widgets/primary_action_button.dart';
import 'package:saas/shared/widgets/app_close_button.dart';
import 'package:saas/shared/constants/app_icons.dart';
import '../business/admin_add_business_content.dart';
import '../business/admin_business_content.dart';
import '../business/view_business_modal.dart';

class AdminDashboardTabletView extends StatelessWidget {
  const AdminDashboardTabletView({
    super.key,
    required this.selectedNavIndex,
    required this.isAddingBusiness,
    required this.editingBusiness,
    required this.onNavTap,
    required this.onLogout,
    required this.onAddBusinessTap,
    required this.onBackFromAddBusiness,
    required this.onEditBusinessTap,
  });

  final int selectedNavIndex;
  final bool isAddingBusiness;
  final ViewBusinessData? editingBusiness;
  final ValueChanged<int> onNavTap;
  final VoidCallback onLogout;
  final VoidCallback onAddBusinessTap;
  final VoidCallback onBackFromAddBusiness;
  final ValueChanged<ViewBusinessData> onEditBusinessTap;

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
  static const _dashboardVisibleItems = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
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
          child: Text(
            'ADMIN',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: _purple,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              AppIcons.headset,
              width: 20,
              colorFilter: const ColorFilter.mode(_textMuted, BlendMode.srcIn),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFF1F5F9),
              child: Image.asset(
                'assets/images/profile-icon.png',
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, color: _textMuted, size: 16),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: isAddingBusiness
          ? AdminAddBusinessContent(
              isMobile: false,
              onBack: onBackFromAddBusiness,
              isEditMode: editingBusiness != null,
              initialBusiness: editingBusiness,
            )
          : selectedNavIndex == 0
          ? _buildDashboardBody()
          : AdminBusinessContent(
              isMobile: false,
              isTablet: true,
              onAddBusinessTap: onAddBusinessTap,
              onEditBusinessTap: onEditBusinessTap,
            ),
    );
  }

  Widget _buildDashboardBody() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSummaryCards(),
          const SizedBox(height: 24),
          Expanded(child: _buildTableCard()),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppCloseButton(
                  onPressed: () => Navigator.of(context).pop(),
                  iconColor: const Color(0xFF64748B),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'ADMIN',
                style: Get.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: _purple,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildNavTile(context, 'Dashboard', index: 0),
            _buildNavTile(context, 'Business', index: 1),
            const Spacer(),
            const Divider(thickness: 1, color: _border, height: 1),
            _buildLogoutTile(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile(
    BuildContext context,
    String label, {
    required int index,
  }) {
    final isActive = selectedNavIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: isActive ? _purpleLight : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          onTap: () {
            onNavTap(index);
            Navigator.of(context).pop();
          },
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4,
          ),
          title: Text(
            label,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontSize: 18,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? _purple : _textMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ListTile(
        onTap: () {
          Navigator.of(context).pop();
          onLogout();
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: SvgPicture.asset(
          AppIcons.logOut,
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(_textMuted, BlendMode.srcIn),
        ),
        title: Text(
          'Logout',
          style: Get.textTheme.bodySmall?.copyWith(
            fontSize: 18,
            color: _textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
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
                'Manage Platform Business',
                style: Get.textTheme.bodyMedium?.copyWith(color: _textMuted),
              ),
            ],
          ),
        ),
        PrimaryActionButton(label: 'Add Business', onPressed: () {}),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2.2,
      children: [
        _buildStatCard('15', 'Total Business', _purple),
        _buildStatCard('12', 'Active', const Color(0xFF16A34A)),
        _buildStatCard('08', 'Expiring', const Color(0xFFF59E0B)),
        _buildStatCard('02', 'Suspended', const Color(0xFFDC2626)),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Get.textTheme.headlineSmall?.copyWith(
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTableCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
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
                        'Recently Added Business',
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: _textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () => onNavTap(1),
                      child: Text(
                        'View All Business',
                        style: Get.textTheme.labelMedium?.copyWith(
                          color: _purple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final visibleRows = _recentBusinessRows
                  .take(_dashboardVisibleItems)
                  .toList(growable: false);
              const maxCardWidth = 500.0;
              const spacing = 16.0;

              final columns = (constraints.maxWidth / maxCardWidth)
                  .floor()
                  .clamp(1, visibleRows.length);
              final rowCount = (visibleRows.length / columns).ceil();
              final availableHeight = constraints.maxHeight - ((rowCount - 1) * spacing);
              final dynamicCardHeight = (availableHeight / rowCount).clamp(170.0, 280.0);

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visibleRows.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: maxCardWidth,
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  mainAxisExtent: dynamicCardHeight,
                ),
                itemBuilder: (context, index) {
                  final row = visibleRows[index];
                  return _buildRecentBusinessCard(
                    business: row.business,
                    owner: row.owner,
                    plan: row.plan,
                    status: row.status,
                    expiry: row.expiry,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentBusinessCard({
    required String business,
    required String owner,
    required String plan,
    required String status,
    required String expiry,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    business,
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: _textDark,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
              ],
            ),
            const SizedBox(height: 10),
            Text(
              owner,
              style: Get.textTheme.bodySmall?.copyWith(color: _textMuted),
            ),
            const Spacer(),
            const Divider(height: 1, thickness: 1, color: _border),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoColumn('Plan', plan),
                _infoColumn('Expiry', expiry, alignRight: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String label, String value, {bool alignRight = false}) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.labelSmall?.copyWith(
            color: _textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Get.textTheme.bodySmall?.copyWith(
            color: _textDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
