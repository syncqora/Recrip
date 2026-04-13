import 'package:flutter/material.dart';

class LandingSectionSkeleton extends StatefulWidget {
  const LandingSectionSkeleton({
    super.key,
    required this.padding,
    this.blockCount = 3,
    this.includeWideBlock = false,
  });

  final double padding;
  final int blockCount;
  final bool includeWideBlock;

  @override
  State<LandingSectionSkeleton> createState() => _LandingSectionSkeletonState();
}

class _LandingSectionSkeletonState extends State<LandingSectionSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween<double>(
    begin: 0.55,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Padding(
        padding: EdgeInsets.fromLTRB(widget.padding, 20, widget.padding, 30),
        child: Column(
          children: [
            if (widget.includeWideBlock) ...[
              _SkeletonBlock(
                width: double.infinity,
                height: 170,
                radius: 24,
              ),
              const SizedBox(height: 18),
            ],
            for (var i = 0; i < widget.blockCount; i++) ...[
              _SkeletonBlock(
                width: double.infinity,
                height: 118,
                radius: 20,
              ),
              if (i != widget.blockCount - 1) const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.width,
    required this.height,
    this.radius = 16,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE6EBF7),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFD8DFEF)),
      ),
    );
  }
}
