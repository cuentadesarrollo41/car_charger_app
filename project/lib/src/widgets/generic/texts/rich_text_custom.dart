import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/strings.dart';

class RichTextCustom extends StatelessWidget {
  final double fontSize;
  final Color color;
  final Color backgroundColor;
  final TextAlign? textAlign;
  final FontStyle fontStyle;

  final List<TextSpan> children;

  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double marginBottom;

  const RichTextCustom({
    required this.fontSize,
    this.color = Colors.white,
    this.backgroundColor = CustomColors.textSecondary,
    this.textAlign,
    this.fontStyle = FontStyle.normal,
    required this.children,
    this.marginLeft = 0,
    this.marginRight = 0,
    this.marginTop = 0,
    this.marginBottom = 0,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: EdgeInsets.only(
        left: marginLeft,
        right: marginRight,
        top: marginTop,
        bottom: marginBottom,
      ),
      child: Text.rich(
        textAlign: textAlign,
        TextSpan(
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontFamily: Strings.fontFamily,
            fontStyle: fontStyle,
          ),
          children: children
        )
      ),
    );
  }
}
