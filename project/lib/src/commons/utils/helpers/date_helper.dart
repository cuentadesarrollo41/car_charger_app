import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/calendar.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

abstract class DateHelper {
  // Method that gets a string from date.
  static String getStringFromDate({ required DateTime date, bool reverse = true, bool onlyDate = false, bool onlyTime = false, bool showSeconds = true, String separator = Strings.hyphen, String separatorDateMin = Strings.separatorDateMinutes }) {
    String dateString = reverse
      ? '${ date.year }$separator${ date.month.toString().padLeft(2, Strings.zero) }$separator${ date.day.toString().padLeft(2, Strings.zero) }'
      : '${ date.day.toString().padLeft(2, Strings.zero) }$separator${ date.month.toString().padLeft(2, Strings.zero) }$separator${ date.year }';

    if (onlyDate) {
      return dateString;
    }

    String timeString = '${ date.hour.toString().padLeft(2, Strings.zero) }:${ date.minute.toString().padLeft(2, Strings.zero) }${ showSeconds ? ':${ date.second.toString().padLeft(2, Strings.zero) }' : Strings.emptyString }';

    if (onlyTime) {
      return timeString;
    }

    return '$dateString$separatorDateMin$timeString';
  }

  // Method that gets a formatted string from date.
  static String getFormattedStringFromDate({ required BuildContext context, required DateTime date, bool showTime = false }) {
    String dateString = '${ date.day } ${ AppLocalizations.of(context)!.translate(Calendar.months[date.month - 1]) } ${ date.year }';
    String timeString = '${ date.hour.toString().padLeft(2, Strings.zero) }:${ date.minute.toString().padLeft(2, Strings.zero) }';

    return showTime
      ? '$dateString $timeString'
      : dateString;
  }

  // Method that gets a formatted string from date and time.
  static String getFormattedStringFromDateAndTime({ required BuildContext context, required DateTime date }) {
    return AppLocalizations.of(context)!.translate('available_at_date')
      .replaceFirst(Strings.replaceCode, date.day.toString())
      .replaceFirst(Strings.replaceCode, AppLocalizations.of(context)!.translate(Calendar.months[date.month - 1])).toLowerCase()
      .replaceFirst(Strings.replaceCode, date.year.toString())
      .replaceFirst(Strings.replaceCode, '${ date.hour.toString().padLeft(2, Strings.zero) }:${ date.minute.toString().padLeft(2, Strings.zero) }')
    ;
  }

  // Method that gets a formatted string from date using text.
  static String getFormattedStringFromDateWithText({ required BuildContext context, required String language, required DateTime date, String referenceTextKey = 'date_presentation', bool monthAsText = true }) {
    String timeString = '${ date.hour.toString().padLeft(2, Strings.zero) }:${ date.minute.toString().padLeft(2, Strings.zero) }';

    switch (language) {
      case AppLocalizations.englishCode:
        final isPM = date.hour >= 12;
        final hour12 = (date.hour % 12 == 0) ? 12 : date.hour % 12;
        timeString = '$hour12:${ date.minute.toString().padLeft(2, Strings.zero) } ${ isPM ? 'PM' : 'AM' }';
        break;
      default: break;
    }

    return AppLocalizations.of(context)!.translate(referenceTextKey)
      .replaceFirst('#month', monthAsText ? AppLocalizations.of(context)!.translate(Calendar.months[date.month - 1]) : date.month.toString().padLeft(2, Strings.zero))
      .replaceFirst('#day', date.day.toString().padLeft(monthAsText ? 0 : 2, Strings.zero))
      .replaceFirst('#year', date.year.toString())
      .replaceFirst('#time', timeString)
    ;
  }

  // Method that gets the localized time string.
  static String getLocalizedTimeString({ required String time, required String language }) {
    List<String> timeItems = time.split(Strings.colon);
    String timeString = Strings.emptyString;

    if (timeItems.length < 2) {
      return Strings.emptyString;
    }

    try {
      final int hour = int.parse(timeItems[0]);
      final int minute = int.parse(timeItems[1]);

      switch (language) {
        case AppLocalizations.spanishCode:
          timeString = '${ hour.toString().padLeft(2, Strings.zero) }:${ minute.toString().padLeft(2, Strings.zero) }';
          break;
        case AppLocalizations.englishCode:
          final isPM = hour >= 12;
          final hour12 = (hour % 12 == 0) ? 12 : hour % 12;

          timeString = '$hour12:${ minute.toString().padLeft(2, Strings.zero) } ${ isPM ? 'PM' : 'AM' }';
          break;
        default: return Strings.emptyString;
      }
    } catch (e) {
      return Strings.emptyString;
    }

    return timeString;
  }
}