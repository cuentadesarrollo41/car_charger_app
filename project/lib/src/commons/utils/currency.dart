import 'package:intl/intl.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';

class Currency {
  static const String euro = '€';

  // Get formatted price.
  static String getFormattedPrice(int priceInCents, { String currency = euro }) {
    return '${ (priceInCents / 100.00).toStringAsFixed(2) }$currency';
  }

  // Method that gets the formatted amount.
  static String getFormattedAmountWithCode(double amount, String language, String currencyCode) {
    NumberFormat currencyFormat = NumberFormat.currency(locale: language, name: currencyCode.toUpperCase(), symbol: Strings.emptyString);

    // Check if symbol goes before or after the number.
    return '${ currencyFormat.format(amount) }${ currencyCode.toUpperCase() }';
  }
}