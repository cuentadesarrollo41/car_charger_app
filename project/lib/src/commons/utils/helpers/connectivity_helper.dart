import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityHelper {
  // Method that checks if the devices is connected to internet.
  static Future<bool> deviceIsConnected() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi);
  }
}