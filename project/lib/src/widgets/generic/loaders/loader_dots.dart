import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';

class LoaderDots extends StatefulWidget {
  final Color color;

  const LoaderDots({
    this.color = CustomColors.redPrimary,
    super.key
  });

  @override
  State<LoaderDots> createState() => _LoaderDotsState();
}

class _LoaderDotsState extends State<LoaderDots> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: Numbers.delaySplash));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FittedBox(
    child: SpinKitThreeBounce(
      color: widget.color,
      size: 25,
      controller: animationController,
    ),
  );
}
