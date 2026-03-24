import 'package:flutter/material.dart';

/// Wraps content in a white card that lifts slightly on pointer hover (web / desktop).
/// Uses brand [accentColor] for border + glow on hover.
class HoverElevatedCard extends StatefulWidget {
  const HoverElevatedCard({
    super.key,
    required this.child,
    required this.accentColor,
    this.borderRadius = 12,
    this.hoverScale = 1.018,
  });

  final Widget child;
  final Color accentColor;
  final double borderRadius;
  final double hoverScale;

  @override
  State<HoverElevatedCard> createState() => _HoverElevatedCardState();
}

class _HoverElevatedCardState extends State<HoverElevatedCard> {
  bool _hover = false;

  static const _duration = Duration(milliseconds: 220);
  static const _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedScale(
        scale: _hover ? widget.hoverScale : 1.0,
        duration: _duration,
        curve: _curve,
        child: AnimatedContainer(
          duration: _duration,
          curve: _curve,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _hover
                  ? widget.accentColor.withValues(alpha: 0.22)
                  : const Color(0xFFE5E7EB).withValues(alpha: 0.65),
              width: 1,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.14),
                      blurRadius: 28,
                      spreadRadius: -4,
                      offset: const Offset(0, 14),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
