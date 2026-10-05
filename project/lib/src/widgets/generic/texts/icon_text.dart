import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class IconText extends StatelessWidget {
  final FaIconData iconData;
  final String text;
  final double iconSize;
  final Color iconColor;
  final double fontSize;
  final Color textColor;
  final TextOverflow textOverflow;
  final FontWeight fontWeight;
  final double spacing;

  const IconText({
    required this.iconData,
    required this.text,
    required this.iconSize,
    this.iconColor = Colors.white,
    required this.fontSize,
    this.textColor = Colors.white,
    this.textOverflow = TextOverflow.ellipsis,
    this.fontWeight = FontWeight.w500,
    this.spacing = Sizes.margin12,
    super.key
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      FaIcon(
        iconData,
        size: iconSize,
        color: iconColor,
      ),
      SizedBox(width: spacing),

      Flexible(
        child: TextInter(
          text: text,
          fontSize: fontSize,
          color: textColor,
          fontWeight: fontWeight,
          overflow: textOverflow,
        ),
      )
    ],
  );
}
