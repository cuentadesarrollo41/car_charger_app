import 'dart:math' as math;

import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';

class RadarCustom extends StatefulWidget {
  final double size;

  const RadarCustom({
    required this.size,
    super.key
  });

  @override
  State<RadarCustom> createState() => _RadarCustomState();
}

class _RadarCustomState extends State<RadarCustom> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: Numbers.durationRadarAnimation)
    )..repeat();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: widget.size,
    height: widget.size,
    child: AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) => CustomPaint(
        painter: _RadarPainter(angle: animationController.value * 2 * math.pi)
      )
    )
  );
}

class _RadarPainter extends CustomPainter {
  final double angle;

  _RadarPainter({ required this.angle });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    final Paint ringPaint = Paint()
      ..color = CustomColors.lime36
      ..style = PaintingStyle.stroke
      ..strokeWidth = Sizes.defaultBorderSize;

    canvas.drawCircle(center, radius, ringPaint);
    canvas.drawCircle(center, radius * 2 / 3, ringPaint);
    canvas.drawCircle(center, radius / 3, ringPaint);

    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint sweepPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi / 2,
        colors: [ CustomColors.lime36.withValues(alpha: 0), CustomColors.lime36 ]
      ).createShader(rect);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle - math.pi / 2);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawArc(rect, 0, math.pi / 2, true, sweepPaint);
    canvas.restore();

    final Paint dotPaint = Paint()..color = CustomColors.lime;

    canvas.drawCircle(center, Sizes.margin8, dotPaint);
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) => oldDelegate.angle != angle;
}
