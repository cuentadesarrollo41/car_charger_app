import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';

abstract class ScreenHelper {
  // Method that checks if the screen is phone.
  static bool screenIsPhone({ required BuildContext context }) {
    return MediaQuery.of(context).size.width <= Sizes.maxWidthScreenPhone;
  }

  // Method that checks if the screen is tablet.
  static bool screenIsTablet({ required BuildContext context }) {
    return MediaQuery.of(context).size.width > Sizes.maxWidthScreenPhone && MediaQuery.of(context).size.width <= Sizes.maxWidthTablet;
  }

  // Method that checks if the screen is monitor.
  static bool screenIsMonitor({ required BuildContext context }) {
    return MediaQuery.of(context).size.width > Sizes.maxWidthTablet;
  }

  // Method that checks if the screen has hamburger menu.
  static bool screenHasHamburgerMenu({ required BuildContext context }) {
    return MediaQuery.of(context).size.width <= Sizes.hamburgerMenuScreenWidth;
  }
}