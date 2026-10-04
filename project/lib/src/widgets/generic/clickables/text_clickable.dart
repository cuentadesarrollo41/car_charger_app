import 'package:flutter/material.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/ink_well_custom.dart';
import 'package:project/src/widgets/generic/texts/text_neue_haas.dart';

class TextClickable extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final TextAlign textAlign;

  final void Function() onClicked;

  const TextClickable({
    required this.text,
    required this.fontSize,
    required this.onClicked,
    this.color = Colors.black,
    this.textAlign = TextAlign.center,
    super.key
  });

  @override
  Widget build(BuildContext context) => InkWellCustom(
    onTap: onClicked,
    child: TextNeueHaas(
      text: text,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
      textAlign: textAlign,
    )
  );
}
