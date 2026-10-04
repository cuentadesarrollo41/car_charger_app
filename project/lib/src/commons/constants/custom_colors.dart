import 'package:flutter/material.dart';

// Commons
import 'package:project/src/commons/constants/strings.dart';

class CustomColors {
  static const Color blackMenu = Color.fromRGBO(0, 0, 0, 0.6);                    // #00000099

  static const Color gray = Color.fromRGBO(106, 122, 137, 1.0);                   // #edf2f8cf
  static const Color grayBackground = Color.fromRGBO(249, 249, 249, 1.0);         // #f9f9f9
  static const Color grayBackgroundCard = Color.fromRGBO(239, 239, 239, 1.0);     // #EFEFEFFF
  static const Color grayBlue = Color.fromRGBO(144, 159, 172, 1.0);               // #909fac
  static const Color grayHomeItem = Color.fromRGBO(102, 102, 102, 1.0);           // ##666666
  static const Color grayBorder = Color.fromRGBO(239, 239, 239, 1.0);             // #e9e9e9
  static const Color grayLight = Color.fromRGBO(235, 238, 240, 1.0);              // #ebeef0
  static const Color grayLightest = Color.fromRGBO(243, 245, 246, 1.0);           // #F3F5F6

  static const Color green = Color.fromRGBO(13, 107, 44, 1.0);                    // #F3F5F6
  static const Color greenLight = Color.fromRGBO(222, 240, 229, 1.0);             // #F3F5F6

  static const Color redPrimary = Color.fromRGBO(253, 100, 75, 1.0);              // #FD644BFF
  static const Color redPrimary80 = Color.fromRGBO(253, 100, 75, 0.8);            // #FD644BFF -> 80%
  static const Color redSecondary = Color.fromRGBO(254, 217, 211, 1.0);           // #FED9D3FF
  static const Color redSecondary80 = Color.fromRGBO(254, 217, 211, 0.8);         // #FED9D3FF
  static const Color redContainer = Color.fromRGBO(254, 217, 211, 0.95);          // #FED9D3F2 -> 95%
  static const Color redHoverList = Color.fromRGBO(255, 237, 235, 1.0);           // #FDD5CEFF%
  static const Color redWhite = Color.fromRGBO(255, 230, 230, 1.0);               // #ffe6e6

  static const Color backgroundBottomSheet = Color.fromRGBO(255, 255, 255, 0.44); // FFFFFF70
  static const Color subtitleGray = Color.fromRGBO(155, 155, 155, 1.0);           // 666666FF

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
