import 'dart:convert';

// Models.
import 'package:project/src/models/charger_model.dart';
import 'package:project/src/models/user_model.dart';

// Commons.
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/constants/fields.dart';

SessionModel sessionModelFromJson(String str) => SessionModel.fromJson(json.decode(str));
String sessionModelToJson(SessionModel data) => json.encode(data.toJson());

class SessionModel {
  String languageCode;
  String token;
  UserModel user;
  String selectedChargerId;
  DateTime updateUserLastDate;
  DateTime updateChargerLastDate;

  SessionModel({
    this.languageCode = Strings.emptyString,
    this.token = Strings.emptyString,
    this.selectedChargerId = Strings.emptyString,
    UserModel? user,
    DateTime? updateUserLastDate,
    DateTime? updateChargerLastDate,
  }) :
    user = user ?? UserModel(),
    updateUserLastDate = updateUserLastDate ?? DateTime.now(),
    updateChargerLastDate = updateChargerLastDate ?? DateTime(Numbers.firstYear)
  ;

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
    languageCode: json[Fields.languageCode] ?? Strings.emptyString,
    token: json[Fields.token] ?? Strings.emptyString,
    user: UserModel.fromJson(json[Fields.user] ?? {}),
    selectedChargerId: json[Fields.selectedChargerId] ?? Strings.emptyString,
    updateUserLastDate: json[Fields.updateUserLastDate] == null
      ? DateTime.now()
      : DateTime.parse(json[Fields.updateUserLastDate]),
    updateChargerLastDate: json[Fields.updateChargerLastDate] == null
      ? DateTime(Numbers.firstYear)
      : DateTime.parse(json[Fields.updateChargerLastDate]),
  );

  Map<String, dynamic> toJson() => {
    Fields.languageCode: languageCode,
    Fields.token: token,
    Fields.user: user.toJson(),
    Fields.selectedChargerId: selectedChargerId,
    Fields.updateUserLastDate: updateUserLastDate.toString(),
    Fields.updateChargerLastDate: updateChargerLastDate.toString(),
  };

  // Method that logs the user out.
  void logout() {
    token = Strings.emptyString;
    user = UserModel();
    selectedChargerId = Strings.emptyString;
    updateUserLastDate = DateTime(Numbers.firstYear);
    updateChargerLastDate = DateTime(Numbers.firstYear);
  }

  // Method that updates the selected charger: keeps it if it still exists, otherwise selects the first one (or none).
  void updateSelectedCharger() {
    final String previousChargerId = selectedChargerId;

    if (user.chargers.isEmpty) {
      selectedChargerId = Strings.emptyString;
    } else {
      final bool selectedChargerExists = user.chargers.any((ChargerModel charger) => charger.id == selectedChargerId);

      if (!selectedChargerExists) {
        selectedChargerId = user.chargers.first.id;
      }
    }

    if (selectedChargerId != previousChargerId) {
      updateChargerLastDate = DateTime(Numbers.firstYear);
    }
  }

  // Method that checks of refresh is needed.
  bool allowRefresh() {
    final DateTime now = DateTime.now();

    return user.name.isEmpty || now.difference(updateUserLastDate).inSeconds >= Numbers.maxTimeDifferenceRefreshUser;
  }

  // Method that checks if the selected charger must be refreshed.
  bool allowRefreshCharger() => DateTime.now().difference(updateChargerLastDate).inSeconds >= Numbers.maxTimeDifferenceRefreshCharger;

  // Method that replaces a charger of the user's list with the received one and saves the refresh date.
  void updateCharger(ChargerModel charger) {
    final int index = user.chargers.indexWhere((ChargerModel element) => element.id == charger.id);

    if (index == -1) {
      return;
    }

    user.chargers[index] = charger;
    updateChargerLastDate = DateTime.now();
  }
}
