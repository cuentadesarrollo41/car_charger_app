// Commons.
import 'package:project/src/commons/constants/numbers.dart';

class WifiNetworkModel {
  final String ssid;
  final int level; // Signal in dBm, Numbers.zero when unknown.
  final int frequency; // MHz, Numbers.zero when unknown.

  WifiNetworkModel({
    required this.ssid,
    this.level = Numbers.zero,
    this.frequency = Numbers.zero
  });
}
