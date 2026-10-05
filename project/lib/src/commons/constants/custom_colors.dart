import 'package:flutter/material.dart';

// Commons
import 'package:project/src/commons/constants/strings.dart';

class CustomColors {
  static const Color black = Color.fromRGBO(16, 18, 20, 1.0);                   // #101214

  static const Color backgroundCard = Color.fromRGBO(28, 32, 35, 1.0);          // #1C2023
  static const Color backgroundGhost = Color.fromRGBO(255, 255, 255, 0.06);     // #FFFFFF0F
  static const Color backgroundInput = Color.fromRGBO(40, 46, 47, 1.0);         // #202526
  static const Color backgroundLine = Color.fromRGBO(255, 255, 255, 0.11);      // #FFFFFF1C
  static const Color backgroundProgressBar = Color.fromRGBO(28, 32, 35, 1.0);   // #1C2023

  static const Color lime = Color.fromRGBO(168, 255, 0, 1.0);                   // #A8FF00
  static const Color lime36 = Color.fromRGBO(168, 255, 0, 0.36);                // #A8FF00 -> 36%
  static const Color lime78 = Color.fromRGBO(168, 255, 0, 0.78);                // #A8FF00 -> 78%
  static const Color lime80 = Color.fromRGBO(168, 255, 0, 0.8);                 // #A8FF00 -> 80%
  static const Color limeDark = Color.fromRGBO(122, 204, 0, 1.0);               // #7ACC00

  static const Color orange = Color.fromRGBO(255, 189, 74, 1.0);                // #FFBD4A

  static const Color red = Color.fromRGBO(255, 93, 101, 1.0);                   // #FF5D65
  static const Color red80 = Color.fromRGBO(255, 93, 101, 0.8);                 // #FF5D65 -> 80%
  static const Color redDark = Color.fromRGBO(202, 78, 85, 1.0);                // #CA4E55 -> 80%

  static const Color textPlaceholder = Color.fromRGBO(115, 124, 121, 1.0);      // #737C79
  static const Color textSecondary = Color.fromRGBO(154, 163, 161, 1.0);        // #9AA3A1

  static const Color white80 = Color.fromRGBO(154, 163, 161, 0.8);              // #9AA3A1CC

  // Transform hexadecimal code to color.
  static Color hexCodeToColor(String hexCode) {
    hexCode = hexCode.replaceAll(Strings.hash, Strings.emptyString);

    if (hexCode.length == 6) {
      hexCode = 'FF$hexCode';
    }

    return Color(int.parse('0x$hexCode'));
  }

  // Transform color to hexadecimal color.
  static String colorToHexCode(Color color, { bool includeAlpha = false }) {
    // Scale the float values (0.0 - 1.0) to integers (0 - 255)
    int alpha = (color.a * 255).round();
    int red = (color.r * 255).round();
    int green = (color.g * 255).round();
    int blue = (color.b * 255).round();

    // Convert to hexadecimal and format properly
    String alphaHex = includeAlpha ? alpha.toRadixString(16).padLeft(2, '0') : '';
    String redHex = red.toRadixString(16).padLeft(2, '0');
    String greenHex = green.toRadixString(16).padLeft(2, '0');
    String blueHex = blue.toRadixString(16).padLeft(2, '0');

    return '#$alphaHex$redHex$greenHex$blueHex'.toUpperCase();
  }
}
