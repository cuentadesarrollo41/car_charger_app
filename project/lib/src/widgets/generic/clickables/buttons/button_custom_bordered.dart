import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/button_custom.dart';

class ButtonCustomBordered extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color borderColor;
  final Color overlayBorderColor;
  final FaIconData? iconDataLeft;
  final FaIconData? iconDataRight;
  final double iconSize;
  final double horizontalPadding;
  final MainAxisSize mainAxisSize;

  final void Function()? onClicked;

  const ButtonCustomBordered({
    required this.text,
    required this.fontSize,
    this.borderColor = CustomColors.lime,
    this.overlayBorderColor = CustomColors.lime80,
    this.iconDataLeft,
    this.iconDataRight,
    this.iconSize = Sizes.font12,
    this.horizontalPadding = Sizes.margin18,
    this.mainAxisSize = MainAxisSize.max,
    required this.onClicked,
    super.key
  });

  @override
  Widget build(BuildContext context) => ButtonCustom(
    text: text,
    fontSize: fontSize,
    backgroundColor: CustomColors.backgroundGhost,
    overlayColor: CustomColors.backgroundGhost,
    borderColor: borderColor,
    overlayBorderColor: overlayBorderColor,
    iconDataLeft: iconDataLeft,
    iconDataRight: iconDataRight,
    textColor: borderColor,
    overlayTextColor: borderColor,
    iconSize: iconSize,
    mainAxisSize: mainAxisSize,
    horizontalPadding: horizontalPadding,
    onClicked: onClicked
  );
}
