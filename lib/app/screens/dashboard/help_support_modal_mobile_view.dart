import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authentication/widgets/auth_constants.dart';
import '../authentication/widgets/auth_form_field_section.dart';

class HelpSupportModalMobileView extends StatelessWidget {
  const HelpSupportModalMobileView({
    super.key,
    required this.messageController,
    required this.onCancel,
    required this.onSend,
  });

  final TextEditingController messageController;
  final VoidCallback onCancel;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const Divider(thickness: 1, color: Color(0xFFCBD5E1), height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To resolve any issues or queries, send us your concern by typing down below or contact us at the give phone number.',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF334155),
                        height: 1.4,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AuthFormFieldSection(
                      label: 'Message here',
                      spacingAfterLabel: 8,
                      child: TextField(
                        controller: messageController,
                        maxLines: 4,
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: AuthConstants.textColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'I need help with adding multiple branch.',
                          hintStyle: Get.textTheme.labelMedium?.copyWith(
                            color: AuthConstants.hintColor,
                          ),
                          filled: true,
                          fillColor: AuthConstants.cardBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AuthConstants.borderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AuthConstants.borderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AuthConstants.focusedBorderColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildActions(),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Contact Us:\n+91 87564 56478, +91 95784 12456',
                        textAlign: TextAlign.center,
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF334155),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              'Help & Support',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
                fontSize: 18,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: InkWell(
              onTap: onCancel,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 18, color: Color(0xFF64748B)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: onSend,
          style: FilledButton.styleFrom(
            backgroundColor: AuthConstants.buttonEnabledColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Send'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF334155),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
