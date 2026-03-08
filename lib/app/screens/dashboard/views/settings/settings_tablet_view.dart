import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsTabletView extends StatefulWidget {
  const SettingsTabletView({super.key});

  @override
  State<SettingsTabletView> createState() => _SettingsTabletViewState();
}

class _SettingsTabletViewState extends State<SettingsTabletView> {
  static const _textDark = Color(0xFF333333);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _purple = Color(0xFF4F46E5);
  static const _tabActiveBg = Color(0xFFEEF2FF);
  static const _cardShadow = Color(0x0F000000);

  int _selectedTabIndex = 0;
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
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(color: _cardShadow, blurRadius: 12, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabBar(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: _selectedTabIndex == 0 ? _buildProfileContent() : _buildLoginSecurityContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildTab('Profile', _selectedTabIndex == 0, () => setState(() => _selectedTabIndex = 0)),
        _buildTab('Login & Security', _selectedTabIndex == 1, () => setState(() => _selectedTabIndex = 1)),
      ],
    );
  }

  Widget _buildTab(String label, bool isSelected, VoidCallback onTap) {
    return Material(
      color: isSelected ? _tabActiveBg : Colors.white,
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
                color: isSelected ? _border : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          child: Text(
            label,
            style: Get.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected ? _purple : _textMuted,
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildLoginSecurityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Change Password',
          style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: _textDark),
        ),
        const SizedBox(height: 24),
        _buildPasswordField('Current Password', 'Enter Current Password', _currentPasswordController),
        const SizedBox(height: 20),
        _buildPasswordField('New Password', 'Enter New Password', _newPasswordController),
        const SizedBox(height: 20),
        _buildPasswordField('Confirm New Password', 'Confirm New Password', _confirmPasswordController),
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
                foregroundColor: _textDark,
                side: BorderSide(color: _border),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: _purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: _textDark),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: true,
          style: Get.textTheme.bodyMedium?.copyWith(color: _textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Get.textTheme.bodyMedium?.copyWith(color: _textMuted),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _purple, width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessLogoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Logo',
          style: Get.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: _textDark),
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
                border: Border.all(color: _border),
              ),
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Image.asset('assets/images/saas-logo.png', height: 40, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 16),
            _editButton(() {}),
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
            color: _textDark,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _businessNameController,
                style: Get.textTheme.bodyMedium?.copyWith(color: _textDark),
                decoration: InputDecoration(
                  hintText: 'SaaS',
                  hintStyle: Get.textTheme.bodyMedium?.copyWith(color: _textMuted),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: _border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: _border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _purple, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            _editButton(() {}),
          ],
        ),
      ],
    );
  }

  Widget _editButton(VoidCallback onPressed) {
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
            border: Border.all(color: _border),
            boxShadow: [BoxShadow(color: _cardShadow, blurRadius: 4, offset: const Offset(0, 1))],
          ),
          child: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF64748B)),
        ),
      ),
    );
  }

}
