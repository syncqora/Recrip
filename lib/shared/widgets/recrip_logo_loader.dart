import 'package:flutter/material.dart';

/// Recrip branded loader used during module/API transitions.
class RecripLogoLoader extends StatefulWidget {
  const RecripLogoLoader({super.key, this.size = 96});

  final double size;

  @override
  State<RecripLogoLoader> createState() => _RecripLogoLoaderState();
}

class _RecripLogoLoaderState extends State<RecripLogoLoader>
    with SingleTickerProviderStateMixin {
  static const String _asset = 'assets/images/recrip-icon-loader.png';

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween<double>(
    begin: 0.5,
    end: 1.0,
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
      child: Image.asset(
        _asset,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        gaplessPlayback: true,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}
