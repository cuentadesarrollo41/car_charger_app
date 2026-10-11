import 'dart:convert';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/strings.dart';

ChargingSessionModel chargingSessionModelFromJson(String str) => ChargingSessionModel.fromJson(json.decode(str));

String chargingSessionModelToJson(ChargingSessionModel data) => json.encode(data.toJson());

class ChargingSessionModel {
  String id;
  int value;
  DateTime startDate;
  DateTime endDate;
  DateTime creationDate;
  DateTime modificationDate;

  ChargingSessionModel({
    this.id = Strings.emptyString,
    this.value = 0,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? creationDate,
    DateTime? modificationDate,
  }) :
    startDate = startDate ?? DateTime.now(),
    endDate = endDate ?? DateTime.now(),
    creationDate = creationDate ?? DateTime.now(),
    modificationDate = modificationDate ?? DateTime.now()
  ;

  factory ChargingSessionModel.fromJson(Map<String, dynamic> json) => ChargingSessionModel(
    id: json[Fields.id] ?? Strings.emptyString,
    value: json[Fields.value] ?? 0,
    startDate: json[Fields.startDate] == null ? DateTime.now() : DateTime.parse(json[Fields.startDate]),
    endDate: json[Fields.endDate] == null ? DateTime.now() : DateTime.parse(json[Fields.endDate]),
    creationDate: json[Fields.creationDate] == null ? DateTime.now() : DateTime.parse(json[Fields.creationDate]),
    modificationDate: json[Fields.modificationDate] == null ? DateTime.now() : DateTime.parse(json[Fields.modificationDate]),
  );

  Map<String, dynamic> toJson() => {
    Fields.id: id,
    Fields.value: value,
    Fields.startDate: startDate.toString(),
    Fields.endDate: endDate.toString(),
    Fields.creationDate: creationDate.toString(),
    Fields.modificationDate: modificationDate.toString(),
  };
}
