import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_strings.dart';

class SendRemindersButton extends StatelessWidget {
  const SendRemindersButton({
    super.key,
    required this.onTap,
    this.textColor = const Color(0xFF4F46E5),
    this.backgroundColor = const Color(0xFFEEEDFB),
    this.borderColor = const Color(0xFFC7D2FE),
  });

  final VoidCallback onTap;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            AppStrings.sendRemindersNow,
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
