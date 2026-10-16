import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';

class ProgressLineCustom extends StatelessWidget {
  final double value;
  final Color color;
  final Color backgroundColor;
  final double height;

  const ProgressLineCustom({
    required this.value,
    this.color = CustomColors.lime,
    this.backgroundColor = CustomColors.backgroundProgressBar,
    this.height = Sizes.margin4,
    super.key
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    height: height,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(height)
    ),
    child: TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: const Duration(milliseconds: Numbers.delayAnimation),
      curve: Curves.decelerate,
      builder: (BuildContext context, double animatedValue, Widget? child) => FractionallySizedBox(
        widthFactor: animatedValue,
        heightFactor: 1,
        alignment: Alignment.centerLeft,
        child: child
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height)
        )
      )
    )
  );
}
