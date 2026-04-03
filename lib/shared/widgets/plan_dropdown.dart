import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/screens/authentication/widgets/app_constants.dart';
import '../themes/popup_menu_interaction_theme.dart';

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
    this.fillColor = AppConstants.fieldFillColor,
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final String hint;
  final Color fillColor;

  static const double _menuBorderRadius = 12;
  static const double _menuElevation = 8;
  static const EdgeInsets _itemPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );

  TextStyle? _dropdownTextStyle(Color color) {
    return Get.theme.textTheme.labelMedium?.copyWith(
      color: color,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1,
    );
  }

  Future<void> _showPlanMenu(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final overlayState = Overlay.of(context);
    final overlayRender = overlayState.context.findRenderObject() as RenderBox?;
    if (overlayRender == null) return;

    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlayRender);
    final size = box.size;
    final oSize = overlayRender.size;
    const gap = 4.0;

    final overlayRect = Offset.zero & oSize;
    final anchorLeft = topLeft.dx.clamp(0.0, oSize.width);
    final anchorTop = (topLeft.dy + size.height + gap).clamp(0.0, oSize.height);
    final anchorWidth = size.width.clamp(
      1.0,
      (oSize.width - anchorLeft).clamp(1.0, oSize.width),
    );
    final anchorBelow = Rect.fromLTWH(anchorLeft, anchorTop, anchorWidth, 1);
    final position = RelativeRect.fromRect(anchorBelow, overlayRect);

    final selected = await showMenu<String>(
      context: context,
      position: position,
      constraints: BoxConstraints(minWidth: size.width, maxWidth: size.width),
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
      height: 52,
      padding: _itemPadding,
      child: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        child: Text(plan, style: _dropdownTextStyle(const Color(0xFF64748B))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: popupMenuInteractionTheme(context),
      child: Builder(
        builder: (menuContext) {
          final borderRadius = BorderRadius.circular(
            AppConstants.fieldBorderRadius,
          );
          return Material(
            color: fillColor,
            borderRadius: borderRadius,
            child: InkWell(
              onTap: () => _showPlanMenu(menuContext),
              hoverColor: AppConstants.lightGrayFillColor,
              borderRadius: borderRadius,
              child: Ink(
                height: AppConstants.fieldHeight,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(color: AppConstants.borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value ?? hint,
                        style: _dropdownTextStyle(
                          value != null
                              ? AppConstants.textColor
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppConstants.hintColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
