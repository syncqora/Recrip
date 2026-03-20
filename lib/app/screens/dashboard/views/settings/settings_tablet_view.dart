import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'package:saas/shared/constants/app_icons.dart';

class SettingsTabletView extends StatefulWidget {
  const SettingsTabletView({super.key});

  @override
  State<SettingsTabletView> createState() => _SettingsTabletViewState();
}

class _SettingsTabletViewState extends State<SettingsTabletView> {
  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _purple = Color(0xFF4F46E5);
  static const _tabActiveBg = Color(0xFFEEF2FF);
  static const _cardShadow = Color(0x0F000000);

  int _selectedTabIndex = 0;
  final _businessNameController = TextEditingController(
    text: AppStrings.businessNameDefault,
  );
  late final String _initialBusinessName;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  bool get _isPasswordFormFilled =>
      _currentPasswordController.text.trim().isNotEmpty &&
      _newPasswordController.text.trim().isNotEmpty &&
      _confirmPasswordController.text.trim().isNotEmpty;

  bool get _isProfileDirty =>
      _businessNameController.text.trim() != _initialBusinessName.trim();

  void _onFieldsChanged() => setState(() {});

  @override
  void initState() {
    super.initState();
    _initialBusinessName = _businessNameController.text;
    _businessNameController.addListener(_onFieldsChanged);
    _currentPasswordController.addListener(_onFieldsChanged);
    _newPasswordController.addListener(_onFieldsChanged);
    _confirmPasswordController.addListener(_onFieldsChanged);
  }

  @override
  void dispose() {
    _businessNameController.removeListener(_onFieldsChanged);
    _currentPasswordController.removeListener(_onFieldsChanged);
    _newPasswordController.removeListener(_onFieldsChanged);
    _confirmPasswordController.removeListener(_onFieldsChanged);
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
          BoxShadow(
            color: _cardShadow,
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

  Widget _buildSidebar() {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
        border: Border(right: BorderSide(color: _border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSidebarTab(
            AppStrings.settingsProfileTabLabel,
            _selectedTabIndex == 0,
            () => setState(() => _selectedTabIndex = 0),
          ),
          _buildSidebarTab(
            AppStrings.settingsLoginSecurityTabLabel,
            _selectedTabIndex == 1,
            () => setState(() => _selectedTabIndex = 1),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarTab(String label, bool isSelected, VoidCallback onTap) {
    return Material(
      color: isSelected ? _tabActiveBg : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isSelected ? _purple : Colors.transparent,
                width: 3,
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
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () => setState(() {
                _businessNameController.text = _initialBusinessName;
              }),
              style: OutlinedButton.styleFrom(
                foregroundColor: _textDark,
                side: BorderSide(color: _border),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(AppStrings.cancel),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _isProfileDirty
                  ? () {
                      FocusScope.of(context).unfocus();
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: _purple,
                disabledBackgroundColor: const Color(0xFFA5B4FC),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginSecurityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.changePasswordLabel,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 24),
        _buildPasswordField(
          AppStrings.currentPasswordLabel,
          AppStrings.enterCurrentPasswordHint,
          _currentPasswordController,
          isObscure: !_currentPasswordVisible,
          onToggleVisibility: () => setState(
            () => _currentPasswordVisible = !_currentPasswordVisible,
          ),
        ),
        const SizedBox(height: 20),
        _buildPasswordField(
          AppStrings.newPasswordLabel,
          AppStrings.enterNewPasswordHint,
          _newPasswordController,
          isObscure: !_newPasswordVisible,
          onToggleVisibility: () =>
              setState(() => _newPasswordVisible = !_newPasswordVisible),
        ),
        const SizedBox(height: 20),
        _buildPasswordField(
          AppStrings.confirmNewPasswordLabel,
          AppStrings.confirmNewPasswordHint,
          _confirmPasswordController,
          isObscure: !_confirmPasswordVisible,
          onToggleVisibility: () => setState(
            () => _confirmPasswordVisible = !_confirmPasswordVisible,
          ),
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
                foregroundColor: _textDark,
                side: BorderSide(color: _border),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(AppStrings.cancel),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _isPasswordFormFilled
                  ? () {
                      FocusScope.of(context).unfocus();
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: _purple,
                disabledBackgroundColor: const Color(0xFFA5B4FC),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    String hint,
    TextEditingController controller, {
    required bool isObscure,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscure,
          style: Get.textTheme.bodyMedium?.copyWith(color: _textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Get.textTheme.bodyMedium?.copyWith(color: _textMuted),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: SvgPicture.asset(
                isObscure ? AppIcons.eyeClose : AppIcons.eyeOpen,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(_textMuted, BlendMode.srcIn),
              ),
            ),
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
      ],
    );
  }

  Widget _buildBusinessLogoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.businessLogoLabel,
          style: Get.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: _textDark,
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
                border: Border.all(color: _border),
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
          AppStrings.businessNameLabel,
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
                  hintText: AppStrings.businessNameDefault,
                  hintStyle: Get.textTheme.bodyMedium?.copyWith(
                    color: _textMuted,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
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
            boxShadow: [
              BoxShadow(
                color: _cardShadow,
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
