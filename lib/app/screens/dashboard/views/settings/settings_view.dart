import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../authentication/widgets/app_constants.dart';
import '../../../authentication/widgets/auth_form_field_section.dart';
import '../../../authentication/widgets/auth_password_field.dart';
import '../../../authentication/widgets/auth_text_field.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'settings_mobile_view.dart';
import 'settings_tablet_view.dart';

/// Settings page: header, then one white card with tabs (Profile | Login & Security)
/// and content per tab. Matches Settings.png (Profile) and Settings1.png (Login & Security).
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const _textDark = Color(0xFF0F172A);
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
          AppStrings.settingsTitle,
          style:
              (isMobile
                      ? Get.textTheme.headlineSmall
                      : Get.textTheme.headlineMedium)
                  ?.copyWith(fontWeight: FontWeight.bold, color: _textDark),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.settingsSubtitle,
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
  final _businessNameController = TextEditingController(
    text: AppStrings.businessNameDefault,
  );
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    void listen() => setState(() {});
    _currentPasswordController.addListener(listen);
    _newPasswordController.addListener(listen);
    _confirmPasswordController.addListener(listen);
  }

  bool get _isPasswordFormValid =>
      _currentPasswordController.text.trim().isNotEmpty &&
      _newPasswordController.text.trim().isNotEmpty &&
      _confirmPasswordController.text.trim().isNotEmpty;

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
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSidebar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _selectedTabIndex == 0
                    ? _buildProfileContent()
                    : _buildLoginSecurityContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Left sidebar: Profile | Login & Security (vertical tabs)
  Widget _buildSidebar() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
        border: Border(right: BorderSide(color: widget.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSidebarTab(
            AppStrings.settingsProfileTabLabel,
            isSelected: _selectedTabIndex == 0,
            onTap: () => setState(() => _selectedTabIndex = 0),
          ),
          _buildSidebarTab(
            AppStrings.settingsLoginSecurityTabLabel,
            isSelected: _selectedTabIndex == 1,
            onTap: () => setState(() => _selectedTabIndex = 1),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarTab(
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? widget.tabActiveBg : Colors.transparent,
      borderRadius: BorderRadius.zero,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isSelected ? widget.purple : Colors.transparent,
                width: 3,
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

  /// Profile tab content: Business Logo row (title + Cancel/Save) + logo + Business Name (Settings.png)
  Widget _buildProfileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.businessLogoLabel,
              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: widget.textDark,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 94,
                  height: 44,
                  child: TextButton(
                    onPressed: _onCancelProfile,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: widget.textDark,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      minimumSize: const Size(94, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(width: 1, color: widget.border),
                      ),
                    ),
                    child: const Text(AppStrings.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 44,
                  child: FilledButton(
                    onPressed: _onSaveProfile,
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      minimumSize: const Size(88, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(AppStrings.save),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildBusinessLogoSection(),
        const SizedBox(height: 28),
        _buildBusinessNameSection(),
      ],
    );
  }

  Widget _buildBusinessLogoSection() {
    return Row(
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
              'assets/images/recrip.png',
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 16),
        _editButton(onPressed: () {}),
      ],
    );
  }

  Widget _buildBusinessNameSection() {
    return SizedBox(
      width: 280,
      child: AuthFormFieldSection(
        label: AppStrings.businessNameLabel,
        spacingAfterLabel: 8,
        child: AuthTextField(
          controller: _businessNameController,
          hint: AppStrings.businessNameDefault,
        ),
      ),
    );
  }

  /// Login & Security tab content: Change Password form (Settings.png)
  Widget _buildLoginSecurityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.changePasswordLabel,
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: widget.textDark,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 94,
                  height: 44,
                  child: TextButton(
                    onPressed: _onCancel,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: widget.textDark,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      minimumSize: const Size(94, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(width: 1, color: widget.border),
                      ),
                    ),
                    child: const Text(AppStrings.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 44,
                  child: FilledButton(
                    onPressed: _isPasswordFormValid ? _onSavePassword : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.purple,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFA5B4FC),
                      disabledForegroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      minimumSize: const Size(88, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(AppStrings.save),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: 280,
          child: AuthFormFieldSection(
            label: AppStrings.currentPasswordLabel,
            spacingAfterLabel: 8,
            child: AuthPasswordField(
              controller: _currentPasswordController,
              obscureText: !_currentPasswordVisible,
              onToggleVisibility: () => setState(
                () => _currentPasswordVisible = !_currentPasswordVisible,
              ),
              hint: AppStrings.enterCurrentPasswordHint,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 280,
              child: AuthFormFieldSection(
                label: AppStrings.newPasswordLabel,
                spacingAfterLabel: 8,
                child: AuthPasswordField(
                  controller: _newPasswordController,
                  obscureText: !_newPasswordVisible,
                  onToggleVisibility: () => setState(
                    () => _newPasswordVisible = !_newPasswordVisible,
                  ),
                  hint: AppStrings.enterNewPasswordHint,
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 280,
              child: AuthFormFieldSection(
                label: AppStrings.confirmNewPasswordLabel,
                spacingAfterLabel: 8,
                child: AuthPasswordField(
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisible,
                  onToggleVisibility: () => setState(
                    () => _confirmPasswordVisible = !_confirmPasswordVisible,
                  ),
                  hint: AppStrings.confirmNewPasswordHint,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onCancel() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  void _onCancelProfile() {
    _businessNameController.text =
        AppStrings.businessNameDefault; // reset to initial
  }

  void _onSaveProfile() {
    // TODO: validate and call API to save business name
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
          child: const Icon(
            Icons.edit_outlined,
            size: 20,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
