import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Helpers.
import 'package:project/src/config/permissions/helpers/permission_camera.dart';
import 'package:project/src/config/permissions/helpers/permission_storage.dart';
import 'package:project/src/config/permissions/helpers/request_permissions.dart';
import 'package:project/src/config/permissions/manager/request_permission_manager.dart';

// Exports.
export './manager/request_permission_manager.dart';
export './permissions_states.dart';

abstract class PermissionsService {
  // Camera permission is managed with request permission manager.
  static RequestPermissionManager requestPermissionManager({ required PermissionTypes permissionType, required void Function()? askForPermission, required void Function()? onPermissionDenied, required void Function()? onPermissionPermanentlyDenied, required void Function()? onPermissionGranted })
    => RequestPermissionManager(permissionType).askForPermission(askForPermission).onPermissionDenied(onPermissionDenied).onPermissionPermanentlyDenied(onPermissionPermanentlyDenied).onPermissionGranted(onPermissionGranted);

  static Future<bool> checkStoragePermission(BuildContext context) => PermissionStorage.check(context: context);
  static Future<bool> checkCameraPermission(BuildContext context) => PermissionCamera.check(context: context);
  static Future<bool> requestPermissions(List<Permission> permissionsToCheck) => RequestPermissions.run(permissionsToCheck);
}