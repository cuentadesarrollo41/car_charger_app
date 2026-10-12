import 'dart:convert';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/states.dart';
import 'package:project/src/commons/constants/strings.dart';

ChargerModel chargerModelFromJson(String str) => ChargerModel.fromJson(json.decode(str));

String chargerModelToJson(ChargerModel data) => json.encode(data.toJson());

class ChargerModel {
  String id;
  String linkId;
  String name;
  String serialNumber;
  String chargePointModel;
  String chargePointVendor;
  String firmwareVersion;
  String networkName;
  DateTime? lastHeartbeat;
  int currentLimitAmps;
  DateTime? nextChargeDate;
  String state;
  DateTime creationDate;
  DateTime modificationDate;

  ChargerModel({
    this.id = Strings.emptyString,
    this.linkId = Strings.emptyString,
    this.name = Strings.emptyString,
    this.serialNumber = Strings.emptyString,
    this.chargePointModel = Strings.emptyString,
    this.chargePointVendor = Strings.emptyString,
    this.firmwareVersion = Strings.emptyString,
    this.networkName = Strings.emptyString,
    this.lastHeartbeat,
    this.currentLimitAmps = 0,
    this.nextChargeDate,
    this.state = States.ok,
    DateTime? creationDate,
    DateTime? modificationDate,
  }) :
    creationDate = creationDate ?? DateTime.now(),
    modificationDate = modificationDate ?? DateTime.now()
  ;

  factory ChargerModel.fromJson(Map<String, dynamic> json) => ChargerModel(
    id: json[Fields.id] ?? Strings.emptyString,
    linkId: json[Fields.linkId] ?? Strings.emptyString,
    name: json[Fields.name] ?? Strings.emptyString,
    serialNumber: json[Fields.serialNumber] ?? Strings.emptyString,
    chargePointModel: json[Fields.chargePointModel] ?? Strings.emptyString,
    chargePointVendor: json[Fields.chargePointVendor] ?? Strings.emptyString,
    firmwareVersion: json[Fields.firmwareVersion] ?? Strings.emptyString,
    networkName: json[Fields.networkName] ?? Strings.emptyString,
    lastHeartbeat: json[Fields.lastHeartbeat] == null ? null : DateTime.parse(json[Fields.lastHeartbeat]),
    currentLimitAmps: json[Fields.currentLimitAmps] ?? 0,
    nextChargeDate: json[Fields.nextChargeDate] == null ? null : DateTime.parse(json[Fields.nextChargeDate]),
    state: json[Fields.state] ?? States.ok,
    creationDate: json[Fields.creationDate] == null ? DateTime.now() : DateTime.parse(json[Fields.creationDate]),
    modificationDate: json[Fields.modificationDate] == null ? DateTime.now() : DateTime.parse(json[Fields.modificationDate]),
  );

  Map<String, dynamic> toJson() => {
    Fields.id: id,
    Fields.linkId: linkId,
    Fields.name: name,
    Fields.serialNumber: serialNumber,
    Fields.chargePointModel: chargePointModel,
    Fields.chargePointVendor: chargePointVendor,
    Fields.firmwareVersion: firmwareVersion,
    Fields.networkName: networkName,
    Fields.lastHeartbeat: lastHeartbeat?.toString(),
    Fields.currentLimitAmps: currentLimitAmps,
    Fields.nextChargeDate: nextChargeDate?.toString(),
    Fields.state: state,
    Fields.creationDate: creationDate.toString(),
    Fields.modificationDate: modificationDate.toString(),
  };

  // Method that checks if charger is active.
  bool isActive() => state == States.ok;
}
