import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Confirmation dialog shown when deleting a plan.
class DeletePlanConfirmDialog extends StatelessWidget {
  const DeletePlanConfirmDialog({
    super.key,
    required this.onCancel,
    required this.onDelete,
  });

  final VoidCallback onCancel;
  final VoidCallback onDelete;

  static const _dividerColor = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 12, 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'Delete Plan?',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onCancel,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                            border: Border.all(color: _dividerColor, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.close, size: 18, color: Color(0xFF64748B)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: _dividerColor),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure?',
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'You want to delete the plan.',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF334155),
                          side: const BorderSide(color: _dividerColor),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: onDelete,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
