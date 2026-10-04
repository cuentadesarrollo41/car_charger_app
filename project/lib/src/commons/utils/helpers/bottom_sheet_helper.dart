import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';

abstract class BottomSheetHelper {
  // Method that shows a custom bottom sheet.
  static Future<void> showCustomModalBottomSheet({ required BuildContext context, required Widget bottomSheet, void Function(Map<String, dynamic> response)? onSuccess, void Function()? onCancel }) async {
    final Map<String, dynamic>? response = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Sizes.borderRadius20))),
      constraints: BoxConstraints(maxHeight: ScreenPropertiesModel(context: context).size.height - Sizes.bottomSheetMaxHeight),
      isScrollControlled: true,
      builder: (BuildContext context) => bottomSheet
    );

    if (response == null) {
      return onCancel?.call();
    }

    onSuccess?.call(response);
  }
}