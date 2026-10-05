import 'package:flutter/material.dart';
import 'dart:math';

class GracoStripe extends StatelessWidget {
  final List<Color> colors;
  final List<double> stops;

  const GracoStripe({
    required this.colors,
    required this.stops,
    super.key
  });

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: -58 * pi / 180,
    child: Container(
      width: 420,
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, stops: stops)
      )
    )
  );
}
