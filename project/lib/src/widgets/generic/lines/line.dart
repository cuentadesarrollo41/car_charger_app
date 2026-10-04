import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final double verticalMargin;

  const Line({
    required this.height,
    required this.width,
    required this.color,
    required this.verticalMargin,
    super.key
  });

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    color: color,
    margin: EdgeInsets.symmetric(vertical: verticalMargin)
  );
}
