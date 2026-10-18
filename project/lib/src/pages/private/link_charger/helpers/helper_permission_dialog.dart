import 'package:flutter/material.dart';

// Config.
import 'package:project/src/config/index.dart';

// Commons.
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

abstract class HelperPermissionDialog {
  // Method that shows the explanation dialog when a permission has not been granted.
  static void show({ required BuildContext context, required String textKey, required Future<String> Function() requestPermission, required Future<void> Function() onGranted }) => Utils.showAlertDialog(
    context: context,
    title: AppLocalizations.of(context)!.translate('error_permission'),
    text: AppLocalizations.of(context)!.translate(textKey),
    positiveName: AppLocalizations.of(context)!.translate('continue'),
    negativeName: AppLocalizations.of(context)!.translate('cancel'),
    positiveAction: (BuildContext dialogContext) {
      Navigator.pop(dialogContext);
      _onContinueClicked(context, requestPermission, onGranted);
    },
    negativeAction: (BuildContext dialogContext) => Navigator.pop(dialogContext)
  );

  // Method that is called when the user clicks the continue button of the dialog: requests the permission again or opens the app settings.
  static Future<void> _onContinueClicked(BuildContext context, Future<String> Function() requestPermission, Future<void> Function() onGranted) async {
    final String permissionState = await requestPermission();

    if (!context.mounted) {
      return;
    }

    switch (permissionState) {
      case PermissionsStates.granted:
        await onGranted();
        break;
      case PermissionsStates.permanentlyDenied:
        // The user taps the button again after coming back from the settings.
        await PermissionsService.openSettings();
        break;
      // When it is denied, nothing is done, so the explanation dialog is not shown again in a loop.
      default: break;
    }
  }
}
