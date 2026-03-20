import 'package:flutter/material.dart';

/// Reusable success toast shown as an overlay (e.g. after form submit).
/// Use [SuccessToast.show] to display it; optionally pops the current route first (for dialogs).
class SuccessToast {
  SuccessToast._();

  static const _green = Color(0xFF22C55E);
  static const _durationSeconds = 3;

  /// Shows a success toast with a green check icon and message(s).
  /// [title] is the main line (e.g. "Plan Created Successfully!").
  /// [subtitle] is optional (e.g. "We'll reach out to you shortly. Thanks!").
  /// Set [popRoute] to true when called from a dialog so the dialog is closed before showing the toast.
  static void show(
    BuildContext context, {
    required String title,
    String? subtitle,
    bool popRoute = false,
  }) {
    final overlayState = Overlay.of(context);
    if (popRoute) {
      Navigator.of(context).pop();
    }
    _insert(overlayState, title: title, subtitle: subtitle);
  }

  /// Shows a success toast using an [OverlayState] (e.g. after you've already popped a dialog).
  /// [iconColor] defaults to green; use red (e.g. [iconColorRed]) for destructive actions like delete.
  static void showWithOverlay(
    OverlayState overlayState, {
    required String title,
    String? subtitle,
    Color? iconColor,
  }) {
    _insert(
      overlayState,
      title: title,
      subtitle: subtitle,
      iconColor: iconColor,
    );
  }

  /// Red color for destructive toasts (e.g. "Plan Deleted", "Removed").
  static const iconColorRed = Color(0xFFDC2626);

  /// Shows a "Removed [userName]" toast with a red circle and checkmark.
  /// Call after closing dialogs; pass the [OverlayState] from context before popping.
  static void showRemoved(OverlayState overlayState, String userName) {
    _insert(overlayState, title: 'Removed $userName', iconColor: iconColorRed);
  }

  static void _insert(
    OverlayState overlayState, {
    required String title,
    String? subtitle,
    Color? iconColor,
  }) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _SuccessToastContent(
        title: title,
        subtitle: subtitle,
        iconColor: iconColor ?? _green,
        onDismiss: () {
          entry.remove();
        },
      ),
    );
    overlayState.insert(entry);
    Future.delayed(const Duration(seconds: _durationSeconds), () {
      if (entry.mounted) entry.remove();
    });
  }
}

class _SuccessToastContent extends StatelessWidget {
  const _SuccessToastContent({
    required this.title,
    this.subtitle,
    required this.iconColor,
    required this.onDismiss,
  });

  final String title;
  final String? subtitle;
  final Color iconColor;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      top: 48,
      left: 24,
      right: 24,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onDismiss,
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  subtitle != null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF334155),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
