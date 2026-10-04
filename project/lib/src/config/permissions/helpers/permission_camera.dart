import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Config.
import 'package:project/src/config/index.dart';

// Commons.
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

abstract class PermissionCamera {
  static Future<bool> check({ required BuildContext context }) async {
    List<Permission> permissionsToCheck = [ Permission.camera ];
    PermissionStatus permissionStatus = await Permission.camera.status;

    if (!context.mounted) {
      return false;
    }

    if (permissionStatus.isDenied) {
      Utils.showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.translate('information'),
        text: AppLocalizations.of(context)!.translate('error_generic_camera_permission'),
        positiveName: AppLocalizations.of(context)!.translate('continue'),
        negativeName: null,
        positiveAction: (BuildContext auxContext) => _onContinueButtonClicked(context, permissionsToCheck),
        negativeAction: null
      );

      return false;
    } else if (permissionStatus != PermissionStatus.granted) {
      return await PermissionsService.requestPermissions(permissionsToCheck);
    }

    return true;
  }

  // Method that is called when the user clicks the continue button.
  static void _onContinueButtonClicked(BuildContext context, List<Permission> permissionsToCheck) {
    Navigator.pop(context);
    PermissionsService.requestPermissions(permissionsToCheck);
  }
}