import 'package:permission_handler/permission_handler.dart';

enum PermissionTypes {
  camera,
  storage,
}

class RequestPermissionManager {
  PermissionTypes? _permissionType; // Permission type to request permission from user.
  Function()? _askForPermission; // Ask for permission.
  Function()? _onPermissionDenied; // Callback when permission is denied by user.
  Function()? _onPermissionGranted; // Callback when permission is granted by user.
  Function()? _onPermissionPermanentlyDenied; // Callback when permission is permanently denied by user.

  RequestPermissionManager(PermissionTypes permissionType) {
    _permissionType = permissionType;
  }

  // Method that asks for permissions.
  RequestPermissionManager askForPermission(Function()? askForPermission) {
    _askForPermission = askForPermission;
    return this;
  }

  // Method to handle when permission is denied.
  RequestPermissionManager onPermissionDenied(Function()? onPermissionDenied) {
    _onPermissionDenied = onPermissionDenied;
    return this;
  }

  // Method to handle when permission is permanently denied.
  RequestPermissionManager onPermissionPermanentlyDenied(Function()? onPermissionPermanentlyDenied) {
    _onPermissionPermanentlyDenied = onPermissionPermanentlyDenied;
    return this;
  }

  // Method to handle when permission is granted.
  RequestPermissionManager onPermissionGranted(Function()? onPermissionGranted) {
    _onPermissionGranted = onPermissionGranted;
    return this;
  }

  Permission _getPermissionFromType(PermissionTypes permissionType) {
    switch (permissionType) {
      case PermissionTypes.camera: return Permission.camera;
      case PermissionTypes.storage: return Permission.storage;
    }
  }

  /// Gets permission from PermissionType enum value and request permission
  /// handle permission status and call callback function
  /// if permission is granted, call onPermissionGranted callback
  /// if permission is denied, call onPermissionDenied callback
  /// if permission is permanently denied, call onPermissionPermanentlyDenied callback
  void execute() async {
    Permission permission = _getPermissionFromType(_permissionType!);

    // Ask for
    if (_askForPermission != null && (await permission.status.isDenied)) {
      _askForPermission!();
      return;
    }

    PermissionStatus status = await permission.request();

    if (status.isGranted && _onPermissionGranted != null) {
      _onPermissionGranted!();
    } else if (status.isDenied && _onPermissionDenied != null) {
      _onPermissionDenied!();
    } else if (status.isPermanentlyDenied && _onPermissionPermanentlyDenied != null) {
      _onPermissionPermanentlyDenied!();
    }
  }
}