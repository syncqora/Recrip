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
              onAddBusinessTap: onAddBusinessTap,
              onEditBusinessTap: onEditBusinessTap,
            ),
    );
  }

  Widget _buildDashboardBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSummaryCards(),
          const SizedBox(height: 24),
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
    return Container(
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
                  onPressed: () {},
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
          LayoutBuilder(
            builder: (context, constraints) {
              return Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1.2),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEF2FF),
                      border: Border(bottom: BorderSide(color: _border)),
                    ),
                    children: [
                      _headerCell('Business'),
                      _headerCell('Owner'),
                      _headerCell('Plan'),
                      _headerCell('Status', align: Alignment.center),
                      _headerCell('Expiry', align: Alignment.center),
                    ],
                  ),
                  TableRow(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    children: [
                      _dataCell('T-rex Fitness Club'),
                      _dataCell('Kattapadi Suresh'),
                      _dataCell('Yearly'),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        child: Container(
                          width: 80,
                          height: 30,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Active',
                            style: Get.textTheme.labelMedium?.copyWith(
                              color: const Color(0xFF166534),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      _dataCell('01/01/2026', align: Alignment.center),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _headerCell(String text, {Alignment align = Alignment.centerLeft}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Align(
        alignment: align,
        child: Text(
          text,
          style: Get.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _dataCell(String text, {Alignment align = Alignment.centerLeft}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Align(
        alignment: align,
        child: Text(
          text,
          style: Get.textTheme.bodyMedium?.copyWith(color: _textDark),
        ),
      ),
    );
  }
}
