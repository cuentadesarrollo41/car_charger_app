import 'dart:ui';

import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/dialog/dialog_confirmation.dart';
import 'package:project/src/widgets/generic/loaders/progress_bar.dart';
import 'package:project/src/widgets/generic/snack_bar/snack_bar_custom.dart';

abstract class DialogHelper {
  // Method that shows an alert dialog.
  static void showAlertDialog({ required BuildContext context, required String? title, required String? text, required String positiveName, String? negativeName, required dynamic positiveAction, required dynamic negativeAction }) {
    final String auxTitle = title ?? AppLocalizations.of(context)!.translate('error_generic');
    final String auxText = text ?? AppLocalizations.of(context)!.translate('error_generic_text');

    _showBlurredDialog(
      context: context,
      builder: (BuildContext context) => PopScope(
        canPop: false,
        child: DialogConfirmation(
          title: auxTitle,
          texts: [ TextSpan(text: auxText) ],
          hasInput: false,
          inputHint: Strings.emptyString,
          confirmText: positiveName,
          cancelText: negativeName,
          showCancelButton: negativeName != null,
          onConfirmButtonClicked: (String value) => positiveAction(context),
          onCancelButtonClicked: negativeAction != null ? () => negativeAction(context) : null,
        )
      )
    );
  }

  // Method that shows the progressbar alert dialog.
  static void showProgressBarAlertDialog({ required BuildContext context, required Stream stream, Color color = CustomColors.lime }) => _showBlurredDialog(
    context: context,
    builder: (BuildContext context) => PopScope(
      canPop: false,
      child: ProgressBar(
        stream: stream,
        color: color
      )
    )
  );

  // Method that shows a modal bottom sheet.
  static dynamic showModalBottomSheetCustom({ required BuildContext context, required Widget child }) async => showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(Sizes.borderRadius20)
      ),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) => child,
  );

  // Method that shows a snackBar (auto-closing success card at the bottom).
  static Future<void> showSnackBar({ required BuildContext context, required String text, required void Function()? onDismiss }) async {
    BuildContext? snackBarContext;
    bool isOpened = true;

    final Future<void> snackBar = _showBlurredDialog<void>(
      context: context,
      slideFromBottom: true,
      builder: (BuildContext context) {
        snackBarContext = context;

        return SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Dismissible(
              key: ValueKey<String>(text),
              direction: DismissDirection.down,
              resizeDuration: null,
              onDismissed: (DismissDirection direction) {
                Navigator.pop(context);
                onDismiss?.call();
              },
              child: SnackBarCustom(text: text)
            )
          )
        );
      }
    ).then((void _) {
      isOpened = false;
    });

    await Future.delayed(const Duration(milliseconds: Numbers.delaySnackBar));

    if (isOpened && snackBarContext != null && snackBarContext!.mounted) {
      Navigator.pop(snackBarContext!);
    }

    await snackBar;
  }

  // Method that shows a dialog with a blurred background.
  static Future<T?> _showBlurredDialog<T>({ required BuildContext context, required Widget Function(BuildContext context) builder, bool slideFromBottom = false }) => showGeneralDialog<T>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: Numbers.durationDialogAnimation),
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => builder(context),
    transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: Numbers.dialogBlurSigma * animation.value,
        sigmaY: Numbers.dialogBlurSigma * animation.value
      ),
      child: slideFromBottom
        ? SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child
        )
        : FadeTransition(
          opacity: animation,
          child: child
        )
    )
  );
}