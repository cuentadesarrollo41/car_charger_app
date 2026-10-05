import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';

class TextInter extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final double height;

  const TextInter({
    required this.text,
    required this.fontSize,
    this.color = Colors.white,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.w500,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textDecoration,
    this.height = kTextHeightNone,
    super.key
  });

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontFamily: Strings.fontFamily,
      color: color,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      decoration: textDecoration,
      height: height
    ),
    maxLines: maxLines,
    overflow: overflow,
    textAlign: textAlign,
  );
}
