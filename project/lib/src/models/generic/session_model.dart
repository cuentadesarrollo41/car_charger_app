import 'dart:convert';

// Models.
import 'package:project/src/models/user_model.dart';

// Commons.
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/constants/fields.dart';

SessionModel sessionModelFromJson(String str) =>
    SessionModel.fromJson(json.decode(str));

String sessionModelToJson(SessionModel data) => json.encode(data.toJson());

class SessionModel {
  String languageCode;
  String token;
  UserModel user;
  DateTime updateUserLastDate;

  SessionModel({
    this.languageCode = Strings.emptyString,
    this.token = Strings.emptyString,
    UserModel? user,
    DateTime? updateUserLastDate,
  }) : user = user ?? UserModel(),
       updateUserLastDate = updateUserLastDate ?? DateTime.now();

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
    languageCode: json[Fields.languageCode] ?? Strings.emptyString,
    token: json[Fields.token] ?? Strings.emptyString,
    user: UserModel.fromJson(json[Fields.user] ?? {}),
    updateUserLastDate: json[Fields.updateUserLastDate] == null
        ? DateTime.now()
        : DateTime.parse(json[Fields.updateUserLastDate]),
  );

  Map<String, dynamic> toJson() => {
    Fields.languageCode: languageCode,
    Fields.token: token,
    Fields.user: user.toJson(),
    Fields.updateUserLastDate: updateUserLastDate.toString(),
  };

  // Method that logs the user out.
  void logout() {
    token = Strings.emptyString;
    user = UserModel();
    updateUserLastDate = DateTime(Numbers.firstYear);
  }

  // Method that checks of refresh is needed.
  bool allowRefresh() {
    final DateTime now = DateTime.now();

    return user.name.isEmpty ||
        now.difference(updateUserLastDate).inSeconds >=
            Numbers.maxTimeDifferenceRefreshUser;
  }
}
