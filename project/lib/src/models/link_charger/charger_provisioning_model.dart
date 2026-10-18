import 'dart:convert';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/strings.dart';

ChargerProvisioningModel chargerProvisioningModelFromJson(String str) => ChargerProvisioningModel.fromJson(json.decode(str));

String chargerProvisioningModelToJson(ChargerProvisioningModel data) => json.encode(data.toJson());

// Data returned by the backend when a charger is registered, which is sent to the charger through Bluetooth together with the Wi-Fi credentials.
class ChargerProvisioningModel {
  String authorizationKey;
  String ocppHost;
  int ocppPort;
  String ocppPath;

  ChargerProvisioningModel({
    this.authorizationKey = Strings.emptyString,
    this.ocppHost = Strings.emptyString,
    this.ocppPort = Numbers.zero,
    this.ocppPath = Strings.emptyString
  });

  factory ChargerProvisioningModel.fromJson(Map<String, dynamic> json) => ChargerProvisioningModel(
    authorizationKey: json[Fields.authorizationKey] ?? Strings.emptyString,
    ocppHost: json[Fields.ocppHost] ?? Strings.emptyString,
    ocppPort: json[Fields.ocppPort] ?? Numbers.zero,
    ocppPath: json[Fields.ocppPath] ?? Strings.emptyString
  );

  Map<String, dynamic> toJson() => {
    Fields.authorizationKey: authorizationKey,
    Fields.ocppHost: ocppHost,
    Fields.ocppPort: ocppPort,
    Fields.ocppPath: ocppPath
  };
}
