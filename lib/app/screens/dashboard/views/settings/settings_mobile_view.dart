import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'package:saas/shared/constants/app_icons.dart';

import 'payments_renewals_view.dart';

/// Mobile (`width < 600`) settings card.
///
/// Layout:
///  - Top: horizontally-scrollable pill tab bar (Profile · Login & Security ·
///    Payments & Renewals). Pills never truncate; users swipe to reach the
///    Payments tab if needed.
///  - Below: per-tab content with full-width form fields and full-width
///    Cancel/Save buttons that share the row 50/50.
class SettingsMobileView extends StatefulWidget {
  const SettingsMobileView({super.key});

  @override
  State<SettingsMobileView> createState() => _SettingsMobileViewState();
}

class _SettingsMobileViewState extends State<SettingsMobileView> {
  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _purple = Color(0xFF4F46E5);
  static const _purpleDisabled = Color(0xFFA5B4FC);
  static const _pillUnselected = Color(0xFFF1F5F9);
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

  bool get _isProfileDirty =>
      _businessNameController.text.trim() != _initialBusinessName.trim();

  bool get _isPasswordFormFilled =>
      _currentPasswordController.text.trim().isNotEmpty &&
      _newPasswordController.text.trim().isNotEmpty &&
      _confirmPasswordController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _initialBusinessName = _businessNameController.text;
    _businessNameController.addListener(_onFieldsChanged);
    _currentPasswordController.addListener(_onFieldsChanged);
    _newPasswordController.addListener(_onFieldsChanged);
    _confirmPasswordController.addListener(_onFieldsChanged);
  }

  void _onFieldsChanged() => setState(() {});

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
        boxShadow: const [
          BoxShadow(color: _cardShadow, blurRadius: 12, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabBar(),
          const Divider(height: 1, color: _border),
          Padding(padding: const EdgeInsets.all(16), child: _buildTabContent()),
        ],
      ),
    );
  }

  // -------- Tabs --------

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _pillTab(AppStrings.settingsProfileTabLabel, 0),
          const SizedBox(width: 8),
          _pillTab(AppStrings.settingsLoginSecurityTabLabel, 1),
          const SizedBox(width: 8),
          _pillTab(AppStrings.settingsPaymentsRenewalsTabLabel, 2),
        ],
      ),
    );
  }

  Widget _pillTab(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return Material(
      color: isSelected ? _purple : _pillUnselected,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: () => setState(() => _selectedTabIndex = index),
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: Get.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : _textDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 1:
        return _buildLoginSecurityContent();
      case 2:
        return const PaymentsRenewalsView();
      case 0:
      default:
        return _buildProfileContent();
    }
  }

  // -------- Profile --------

  Widget _buildProfileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBusinessLogoSection(),
        const SizedBox(height: 20),
        _buildBusinessNameSection(),
        const SizedBox(height: 24),
        _buildActionRow(
          onCancel: () => setState(() {
            _businessNameController.text = _initialBusinessName;
          }),
          onSave: _isProfileDirty
              ? () => FocusScope.of(context).unfocus()
              : null,
        ),
      ],
    );
  }

  // -------- Login & Security --------

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
        const SizedBox(height: 16),
        _buildPasswordField(
          AppStrings.currentPasswordLabel,
          AppStrings.enterCurrentPasswordHint,
          _currentPasswordController,
          isObscure: !_currentPasswordVisible,
          onToggleVisibility: () => setState(
            () => _currentPasswordVisible = !_currentPasswordVisible,
          ),
        ),
        const SizedBox(height: 14),
        _buildPasswordField(
          AppStrings.newPasswordLabel,
          AppStrings.enterNewPasswordHint,
          _newPasswordController,
          isObscure: !_newPasswordVisible,
          onToggleVisibility: () =>
              setState(() => _newPasswordVisible = !_newPasswordVisible),
        ),
        const SizedBox(height: 14),
        _buildPasswordField(
          AppStrings.confirmNewPasswordLabel,
          AppStrings.confirmNewPasswordHint,
          _confirmPasswordController,
          isObscure: !_confirmPasswordVisible,
          onToggleVisibility: () => setState(
            () => _confirmPasswordVisible = !_confirmPasswordVisible,
          ),
        ),
        const SizedBox(height: 24),
        _buildActionRow(
          onCancel: () => setState(() {
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmPasswordController.clear();
          }),
          onSave: _isPasswordFormFilled
              ? () => FocusScope.of(context).unfocus()
              : null,
        ),
      ],
    );
  }

  // -------- Shared widgets --------

  /// Full-width 50/50 Cancel / Save row. Looks balanced on phones.
  Widget _buildActionRow({
    required VoidCallback onCancel,
    required VoidCallback? onSave,
  }) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: _textDark,
              side: const BorderSide(color: _border),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(AppStrings.cancel),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: onSave,
            style: FilledButton.styleFrom(
              backgroundColor: _purple,
              disabledBackgroundColor: _purpleDisabled,
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(AppStrings.save),
          ),
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
        const SizedBox(height: 6),
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
              horizontal: 14,
              vertical: 12,
            ),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: SvgPicture.asset(
                isObscure ? AppIcons.eyeClose : AppIcons.eyeOpen,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  _textMuted,
                  BlendMode.srcIn,
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _border),
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
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: _border),
              ),
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Image.asset(
                  'assets/images/recrip.webp',
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
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
        const SizedBox(height: 10),
        TextField(
          controller: _businessNameController,
          style: Get.textTheme.bodyMedium?.copyWith(color: _textDark),
          decoration: InputDecoration(
            hintText: AppStrings.businessNameDefault,
            hintStyle: Get.textTheme.bodyMedium?.copyWith(color: _textMuted),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _border),
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

  Widget _editButton(VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: _border),
            boxShadow: const [
              BoxShadow(
                color: _cardShadow,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: const Icon(
            Icons.edit_outlined,
            size: 18,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
