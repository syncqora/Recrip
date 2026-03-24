import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/locale/locale_keys.dart';
import '../../themes/design.dart';
import '../constants/button_styles.dart';
import '../constants/widget_enums.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final AppButtonType appButtonType;
  final bool isEnabled;
  final Color? buttonColor;
  final Color? borderColor;
  final IconData? icon;
  final double? iconSize;
  final Function()? onTap;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final double? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    required this.appButtonType,
    required this.onTap,
    this.isEnabled = true,
    this.icon,
    this.buttonColor,
    this.borderColor,
    this.padding,
    this.textStyle,
    this.iconSize,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text!.replaceAll(" ", "_"),
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: _buildButton(),
      ),
    );
  }

  Widget _buildButton() {
    switch (appButtonType) {
      case AppButtonType.goBack:
        return _goBackButton();
      case AppButtonType.loginCreateAccount:
        return _loginCreateButton();
      case AppButtonType.terminalDataRefresh:
        return _terminalDataRefreshButton();
      case AppButtonType.newsFeedsLockIcon:
        return _newsFeedsLockIcon();
      case AppButtonType.roundedCorner:
        return _roundedCorner();
      default:
        return _defaultButton();
    }
  }

  Widget _defaultButton() {
    return Container(
      padding: padding ?? AppButtonStyles.getPadding(appButtonType),
      decoration: AppButtonStyles.getButtonDecoration(
        buttonColor,
        borderColor,
        isEnabled,
        borderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: iconSize ?? 13,
              color: Colors.white,
            ).paddingOnly(right: 5),
          if (text != null)
            Text(text!, style: AppButtonStyles.getTextStyle(textStyle)),
        ],
      ),
    );
  }

  Widget _newsFeedsLockIcon() {
    return Container(
      padding: padding ?? AppButtonStyles.getPadding(appButtonType),
      decoration: AppButtonStyles.getButtonDecoration(
        buttonColor,
        borderColor,
        isEnabled,
        borderRadius,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, size: 18.5, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _goBackButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: AppColors.appPrimaryColorLight,
          ),
          child: const Icon(Icons.arrow_back_sharp, color: Colors.white),
        ),
        const SizedBox(width: 4.0),
        if (text != null)
          Text(
            text!,
            style: Get.theme.textTheme.bodyMedium!.copyWith(
              color: AppColors.appPrimaryColorLight,
            ),
          ),
      ],
    );
  }

  Widget _terminalDataRefreshButton() {
    return Container(
      padding: AppButtonStyles.getPadding(appButtonType),
      decoration: BoxDecoration(
        color: AppColors.appPrimaryColorLight,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.refresh.tr,
            style: Get.theme.textTheme.labelMedium!.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4.0),
          const Icon(Icons.refresh, color: Colors.white),
        ],
      ),
    );
  }

  Widget _loginCreateButton() {
    return Container(
      padding: AppButtonStyles.getPadding(appButtonType),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF23a6d5), Color(0xFFe73c7e)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4.0),
        border: AppButtonStyles.getButtonDecoration(
          buttonColor,
          borderColor,
          isEnabled,
          borderRadius,
        ).border,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 13, color: Colors.white),
          if (text != null)
            Text(text!, style: AppButtonStyles.getTextStyle(textStyle)),
        ],
      ),
    );
  }

  Widget _roundedCorner() {
    return Container(
      padding: AppButtonStyles.getPadding(appButtonType),
      decoration: BoxDecoration(
        color: AppColors.appPrimaryColorLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(text!, style: AppButtonStyles.getTextStyle(textStyle)),
    );
  }
}
