import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/screens/authentication/widgets/auth_constants.dart';

/// Plan options for the dropdown.
const List<String> kPlanOptions = ['Monthly', 'Quarterly', 'Yearly'];

/// A plan selector dropdown that matches the reference UI: white rounded menu
/// with soft shadow, no border, generous padding and light gray separators.
class PlanDropdown extends StatelessWidget {
  const PlanDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.hint = 'Choose a Plan',
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final String hint;

  static const double _menuBorderRadius = 12;
  static const double _menuElevation = 8;
  static const EdgeInsets _itemPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );

  Future<void> _showPlanMenu(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final pos = box.localToGlobal(Offset.zero);
    final size = box.size;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        pos.dx,
        pos.dy + size.height + 4,
        pos.dx + size.width,
        pos.dy + size.height + 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_menuBorderRadius),
      ),
      color: Colors.white,
      elevation: _menuElevation,
      items: [
        _buildMenuItem('Monthly'),
        const PopupMenuDivider(height: 1),
        _buildMenuItem('Quarterly'),
        const PopupMenuDivider(height: 1),
        _buildMenuItem('Yearly'),
      ],
    );
    if (selected != null) onChanged(selected);
  }

  PopupMenuItem<String> _buildMenuItem(String plan) {
    return PopupMenuItem<String>(
      value: plan,
      padding: _itemPadding,
      child: Text(
        plan,
        style: Get.theme.textTheme.bodyMedium?.copyWith(
          color: AuthConstants.labelColor,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPlanMenu(context),
      borderRadius: BorderRadius.circular(AuthConstants.fieldBorderRadius),
      child: Container(
        height: AuthConstants.fieldHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AuthConstants.fieldFillColor,
          borderRadius: BorderRadius.circular(AuthConstants.fieldBorderRadius),
          border: Border.all(color: AuthConstants.borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: Get.theme.textTheme.labelMedium?.copyWith(
                  color: value != null
                      ? AuthConstants.labelColor
                      : AuthConstants.hintColor,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: AuthConstants.hintColor,
            ),
          ],
        ),
      ),
    );
  }
}
