import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/utils.dart';

class ScreenPropertiesModel {
  bool isPhone;
  bool isTablet;
  bool isMonitor;
  bool hasHamburgerMenu;

  double fontExtraSmall;
  double fontSmall;
  double fontText;
  double fontSubtitle;
  double fontTitle;
  double fontBigTitle;
  double fontExtraTitle;

  double paddingCardHorizontal;
  double paddingCardVertical;

  Size size;

  ScreenPropertiesModel({required BuildContext context})
    : isPhone = false,
      isTablet = false,
      isMonitor = false,
      hasHamburgerMenu = false,
      fontExtraSmall = 0,
      fontSmall = 0,
      fontText = 0,
      fontSubtitle = 0,
      fontTitle = 0,
      fontBigTitle = 0,
      fontExtraTitle = 0,
      paddingCardHorizontal = 0,
      paddingCardVertical = 0,
      size = const Size(0, 0) {
    isPhone = Utils.screenIsPhone(context: context);
    isTablet = Utils.screenIsTablet(context: context);
    isMonitor = Utils.screenIsMonitor(context: context);
    hasHamburgerMenu = Utils.screenHasHamburgerMenu(context: context);
    fontExtraSmall = isMonitor ? Sizes.font15 : Sizes.font14;
    fontSmall = isMonitor ? Sizes.font16 : Sizes.font15;
    fontText = isMonitor ? Sizes.font19 : Sizes.font17;
    fontSubtitle = isMonitor ? Sizes.font22 : Sizes.font20;
    fontTitle = isMonitor ? Sizes.font24 : Sizes.font22;
    fontBigTitle = isMonitor ? Sizes.font28 : Sizes.font24;
    fontExtraTitle = isMonitor ? Sizes.font32 : Sizes.font28;
    paddingCardHorizontal = isPhone ? Sizes.margin24 : Sizes.margin36;
    paddingCardVertical = isPhone ? Sizes.margin36 : Sizes.margin40;
    size = MediaQuery.of(context).size;
  }
}
