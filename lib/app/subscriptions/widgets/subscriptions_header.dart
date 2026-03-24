import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'package:saas/shared/widgets/primary_action_button.dart';

/// Title, subtitle, and create CTA for the subscriptions feature.
class SubscriptionsHeader extends StatelessWidget {
  const SubscriptionsHeader({
    super.key,
    required this.isMobile,
    required this.onCreatePlan,
  });

  final bool isMobile;
  final VoidCallback onCreatePlan;

  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.subscriptionsTitle,
                    style:
                        (isMobile
                                ? Get.textTheme.headlineSmall
                                : Get.textTheme.headlineMedium)
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _textDark,
                            ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.subscriptionsSubtitle,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: _textMuted,
                      fontSize: isMobile ? 13 : 14,
                    ),
                  ),
                ],
              ),
            ),
            if (!isMobile)
              PrimaryActionButton(
                label: AppStrings.createPlanLabel,
                onPressed: onCreatePlan,
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryActionButton(
              label: AppStrings.createPlanLabel,
              onPressed: onCreatePlan,
              useFixedSize: false,
            ),
          ),
        ],
      ],
    );
  }
}
