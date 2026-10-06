import 'package:flutter/material.dart';

abstract class FocusHelper {
  // Method that disposes the focus nodes.
  static void disposeFocusNodes({ required Iterable<FocusNode> focusNodes }) {
    for (final FocusNode focusNode in focusNodes) {
      focusNode.dispose();
    }
  }

  // Method that removes the focus from the current input (hides the keyboard).
  static void unfocus() => FocusManager.instance.primaryFocus?.unfocus();
}