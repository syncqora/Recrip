import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsMobileView extends StatelessWidget {
  const SettingsMobileView({super.key, required this.settingItems});

  final List<String> settingItems;

  static const _textDark = Color(0xFF333333);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < settingItems.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1,
                thickness: 1,
                color: _border,
              ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: const BoxDecoration(
                          color: _textMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          settingItems[i],
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: _textDark,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: _textMuted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
