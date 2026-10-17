import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';

class BluetoothChargerModel {
  final BluetoothDevice device;
  final String name;
  final String model;

  BluetoothChargerModel({
    required this.device,
    required this.name,
    this.model = Strings.emptyString
  });

  // Getter that returns the identifier of the charger.
  String get id => device.remoteId.str;
}
