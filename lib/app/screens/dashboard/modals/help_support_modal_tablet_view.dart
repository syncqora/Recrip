import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/app_close_button.dart';
import '../../authentication/widgets/app_constants.dart';
import '../../authentication/widgets/auth_form_field_section.dart';

class HelpSupportModalTabletView extends StatelessWidget {
  const HelpSupportModalTabletView({
    super.key,
    required this.messageController,
    required this.isSendEnabled,
    required this.onCancel,
    required this.onSend,
  });

  final TextEditingController messageController;
  final bool isSendEnabled;
  final VoidCallback onCancel;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const Divider(thickness: 1, color: Color(0xFFCBD5E1), height: 1),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To resolve any issues or queries, send us your concern by typing down below or contact us at the give phone number.',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF334155),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AuthFormFieldSection(
                    label: 'Message here',
                    spacingAfterLabel: 8,
                    child: TextField(
                      controller: messageController,
                      maxLines: 5,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppConstants.textColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'I need help with adding multiple branch.',
                        hintStyle: Get.textTheme.labelMedium?.copyWith(
                          color: AppConstants.hintColor,
                        ),
                        filled: true,
                        fillColor: AppConstants.cardBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppConstants.borderColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppConstants.borderColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppConstants.focusedBorderColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildActions(),
                  const SizedBox(height: 28),
                  Center(
                    child: Text(
                      'Contact Us: +91 87564 56478, +91 95784 12456',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF334155),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 16, 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              'Help & Support',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
                fontSize: 20,
              ),
            ),
          ),
          Positioned(right: 0, child: AppCloseButton(onPressed: onCancel)),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF334155),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: isSendEnabled ? onSend : null,
          style: FilledButton.styleFrom(
            backgroundColor: AppConstants.buttonEnabledColor,
            disabledBackgroundColor: AppConstants.buttonDisabledColor,
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Send'),
        ),
      ],
    );
  }
}
