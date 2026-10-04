import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HtmlWidgetCustom extends StatelessWidget {
  final String html;
  final double fontSize;
  final Color color;

  const HtmlWidgetCustom({
    required this.html,
    required this.fontSize,
    this.color = Colors.black,
    super.key
  });

  @override
  Widget build(BuildContext context) => HtmlWidget(
    html,
    textStyle: TextStyle(
      fontFamily: 'NeueHaasDisplay',
      fontSize: fontSize,
      color: color,
    ),
  );
}
