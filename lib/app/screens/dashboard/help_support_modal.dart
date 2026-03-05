import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/success_toast.dart';
import '../authentication/widgets/auth_constants.dart';
import '../authentication/widgets/auth_form_field_section.dart';
import 'help_support_modal_mobile_view.dart';
import 'help_support_modal_tablet_view.dart';

class HelpSupportModal extends StatefulWidget {
  const HelpSupportModal({super.key});

  @override
  State<HelpSupportModal> createState() => _HelpSupportModalState();
}

class _HelpSupportModalState extends State<HelpSupportModal> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onSendPressed(BuildContext context) {
    SuccessToast.show(
      context,
      title: 'Message Sent Successfully.',
      subtitle: "We'll reach out to you shortly. Thanks!",
      popRoute: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return HelpSupportModalMobileView(
        messageController: _messageController,
        onCancel: () => Navigator.of(context).pop(),
        onSend: () => _onSendPressed(context),
      );
    }

    if (width < 1024) {
      return HelpSupportModalTabletView(
        messageController: _messageController,
        onCancel: () => Navigator.of(context).pop(),
        onSend: () => _onSendPressed(context),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 560),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 20, 32, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To resolve any issues or queries, send us your concern by typing down below or contact us at the give phone number.',
                    style: Get.theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF334155),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AuthFormFieldSection(
                    label: 'Message here',
                    spacingAfterLabel: 8,
                    child: TextField(
                      controller: _messageController,
                      maxLines: 5,
                      style: Get.theme.textTheme.bodySmall?.copyWith(
                        color: AuthConstants.textColor,
                      ),
                      cursorColor: AuthConstants.textColor,
                      decoration: InputDecoration(
                        hintText: 'I need help with adding multiple branch.',
                        hintStyle: Get.theme.textTheme.labelMedium?.copyWith(
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF334155),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: () => _onSendPressed(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: AuthConstants.buttonEnabledColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Send'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: Text(
                      'Contact Us: +91 87564 56478, +91 95784 12456',
                      style: Get.theme.textTheme.bodySmall?.copyWith(
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
          Positioned(
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

