import 'dart:convert';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/states.dart';
import 'package:project/src/commons/constants/strings.dart';

ChargerModel chargerModelFromJson(String str) => ChargerModel.fromJson(json.decode(str));

String chargerModelToJson(ChargerModel data) => json.encode(data.toJson());

class ChargerModel {
  String id;
  String name;
  String state;
  DateTime creationDate;
  DateTime modificationDate;

  ChargerModel({
    this.id = Strings.emptyString,
    this.name = Strings.emptyString,
    this.state = States.ok,
    DateTime? creationDate,
    DateTime? modificationDate,
  }) :
    creationDate = creationDate ?? DateTime.now(),
    modificationDate = modificationDate ?? DateTime.now()
  ;

  factory ChargerModel.fromJson(Map<String, dynamic> json) => ChargerModel(
    id: json[Fields.id] ?? Strings.emptyString,
    name: json[Fields.name] ?? Strings.emptyString,
    state: json[Fields.state] ?? States.ok,
    creationDate: json[Fields.creationDate] == null ? DateTime.now() : DateTime.parse(json[Fields.creationDate]),
    modificationDate: json[Fields.modificationDate] == null ? DateTime.now() : DateTime.parse(json[Fields.modificationDate]),
  );

  Map<String, dynamic> toJson() => {
    Fields.id: id,
    Fields.name: name,
    Fields.state: state,
    Fields.creationDate: creationDate.toString(),
    Fields.modificationDate: modificationDate.toString(),
  };

  // Method that checks if charger is active.
  bool isActive() => state == States.ok;
}
