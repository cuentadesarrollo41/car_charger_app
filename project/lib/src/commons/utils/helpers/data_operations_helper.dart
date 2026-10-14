import 'package:intl/intl.dart';

// Commons.
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/strings.dart';

abstract class DataOperationsHelper {
  // Method that capitalizes the first element of a string.
  static String capitalize({ required String text }) {
    if (text.isEmpty) {
      return text;
    }

    return '${ text[0].toUpperCase() }${ text.substring(1) }';
  }

  // Method that formats an energy in Wh as kWh with one decimal, according to the language (e.g. "3.742,9 kWh").
  static String formatEnergyKwh({ required int energyWh, required String languageCode }) => '${ NumberFormat('#,##0.0', languageCode).format(energyWh / Numbers.whPerKwh) } ${ Strings.kwhUnit }';
}
