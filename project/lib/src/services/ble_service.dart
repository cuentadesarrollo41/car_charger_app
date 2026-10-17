import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// Models.
import 'package:project/src/models/link_charger/bluetooth_charger_model.dart';

// Commons.
import 'package:project/src/commons/constants/numbers.dart';

abstract class BleService {
  // Method that checks if the device supports Bluetooth.
  static Future<bool> isSupported() => FlutterBluePlus.isSupported;

  // Method that checks if the Bluetooth adapter is on.
  static Future<bool> isOn() async {
    try {
      BluetoothAdapterState adapterState = await FlutterBluePlus.adapterState
        .firstWhere((BluetoothAdapterState state) => state != BluetoothAdapterState.unknown)
        .timeout(const Duration(seconds: Numbers.bluetoothAdapterTimeout));

      return adapterState == BluetoothAdapterState.on;
    } catch (e) {
      return false;
    }
  }

  // Method that asks the user to turn the Bluetooth on. Only Android allows it.
  static Future<void> turnOn() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      await FlutterBluePlus.turnOn();
    } catch (e) {
      // The user may reject the system dialog.
    }
  }

  // Method that scans the devices whose name starts with the given prefix.
  static Future<List<BluetoothChargerModel>> scan({ required String namePrefix }) async {
    Map<String, BluetoothChargerModel> chargers = {};

    StreamSubscription<List<ScanResult>> scanResultsSubscription = FlutterBluePlus.onScanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        String name = result.advertisementData.advName;

        if (name.isEmpty || !name.startsWith(namePrefix)) {
          continue;
        }

        chargers[result.device.remoteId.str] = BluetoothChargerModel(device: result.device, name: name);
      }
    });

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: Numbers.bluetoothScanTimeout));
      await FlutterBluePlus.isScanning.where((bool isScanning) => !isScanning).first;
    } finally {
      await scanResultsSubscription.cancel();
    }

    List<BluetoothChargerModel> foundChargers = chargers.values.toList();
    foundChargers.sort((BluetoothChargerModel a, BluetoothChargerModel b) => a.name.compareTo(b.name));

    return foundChargers;
  }

  // Method that stops the current scan.
  static Future<void> stopScan() => FlutterBluePlus.stopScan();
}
