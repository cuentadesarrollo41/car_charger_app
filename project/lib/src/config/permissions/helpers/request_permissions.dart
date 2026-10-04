import 'package:permission_handler/permission_handler.dart';

abstract class RequestPermissions {
  static Future<bool> run(List<Permission> permissionsToCheck) async {
    Map<Permission, PermissionStatus> permissions;
    bool permissionsDenied = false;

    permissions = await permissionsToCheck.request();

    // Check if helpers have been denied.
    for (Permission permission in permissionsToCheck) {
      if (permissions[permission] == PermissionStatus.denied) {
        permissionsDenied = true;
        break;
      }
    }

    if (permissionsDenied) {
      return false;
    }

    // Check if helpers have been permanently denied.
    for (Permission permission in permissionsToCheck) {
      if (permissions[permission] == PermissionStatus.permanentlyDenied) {
        permissionsDenied = true;
        break;
      }
    }

    if (permissionsDenied) {
      await openAppSettings();
    }

    bool allGranted = true;

    for (Permission permission in permissionsToCheck) {
      PermissionStatus status = await permission.status;

      if (status != PermissionStatus.granted) {
        allGranted = false;
        break;
      }
    }

    return allGranted;
  }
}