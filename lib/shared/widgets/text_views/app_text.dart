import 'package:flutter/material.dart';
import '../../themes/design.dart';
import '../constants/widget_enums.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextCategory category;
  final Color color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextDecoration? decoration;
  final double? height;

  AppText({
    required this.text,
    required this.category,
    this.color = Colors.black, // Default color is white
    this.fontWeight = FontWeight.normal,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.letterSpacing,
    this.wordSpacing,
    this.decoration,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle getTextStyle() {
      TextStyle baseStyle;

      switch (category) {
        case TextCategory.title:
          baseStyle = AppTextStyles.b24;
          break;
        case TextCategory.large:
          baseStyle = AppTextStyles.b16;
          break;
        case TextCategory.normal:
          baseStyle = AppTextStyles.w14;
          break;
        case TextCategory.small:
          baseStyle = AppTextStyles.w12;
          break;
      }

      return baseStyle.copyWith(
        color: color,
        fontWeight: category == TextCategory.title
            ? FontWeight.bold
            : fontWeight ?? baseStyle.fontWeight,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        decoration: decoration,
        height: height,
      );
    }

    return Text(
      text,
      style: getTextStyle(),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
