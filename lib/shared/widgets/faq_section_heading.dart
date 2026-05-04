import 'package:flutter/material.dart';

/// "Frequently Asked Questions" with each word's first letter in [leadColor]
/// and the remainder in [restColor] (typically accent vs FAQ question text).
class FaqSectionHeading extends StatelessWidget {
  const FaqSectionHeading({
    super.key,
    required this.leadColor,
    required this.restColor,
    this.textAlign = TextAlign.center,
    this.fontSize = 40,
  });

  final Color leadColor;
  final Color restColor;
  final TextAlign textAlign;
  final double fontSize;

  static const _words = ['Frequently', 'Asked', 'Questions'];

  @override
  Widget build(BuildContext context) {
    final base =
        Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
        ) ??
        TextStyle(fontSize: fontSize, fontWeight: FontWeight.w900);

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: base,
        children: [
          for (var i = 0; i < _words.length; i++) ...[
            if (i > 0)
              TextSpan(
                text: ' ',
                style: base.copyWith(color: restColor),
              ),
            TextSpan(
              text: _words[i].substring(0, 1),
              style: base.copyWith(color: leadColor),
            ),
            TextSpan(
              text: _words[i].substring(1),
              style: base.copyWith(color: restColor),
            ),
          ],
        ],
      ),
    );
  }
}
