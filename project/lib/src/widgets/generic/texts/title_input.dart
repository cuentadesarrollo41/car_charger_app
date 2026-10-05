import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/strings.dart';

class TitleInput extends StatelessWidget {
  final String title;
  final String extraTitle;
  final bool isMandatory;
  final FontWeight fontWeight;
  final double fontSize;
  final TextAlign textAlign;

  const TitleInput({
    required this.title,
    required this.extraTitle,
    required this.isMandatory,
    required this.fontWeight,
    required this.fontSize,
    this.textAlign = TextAlign.start,
    super.key
  });

  @override
  Widget build(BuildContext context) => RichText(
    textAlign: textAlign,
    text: TextSpan(
      style: TextStyle(
        fontFamily: Strings.fontFamily,
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      children: [
        TextSpan(
          text: title
        ),

        TextSpan(
          text: extraTitle.isEmpty ? Strings.emptyString : ' $extraTitle',
          style: const TextStyle(
            fontWeight: FontWeight.normal
          )
        ),

        TextSpan(
          text: isMandatory ? ' ${ Strings.asterisk }' : Strings.emptyString,
          style: const TextStyle(
            color: CustomColors.lime
          )
        ),
      ]
    )
  );
}
