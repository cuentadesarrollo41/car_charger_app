import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import './card_custom.dart';

class CardContainer extends StatelessWidget {
  final double verticalPadding;
  final double horizontalPadding;
  final Widget child;
  final double borderRadius;
  final double elevation;
  final Color color;

  final void Function()? onClicked;

  const CardContainer({
    this.verticalPadding = Sizes.margin20,
    this.horizontalPadding = Sizes.margin20,
    required this.child,
    this.borderRadius = Sizes.borderRadius20,
    this.elevation = Sizes.defaultElevation,
    this.color = Colors.white,
    this.onClicked,
    super.key
  });

  @override
  Widget build(BuildContext context) => CardCustom(
    onClicked: onClicked,
    borderRadius: borderRadius,
    elevation: elevation,
    color: color,
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: child
    ),
  );
}
