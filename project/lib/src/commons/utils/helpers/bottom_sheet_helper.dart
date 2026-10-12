import 'dart:ui';

import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';

abstract class BottomSheetHelper {
  // Method that shows a custom bottom sheet.
  static Future<void> showModalBottomSheetCustom({ required BuildContext context, required Widget bottomSheet, void Function(Map<String, dynamic> response)? onSuccess, void Function()? onCancel }) async {
    final NavigatorState navigator = Navigator.of(context);

    final Map<String, dynamic>? response = await navigator.push(_BlurredModalBottomSheetRoute<Map<String, dynamic>>(
      builder: (BuildContext context) => bottomSheet,
      capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      modalBarrierColor: Colors.black54,
      backgroundColor: CustomColors.backgroundCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Sizes.borderRadius16)),
        side: BorderSide(color: CustomColors.backgroundLine, width: Sizes.inputBorderSize)
      ),
      constraints: BoxConstraints(maxHeight: ScreenPropertiesModel(context: context).size.height - Sizes.bottomSheetMaxHeight),
      isScrollControlled: true
    ));

    if (response == null) {
      return onCancel?.call();
    }

    onSuccess?.call(response);
  }
}

// Bottom sheet route whose barrier blurs the content behind it.
class _BlurredModalBottomSheetRoute<T> extends ModalBottomSheetRoute<T> {
  _BlurredModalBottomSheetRoute({
    required super.builder,
    required super.isScrollControlled,
    super.capturedThemes,
    super.barrierLabel,
    super.modalBarrierColor,
    super.backgroundColor,
    super.shape,
    super.constraints
  });

  // Method that creates the barrier: the default one, blurred according to the route animation.
  @override
  Widget buildModalBarrier() => AnimatedBuilder(
    animation: animation!,
    builder: (BuildContext context, Widget? child) => BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: Numbers.dialogBlurSigma * animation!.value,
        sigmaY: Numbers.dialogBlurSigma * animation!.value
      ),
      child: child
    ),
    child: super.buildModalBarrier()
  );
}
