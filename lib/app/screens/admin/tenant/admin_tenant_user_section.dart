import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/constants/admin_constants.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/themes/popup_menu_interaction_theme.dart';
import 'package:saas/shared/utils/admin_tenant_form_validators.dart';
import 'package:saas/shared/widgets/primary_action_button.dart';

import 'admin_tenant_user_controller.dart';

const Color _kTextDark = Color(0xFF0F172A);
const Color _kTextMuted = Color(0xFF64748B);
const Color _kBorder = Color(0xFFE2E8F0);
const Color _kBgFooter = Colors.white;

/// Label + field column matching [AdminAddBusinessContent._buildFieldWrapper].
Widget _fieldWrapper(String label, Widget child) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        label,
        style: Get.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E293B),
          fontSize: 12,
        ),
      ),
      const SizedBox(height: 8),
      child,
    ],
  );
}

/// Super-admin form: tenant → user → link user to tenant with a role.
///
/// Layout and field styling mirror [AdminAddBusinessContent].
class AdminTenantUserSection extends StatelessWidget {
  const AdminTenantUserSection({super.key, this.isMobile = false});

  /// [Get.put] / [Get.find] tag so the controller survives rebuilds.
  static const controllerTag = 'admin_tenant_user';

  final bool isMobile;

  AdminTenantUserController _controller() {
    if (!Get.isRegistered<AdminTenantUserController>(tag: controllerTag)) {
      Get.put(AdminTenantUserController(), tag: controllerTag);
    }
    return Get.find<AdminTenantUserController>(tag: controllerTag);
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: Form(
              key: c.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  SizedBox(height: isMobile ? 24 : 32),
                  _buildSectionHeader('Tenant details'),
                  const SizedBox(height: 16),
                  _buildResponsiveGrid([
                    _buildTextField(
                      'Name',
                      'E.g. Acme Corporation',
                      c.tenantName,
                      AdminTenantFormValidators.tenantName,
                    ),
                    _buildTextField(
                      'Slug',
                      'E.g. acme-corp',
                      c.tenantSlug,
                      AdminTenantFormValidators.tenantSlug,
                    ),
                    _buildTextField(
                      'Domain',
                      'E.g. acme.example.com',
                      c.tenantDomain,
                      AdminTenantFormValidators.tenantDomain,
                    ),
                    _buildTextField(
                      'Logo URL',
                      'E.g. https://example.com/logo.png',
                      c.tenantLogoUrl,
                      AdminTenantFormValidators.logoUrl,
                    ),
                    _buildMultilineField(
                      'Description',
                      'Tenant description',
                      c.tenantDescription,
                      AdminTenantFormValidators.tenantDescription,
                    ),
                  ]),
                  SizedBox(height: isMobile ? 24 : 32),
                  _buildSectionHeader('User details'),
                  const SizedBox(height: 16),
                  _buildResponsiveGrid([
                    _buildTextField(
                      'Username',
                      'E.g. janedoe',
                      c.userUsername,
                      AdminTenantFormValidators.username,
                    ),
                    _buildTextField(
                      'Email',
                      'E.g. jane.doe@example.com',
                      c.userEmail,
                      AdminTenantFormValidators.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Obx(
                      () => _buildPasswordField(
                        c.userPassword,
                        c.isPasswordVisible.value,
                        c.togglePasswordVisibility,
                        AdminTenantFormValidators.password,
                      ),
                    ),
                    _buildTextField(
                      'First name',
                      'E.g. Jane',
                      c.userFirstName,
                      AdminTenantFormValidators.firstName,
                    ),
                    _buildTextField(
                      'Last name',
                      'E.g. Doe',
                      c.userLastName,
                      AdminTenantFormValidators.lastName,
                    ),
                  ]),
                  SizedBox(height: isMobile ? 24 : 32),
                  _buildSectionHeader('Tenant membership'),
                  const SizedBox(height: 16),
                  _buildResponsiveGrid([_TenantRoleFilterField(controller: c)]),
                ],
              ),
            ),
          ),
        ),
        _buildFooter(c),
      ],
    );
  }

  Widget _buildHeader() {
    final titleCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tenant & user onboarding',
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: _kTextDark,
          ),
        ),
        SizedBox(height: isMobile ? 4 : 8),
        Text(
          'Create a tenant, a user, then link the user to the tenant with a role.',
          style: Get.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: _kTextMuted,
          ),
        ),
      ],
    );

    if (isMobile) {
      return titleCol;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Expanded(child: titleCol)],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Get.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: const Color(0xFF334155),
      ),
    );
  }

  Widget _buildResponsiveGrid(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var crossAxisCount = 4;
        if (isMobile || constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1000) {
          crossAxisCount = 2;
        }

        const spacing = 16.0;
        const runSpacing = 16.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
            crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children
              .map((child) => SizedBox(width: itemWidth, child: child))
              .toList(),
        );
      },
    );
  }

  static const _focusBorderColor = Color(0xFF4F46E5);
  static const _errorBorderColor = Color(0xFFDC2626);

  InputDecoration _boxedDecoration(
    String hint, {
    EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    Widget? suffixIcon,
  }) {
    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _kBorder),
    );
    final focused = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _focusBorderColor, width: 1.5),
    );
    final errorOutline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _errorBorderColor),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: Get.textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF94A3B8),
        fontSize: 13,
      ),
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: contentPadding,
      border: outline,
      enabledBorder: outline,
      focusedBorder: focused,
      errorBorder: errorOutline,
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _errorBorderColor, width: 1.5),
      ),
      suffixIcon: suffixIcon,
      errorStyle: Get.textTheme.bodySmall?.copyWith(
        color: _errorBorderColor,
        fontSize: 12,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    FormFieldValidator<String> validator, {
    TextInputType? keyboardType,
  }) {
    return _fieldWrapper(
      label,
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: _boxedDecoration(hint),
        style: Get.textTheme.bodyMedium?.copyWith(
          color: _kTextDark,
          fontSize: 13,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildMultilineField(
    String label,
    String hint,
    TextEditingController controller,
    FormFieldValidator<String> validator,
  ) {
    return _fieldWrapper(
      label,
      TextFormField(
        controller: controller,
        minLines: 3,
        maxLines: 5,
        textAlignVertical: TextAlignVertical.top,
        decoration: _boxedDecoration(
          hint,
          contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        ),
        style: Get.textTheme.bodyMedium?.copyWith(
          color: _kTextDark,
          fontSize: 13,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    bool visible,
    VoidCallback onToggleVisibility,
    FormFieldValidator<String> validator,
  ) {
    return _fieldWrapper(
      'Password',
      TextFormField(
        controller: controller,
        obscureText: !visible,
        decoration: _boxedDecoration('Enter password').copyWith(
          suffixIcon: IconButton(
            onPressed: onToggleVisibility,
            icon: Icon(
              visible ? Icons.visibility_off : Icons.visibility,
              color: _kTextMuted,
              size: 20,
            ),
          ),
        ),
        style: Get.textTheme.bodyMedium?.copyWith(
          color: _kTextDark,
          fontSize: 13,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildFooter(AdminTenantUserController c) {
    return Container(
      decoration: const BoxDecoration(
        color: _kBgFooter,
        border: Border(top: BorderSide(color: _kBorder)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 16,
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: c.isSubmitting.value ? null : c.resetForm,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF475569),
                side: const BorderSide(color: _kBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
              child: const Text(
                'Reset',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            const SizedBox(width: 16),
            PrimaryActionButton(
              label: c.isSubmitting.value
                  ? 'Working…'
                  : 'Create tenant, user & link',
              onPressed: c.isSubmitting.value ? null : () => c.submitOnboard(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Role picker matching [_FilterStyleDropdownField] in [AdminAddBusinessContent].
class _TenantRoleFilterField extends StatefulWidget {
  const _TenantRoleFilterField({required this.controller});

  final AdminTenantUserController controller;

  @override
  State<_TenantRoleFilterField> createState() => _TenantRoleFilterFieldState();
}

class _TenantRoleFilterFieldState extends State<_TenantRoleFilterField> {
  static const _text = Color(0xFF0F172A);

  final GlobalKey _dropdownKey = GlobalKey();

  Future<void> _showMenu(BuildContext context) async {
    final menuWidth = _menuWidth();
    final menuContext = _dropdownKey.currentContext ?? context;
    final result = await showMenu<String>(
      context: menuContext,
      position: _menuPosition(menuContext),
      constraints: BoxConstraints.tightFor(width: menuWidth),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 8,
      items: List.generate(AdminConstants.tenantUserRoles.length, (i) {
        final value = AdminConstants.tenantUserRoles[i];
        final isLast = i == AdminConstants.tenantUserRoles.length - 1;
        return PopupMenuItem<String>(
          value: value,
          child: Container(
            width: menuWidth,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(bottom: BorderSide(color: _kBorder)),
            ),
            child: Text(
              value,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF334155),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        );
      }),
    );
    if (result != null) {
      widget.controller.selectedTenantRole.value = result;
    }
  }

  double _menuWidth() {
    final box = _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) return box.size.width;
    return 169;
  }

  RelativeRect _menuPosition(BuildContext context) {
    final box = _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    final size = MediaQuery.sizeOf(context);
    if (box == null || !box.hasSize) {
      return RelativeRect.fromLTRB(
        24,
        200,
        size.width - 200,
        size.height - 300,
      );
    }
    final pos = box.localToGlobal(Offset.zero);
    final top = pos.dy + box.size.height + 4;
    return RelativeRect.fromLTRB(
      pos.dx,
      top,
      size.width - pos.dx - box.size.width,
      size.height - top,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = widget.controller.selectedTenantRole.value;
      return _fieldWrapper(
        'Role',
        Theme(
          data: popupMenuInteractionTheme(context),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showMenu(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                key: _dropdownKey,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selected,
                      style: Get.textTheme.labelMedium?.copyWith(
                        color: _text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      AppIcons.dropdownDown,
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
