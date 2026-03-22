import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/constants/app_strings.dart';

import '../../app/screens/authentication/widgets/app_constants.dart';
import '../themes/popup_menu_interaction_theme.dart';

const List<String> kReportPeriodOptions = [
  AppStrings.thisMonthLabel,
  AppStrings.lastMonthLabel,
  AppStrings.lastQuarterLabel,
];

class ReportPeriodDropdown extends StatefulWidget {
  const ReportPeriodDropdown({
    super.key,
    this.initialValue = AppStrings.thisMonthLabel,
    this.width = 145,
    this.height = 44,
    this.onChanged,
  });

  final String initialValue;
  final double width;
  final double height;
  final ValueChanged<String>? onChanged;

  @override
  State<ReportPeriodDropdown> createState() => _ReportPeriodDropdownState();
}

class _ReportPeriodDropdownState extends State<ReportPeriodDropdown> {
  static const double _menuBorderRadius = 12;
  static const double _menuElevation = 8;
  static const EdgeInsets _itemPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );

  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  TextStyle? _dropdownTextStyle() {
    return Get.theme.textTheme.labelMedium?.copyWith(
      color: const Color(0xFF0F172A),
      fontSize: widget.height <= 40 ? 12 : 13,
      fontWeight: FontWeight.w600,
      height: 1,
    );
  }

  Future<void> _showMenu(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final overlayState = Overlay.of(context);
    final overlayRender = overlayState.context.findRenderObject() as RenderBox?;
    if (overlayRender == null) return;

    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlayRender);
    final size = box.size;
    final overlaySize = overlayRender.size;
    const gap = 4.0;

    final overlayRect = Offset.zero & overlaySize;
    final anchorLeft = topLeft.dx.clamp(0.0, overlaySize.width);
    final anchorTop = (topLeft.dy + size.height + gap).clamp(
      0.0,
      overlaySize.height,
    );
    final anchorWidth = size.width.clamp(
      1.0,
      (overlaySize.width - anchorLeft).clamp(1.0, overlaySize.width),
    );
    final anchorBelow = Rect.fromLTWH(anchorLeft, anchorTop, anchorWidth, 1);
    final position = RelativeRect.fromRect(anchorBelow, overlayRect);

    final selected = await showMenu<String>(
      context: context,
      position: position,
      constraints: BoxConstraints.tightFor(width: size.width),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_menuBorderRadius),
      ),
      color: Colors.white,
      elevation: _menuElevation,
      items: [
        _buildMenuItem(AppStrings.thisMonthLabel),
        const PopupMenuDivider(height: 1),
        _buildMenuItem(AppStrings.lastMonthLabel),
        const PopupMenuDivider(height: 1),
        _buildMenuItem(AppStrings.lastQuarterLabel),
      ],
    );

    if (selected != null) {
      setState(() => _selectedValue = selected);
      widget.onChanged?.call(selected);
    }
  }

  PopupMenuItem<String> _buildMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      height: 52,
      padding: _itemPadding,
      child: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        child: Text(value, style: _dropdownTextStyle()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: popupMenuInteractionTheme(context),
      child: Builder(
        builder: (menuContext) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () => _showMenu(menuContext),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppConstants.borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_selectedValue, style: _dropdownTextStyle()),
                      SvgPicture.asset(
                        AppIcons.dropdownDown,
                        width: widget.height <= 40 ? 20 : 24,
                        height: widget.height <= 40 ? 20 : 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
