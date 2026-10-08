import 'package:flutter/material.dart';
import 'package:project/src/commons/constants/custom_colors.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';

abstract class BottomSheetHelper {
  // Method that shows a custom bottom sheet.
  static Future<void> showModalBottomSheetCustom({ required BuildContext context, required Widget bottomSheet, void Function(Map<String, dynamic> response)? onSuccess, void Function()? onCancel }) async {
    final Map<String, dynamic>? response = await showModalBottomSheet(
      context: context,
      backgroundColor: CustomColors.backgroundCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Sizes.borderRadius20)),
        side: BorderSide(color: CustomColors.backgroundLine, width: Sizes.inputBorderSize)
      ),
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