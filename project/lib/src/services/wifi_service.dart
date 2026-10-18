import 'dart:async';
import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:wifi_scan/wifi_scan.dart';

// Models.
import 'package:project/src/models/link_charger/wifi_network_model.dart';

// Commons.
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/states.dart';
import 'package:project/src/commons/constants/strings.dart';

abstract class WifiService {
  // Method that returns whether the Wi-Fi scan can run on Android: ready, location service off or precise location permission missing.
  static Future<String> getScanState() async {
    if (!Platform.isAndroid) {
      return States.wifiScanReady;
    }

    final CanStartScan canStartScan = await WiFiScan.instance.canStartScan(askPermissions: false);

    switch (canStartScan) {
      case CanStartScan.yes: return States.wifiScanReady;
      case CanStartScan.noLocationServiceDisabled: return States.wifiScanLocationOff;
      // The location permission is missing or it is only the approximate one, which does not allow reading the scan results.
      default: return States.wifiScanPermissionRequired;
    }
  }

  // Method that scans the Wi-Fi networks around the device. Only Android can scan; iOS reads the current network instead.
  static Future<List<WifiNetworkModel>> scan() async {
    if (!Platform.isAndroid) {
      return [];
    }

    await WiFiScan.instance.startScan();

    try {
      await WiFiScan.instance.onScannedResultsAvailable.first.timeout(const Duration(seconds: Numbers.wifiScanTimeout));
    } on TimeoutException {
      // Android throttles scans and the last cached results are still valid, so the timeout continues.
    }

    List<WiFiAccessPoint> accessPoints = await WiFiScan.instance.getScannedResults();

    // Keep the strongest result of each network with a name.
    Map<String, WiFiAccessPoint> networks = {};

    for (WiFiAccessPoint accessPoint in accessPoints) {
      if (accessPoint.ssid.isEmpty) {
        continue;
      }

      WiFiAccessPoint? current = networks[accessPoint.ssid];

      if (current == null || accessPoint.level > current.level) {
        networks[accessPoint.ssid] = accessPoint;
      }
    }

    List<WiFiAccessPoint> sortedAccessPoints = networks.values.toList()
      ..sort((WiFiAccessPoint a, WiFiAccessPoint b) => b.level.compareTo(a.level));

    return sortedAccessPoints.map((WiFiAccessPoint accessPoint) => WifiNetworkModel(
      ssid: accessPoint.ssid,
      level: accessPoint.level,
      frequency: accessPoint.frequency
    )).toList();
  }

  // Method that returns the name of the network the device is connected to, without the quotes some platforms add.
  static Future<String> getCurrentNetworkName() async {
    try {
      String? wifiName = await NetworkInfo().getWifiName();

      return wifiName == null ? Strings.emptyString : wifiName.replaceAll('"', Strings.emptyString);
    } catch (e) {
      return Strings.emptyString;
    }
  }
}
