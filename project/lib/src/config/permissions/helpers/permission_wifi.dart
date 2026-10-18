import 'package:permission_handler/permission_handler.dart';

// Config.
import 'package:project/src/config/permissions/permissions_states.dart';

abstract class PermissionWifi {
  // Method that requests the Wi-Fi permissions and returns their state.
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

  // Method that returns the Wi-Fi permissions to request: location is needed to scan the Wi-Fi networks on Android and to read the current network on iOS.
  static Future<List<Permission>> _getPermissions() async => [ Permission.locationWhenInUse ];
}
