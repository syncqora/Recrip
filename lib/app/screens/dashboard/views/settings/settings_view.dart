import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'settings_mobile_view.dart';
import 'settings_tablet_view.dart';

/// Settings page: header, then one white card with tabs (Profile | Login & Security)
/// and content per tab. Matches Settings.png (Profile) and Settings1.png (Login & Security).
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const _textDark = Color(0xFF333333);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _purple = Color(0xFF4F46E5);
  static const _tabActiveBg = Color(0xFFEEF2FF); // light purple (active tab)
  static const _cardShadow = Color(0x0F000000);

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
          const SizedBox(height: 24),
          if (isMobile)
            const SettingsMobileView()
          else if (isTablet)
            const SettingsTabletView()
          else
            _SettingsContent(
              textDark: _textDark,
              textMuted: _textMuted,
              border: _border,
              purple: _purple,
              tabActiveBg: _tabActiveBg,
              cardShadow: _cardShadow,
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Settings',
          style: (isMobile
                  ? Get.textTheme.headlineSmall
                  : Get.textTheme.headlineMedium)
              ?.copyWith(
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage your business, preferences, and account',
          style: Get.textTheme.bodyMedium?.copyWith(
            color: _textMuted,
            fontSize: isMobile ? 13 : 14,
          ),
        ),
      ],
    );
  }
}

class _SettingsContent extends StatefulWidget {
  const _SettingsContent({
    required this.textDark,
    required this.textMuted,
    required this.border,
    required this.purple,
    required this.tabActiveBg,
    required this.cardShadow,
  });

  final Color textDark;
  final Color textMuted;
  final Color border;
  final Color purple;
  final Color tabActiveBg;
  final Color cardShadow;

  @override
  State<_SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<_SettingsContent> {
  int _selectedTabIndex = 0; // 0 = Profile, 1 = Login & Security
  final _businessNameController = TextEditingController(text: 'SaaS');
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _businessNameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.border),
        boxShadow: [
          BoxShadow(
            color: widget.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabBar(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: _selectedTabIndex == 0
                ? _buildProfileContent()
                : _buildLoginSecurityContent(),
          ),
        ],
      ),
    );
  }

  /// Horizontal tabs inside the card: Profile | Login & Security (Settings.png & Settings1.png)
  Widget _buildTabBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildTab(
          'Profile',
          isSelected: _selectedTabIndex == 0,
          onTap: () => setState(() => _selectedTabIndex = 0),
        ),
        _buildTab(
          'Login & Security',
          isSelected: _selectedTabIndex == 1,
          onTap: () => setState(() => _selectedTabIndex = 1),
        ),
      ],
    );
  }

  Widget _buildTab(String label, {required bool isSelected, required VoidCallback onTap}) {
    return Material(
      color: isSelected ? widget.tabActiveBg : Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border(
              bottom: BorderSide(
                color: isSelected ? widget.border : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          child: Text(
            label,
            style: Get.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected ? widget.purple : widget.textMuted,
            ),
          ),
        ),
      ),
    );
  }

  /// Profile tab content: Business Logo + Business Name (Settings.png)
  Widget _buildProfileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBusinessLogoSection(),
        const SizedBox(height: 28),
        _buildBusinessNameSection(),
      ],
    );
  }

  Widget _buildBusinessLogoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Logo',
          style: Get.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: widget.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: widget.border),
              ),
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Image.asset(
                  'assets/images/saas-logo.png',
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 16),
            _editButton(onPressed: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildBusinessNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Name',
          style: Get.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: widget.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _businessNameController,
                style: Get.textTheme.bodyMedium?.copyWith(color: widget.textDark),
                decoration: InputDecoration(
                  hintText: 'SaaS',
                  hintStyle: Get.textTheme.bodyMedium?.copyWith(color: widget.textMuted),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: widget.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: widget.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: widget.purple, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            _editButton(onPressed: () {}),
          ],
        ),
      ],
    );
  }

  /// Login & Security tab content: Change Password form (Settings1.png)
  Widget _buildLoginSecurityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Change Password',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: widget.textDark,
          ),
        ),
        const SizedBox(height: 24),
        _buildPasswordField(
          label: 'Current Password',
          hint: 'Enter Current Password',
          controller: _currentPasswordController,
        ),
        const SizedBox(height: 20),
        _buildPasswordField(
          label: 'New Password',
          hint: 'Enter New Password',
          controller: _newPasswordController,
        ),
        const SizedBox(height: 20),
        _buildPasswordField(
          label: 'Confirm New Password',
          hint: 'Confirm New Password',
          controller: _confirmPasswordController,
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () => setState(() {
                _currentPasswordController.clear();
                _newPasswordController.clear();
                _confirmPasswordController.clear();
              }),
              style: OutlinedButton.styleFrom(
                foregroundColor: widget.textDark,
                side: BorderSide(color: widget.border),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _onSavePassword,
              style: FilledButton.styleFrom(
                backgroundColor: widget.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: widget.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: true,
          style: Get.textTheme.bodyMedium?.copyWith(color: widget.textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Get.textTheme.bodyMedium?.copyWith(color: widget.textMuted),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.purple, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  void _onSavePassword() {
    // TODO: validate and call API to change password
  }

  Widget _editButton({required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: widget.border),
            boxShadow: [
              BoxShadow(
                color: widget.cardShadow,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF64748B)),
        ),
      ),
    );
  }
}
