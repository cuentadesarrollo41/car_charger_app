import 'dart:convert';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/states.dart';
import 'package:project/src/commons/constants/strings.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String id;
  String name;
  String email;
  String password;
  String state;
  DateTime creationDate;
  DateTime modificationDate;

  UserModel({
    this.id = Strings.emptyString,
    this.name = Strings.emptyString,
    this.email = Strings.emptyString,
    this.password = Strings.emptyString,
    this.state = States.ok,
    DateTime? creationDate,
    DateTime? modificationDate,
  }) :
    creationDate = creationDate ?? DateTime.now(),
    modificationDate = modificationDate ?? DateTime.now()
  ;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json[Fields.id] ?? Strings.emptyString,
    name: json[Fields.name] ?? Strings.emptyString,
    email: json[Fields.email] ?? Strings.emptyString,
    password: json[Fields.password] ?? Strings.emptyString,
    state: json[Fields.state] ?? States.ok,
    creationDate: json[Fields.creationDate] == null ? DateTime.now() : DateTime.parse(json[Fields.creationDate]),
    modificationDate: json[Fields.modificationDate] == null ? DateTime.now() : DateTime.parse(json[Fields.modificationDate]),
  );

  Map<String, dynamic> toJson() => {
    Fields.id: id,
    Fields.name: name,
    Fields.email: email,
    Fields.password: password,
    Fields.state: state,
    Fields.creationDate: creationDate.toString(),
    Fields.modificationDate: modificationDate.toString(),
  };

  // Method that checks if user is active.
  bool isActive() => state == States.ok;
}
