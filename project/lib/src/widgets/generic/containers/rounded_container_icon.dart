import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

class RoundedContainerIcon extends StatelessWidget {
  final double? height;
  final double horizontalPadding;
  final Color? borderColor;
  final FaIconData iconData;
  final double iconSize;

  const RoundedContainerIcon({
    required this.height,
    required this.horizontalPadding,
    this.borderColor = CustomColors.backgroundLine,
    required this.iconData,
    required this.iconSize,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(
        vertical: height == null ? horizontalPadding : 0,
        horizontal: horizontalPadding
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CustomColors.backgroundGhost,
        border: borderColor == null
          ? null
          : Border.all(
            width: Sizes.defaultBorderSize,
            color: borderColor!
          )
      ),
      child: FaIcon(
        iconData,
        size: iconSize,
        color: Colors.white,
      )
    );
  }
}
