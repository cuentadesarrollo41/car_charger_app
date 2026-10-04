abstract class DataOperationsHelper {
  // Method that capitalizes the first element of a string.
  static String capitalize({ required String text }) {
    if (text.isEmpty) {
      return text;
    }

    return '${ text[0].toUpperCase() }${ text.substring(1) }';
  }
}