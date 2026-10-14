import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Commons.
import 'package:project/src/commons/constants/calendar.dart';
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

ChargingSessionModel chargingSessionModelFromJson(String str) => ChargingSessionModel.fromJson(json.decode(str));

String chargingSessionModelToJson(ChargingSessionModel data) => json.encode(data.toJson());

class ChargingSessionModel {
  String id;
  int energyWh;
  DateTime startTime;
  DateTime endTime;
  DateTime creationDate;
  DateTime modificationDate;

  ChargingSessionModel({
    this.id = Strings.emptyString,
    this.energyWh = 0,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? creationDate,
    DateTime? modificationDate,
  }) :
    startTime = startTime ?? DateTime.now(),
    endTime = endTime ?? DateTime.now(),
    creationDate = creationDate ?? DateTime.now(),
    modificationDate = modificationDate ?? DateTime.now()
  ;

  factory ChargingSessionModel.fromJson(Map<String, dynamic> json) => ChargingSessionModel(
    id: json[Fields.id] ?? Strings.emptyString,
    energyWh: json[Fields.energyWh] ?? 0,
    startTime: json[Fields.startTime] == null ? DateTime.now() : DateTime.parse(json[Fields.startTime]),
    endTime: json[Fields.endTime] == null ? DateTime.now() : DateTime.parse(json[Fields.endTime]),
    creationDate: json[Fields.creationDate] == null ? DateTime.now() : DateTime.parse(json[Fields.creationDate]),
    modificationDate: json[Fields.modificationDate] == null ? DateTime.now() : DateTime.parse(json[Fields.modificationDate]),
  );

  Map<String, dynamic> toJson() => {
    Fields.id: id,
    Fields.energyWh: energyWh,
    Fields.startTime: startTime.toString(),
    Fields.endTime: endTime.toString(),
    Fields.creationDate: creationDate.toString(),
    Fields.modificationDate: modificationDate.toString(),
  };

  // Method that returns the title of the session: the day and the energy (e.g. "Hoy • 12,4 kWh").
  String getTitle({ required BuildContext context }) => '${ getDay(context: context) }${ Strings.oneSpace }${ Strings.bullet }${ Strings.oneSpace }${ getEnergy(context: context) }';

  // Method that returns the day of the session: today, yesterday or the day and the short month (e.g. "19 sep").
  String getDay({ required BuildContext context }) {
    final DateTime localStartTime = startTime.toLocal();
    final DateTime now = DateTime.now();

    final DateTime today = DateTime.utc(now.year, now.month, now.day);
    final DateTime startDay = DateTime.utc(localStartTime.year, localStartTime.month, localStartTime.day);
    final int dayDifference = today.difference(startDay).inDays;

    if (dayDifference == Numbers.zero) {
      return AppLocalizations.of(context)!.translate('weekday_today');
    }

    if (dayDifference == Numbers.one) {
      return AppLocalizations.of(context)!.translate('weekday_yesterday');
    }

    final String month = AppLocalizations.of(context)!.translate(Calendar.months[localStartTime.month - 1]);
    final String shortMonth = month.length <= 3 ? month : month.substring(0, 3);

    return '${ localStartTime.day } ${ shortMonth.toLowerCase() }';
  }

  // Method that returns the start and end time of the session (e.g. "14:32 - 16:15").
  String getTime() => '${ DateFormat('HH:mm').format(startTime.toLocal()) }${ Strings.oneSpace }${ Strings.hyphen }${ Strings.oneSpace }${ DateFormat('HH:mm').format(endTime.toLocal()) }';

  // Method that returns the energy of the session in kWh, according to the session language (e.g. "12,4 kWh").
  String getEnergy({ required BuildContext context }) => Utils.formatEnergyKwh(
    energyWh: energyWh,
    languageCode: BlocProvider.stateBloc(context).session.languageCode
  );
}
