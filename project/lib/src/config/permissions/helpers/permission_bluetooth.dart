import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

// Config.
import 'package:project/src/config/permissions/permissions_states.dart';

abstract class PermissionBluetooth {
  // Method that requests the Bluetooth permissions and returns their state.
  static Future<String> request() async {
    List<Permission> permissionsToCheck = await _getPermissions();
    Map<Permission, PermissionStatus> permissions = await permissionsToCheck.request();

    if (permissions.values.every((PermissionStatus status) => status.isGranted)) {
      return PermissionsStates.granted;
    }

    if (permissions.values.any((PermissionStatus status) => status.isPermanentlyDenied || status.isRestricted)) {
      return PermissionsStates.permanentlyDenied;
    }

    return PermissionsStates.denied;
  }

  // Method that returns the Bluetooth permissions to request: nearby devices on Android 12+ and location before it.
  static Future<List<Permission>> _getPermissions() async {
    if (Platform.isIOS) {
      return [ Permission.bluetooth ];
    }

    AndroidDeviceInfo androidDeviceInfo = await DeviceInfoPlugin().androidInfo;

    return androidDeviceInfo.version.sdkInt >= 31
      ? [ Permission.bluetoothScan, Permission.bluetoothConnect ]
      : [ Permission.locationWhenInUse ];
  }
}
