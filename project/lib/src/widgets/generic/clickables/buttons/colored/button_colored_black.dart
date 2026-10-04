import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/button_custom.dart';

class ButtonColoredBlack extends StatelessWidget {
  final double height;
  final String text;
  final double fontSize;
  final double? width;
  final MainAxisSize mainAxisSize;
  final String? iconAssetLeft;
  final String? iconAssetRight;
  final FaIconData? iconDataLeft;
  final FaIconData? iconDataRight;
  final double iconSize;

  final void Function()? onClicked;

  const ButtonColoredBlack({
    this.height = Sizes.buttonHeight,
    required this.text,
    required this.fontSize,
    this.width,
    this.mainAxisSize = MainAxisSize.min,
    this.iconAssetLeft,
    this.iconAssetRight,
    this.iconDataLeft,
    this.iconDataRight,
    this.iconSize = Sizes.font12,
    required this.onClicked,
    super.key
  });

  @override
  Widget build(BuildContext context) => ButtonCustom(
    height: height,
    text: text,
    fontSize: fontSize,
    backgroundColor: Colors.black,
    borderColor: CustomColors.blackMenu,
    overlayColor: Colors.black,
    overlayBorderColor: CustomColors.blackMenu,
    mainAxisSize: mainAxisSize,
    iconAssetLeft: iconAssetLeft,
    iconAssetRight: iconAssetRight,
    iconDataLeft: iconDataLeft,
    iconDataRight: iconDataRight,
    iconSize: iconSize,
    onClicked: onClicked
  );
}
