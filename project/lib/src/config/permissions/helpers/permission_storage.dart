import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

// Config.
import 'package:project/src/config/index.dart';

// Commons.
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

abstract class PermissionStorage {
  static Future<bool> check({ required BuildContext context }) async {
    AndroidDeviceInfo? androidDeviceInfo = Platform.isIOS ? null : await DeviceInfoPlugin().androidInfo;

    // If iOS or Android version < 33.
    if (androidDeviceInfo == null || androidDeviceInfo.version.sdkInt < 33) {
      List<Permission> permissionsToCheck = [ Permission.storage ];
      PermissionStatus storagePermissionStatus = await Permission.storage.status;

      if (!context.mounted) {
        return false;
      }

      if (storagePermissionStatus.isDenied) {
        Utils.showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.translate('information'),
          text: AppLocalizations.of(context)!.translate('error_generic_download_file_permission'),
          positiveName: AppLocalizations.of(context)!.translate('continue'),
          negativeName: null,
          positiveAction: (BuildContext auxContext) => _onContinueButtonClicked(context, permissionsToCheck),
          negativeAction: null
        );

        return false;
      } else if (storagePermissionStatus != PermissionStatus.granted) {
        return await PermissionsService.requestPermissions(permissionsToCheck);
      }
    } else {
      return true;
      /* No need to ask for permission.
        //PermissionStatus videosPermissionStatus = await Permission.videos.status;
        PermissionStatus photosPermissionStatus = await Permission.photos.status;

        if (!context.mounted) {
          return false;
        }

        // if (videosPermissionStatus.isDenied || photosPermissionStatus.isDenied) {
        if (photosPermissionStatus.isDenied) {
          Utils.showAlertDialog(context, AppLocalizations.of(context)!.translate('information'), AppLocalizations.of(context)!.translate('error_generic_open_gallery_file_permission'), AppLocalizations.of(context)!.translate('continue'), null, (BuildContext context) { Navigator.pop(context); PermissionsService.requestPermission([ Permission.videos, Permission.photos ]); }, null);
          return false;
        //} else if (videosPermissionStatus != PermissionStatus.granted || photosPermissionStatus != PermissionStatus.granted) {
        } else if (photosPermissionStatus != PermissionStatus.granted) {
          return await PermissionsService.requestPermission([ Permission.videos, Permission.photos ]);
        }
      */
    }

    return true;
  }

  // Method that is called when the user clicks the continue button.
  static void _onContinueButtonClicked(BuildContext context, List<Permission> permissionsToCheck) {
    Navigator.pop(context);
    PermissionsService.requestPermissions(permissionsToCheck);
  }
}