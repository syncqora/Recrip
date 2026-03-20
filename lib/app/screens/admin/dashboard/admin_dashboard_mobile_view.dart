import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/widgets/primary_action_button.dart';
import 'package:saas/shared/widgets/app_close_button.dart';
import 'package:saas/shared/constants/app_icons.dart';
import '../business/admin_add_business_content.dart';
import '../business/admin_business_content.dart';
import '../business/view_business_modal.dart';

class AdminDashboardMobileView extends StatelessWidget {
  const AdminDashboardMobileView({
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
              isMobile: true,
              onBack: onBackFromAddBusiness,
              isEditMode: editingBusiness != null,
              initialBusiness: editingBusiness,
            )
          : selectedNavIndex == 0
          ? _buildDashboardBody()
          : AdminBusinessContent(
              isMobile: true,
              onAddBusinessTap: onAddBusinessTap,
              onEditBusinessTap: onEditBusinessTap,
            ),
    );
  }

  Widget _buildDashboardBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSummaryCards(),
          const SizedBox(height: 20),
          _buildTableCard(),
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
        child: InkWell(
          onTap: () {
            onNavTap(index);
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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

  Widget _buildLogoutTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            onLogout();
          },
          borderRadius: BorderRadius.circular(16),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage Platform Business',
          style: Get.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: _textMuted,
          ),
        ),
        const SizedBox(height: 16),
        PrimaryActionButton(label: 'Add Business', onPressed: () {}),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Get.textTheme.bodySmall?.copyWith(
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
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Recently Added Business',
                    style: Get.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: _purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildMobileRow(
            'T-rex Fitness Club',
            'Kattapadi Suresh',
            'Yearly',
            'Active',
            '01/01/2026',
          ),
          // To add more rows, just call _buildMobileRow for each.
        ],
      ),
    );
  }

  Widget _buildMobileRow(
    String business,
    String owner,
    String plan,
    String status,
    String expiry,
  ) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _border)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            business,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            owner,
            style: Get.textTheme.bodySmall?.copyWith(color: _textMuted),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Plan: $plan',
                style: Get.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Expiry: $expiry',
                style: Get.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status,
              style: Get.textTheme.labelMedium?.copyWith(
                color: const Color(0xFF166534),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
