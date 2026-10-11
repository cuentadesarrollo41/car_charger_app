import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/ink_well_custom.dart';

class CardCustom extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color color;
  final double borderRadius;
  final Color borderColor;

  final void Function()? onClicked;

  const CardCustom({
    required this.child,
    this.elevation = 0,
    this.color = CustomColors.backgroundCard,
    this.borderRadius = Sizes.borderRadius20,
    this.borderColor = CustomColors.backgroundLine,
    this.onClicked,
    super.key
  });

  @override
  Widget build(BuildContext context) => onClicked == null
    ? _createCard()
    : InkWellCustom(
      onTap: onClicked,
      child: _createCard(),
    );

  // Method that creates the card.
  Widget _createCard() => Card(
    elevation: elevation,
    color: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: BorderSide(
        color: borderColor,
        width: Sizes.defaultBorderSize
      )
    ),
    child: child,
  );
}
