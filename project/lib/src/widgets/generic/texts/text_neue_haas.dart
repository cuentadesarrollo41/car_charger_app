import 'package:flutter/material.dart';

class TextNeueHaas extends StatelessWidget {
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

  const TextNeueHaas({
    required this.text,
    required this.fontSize,
    this.color = Colors.black,
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
      fontFamily: 'NeueHaasDisplay',
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
