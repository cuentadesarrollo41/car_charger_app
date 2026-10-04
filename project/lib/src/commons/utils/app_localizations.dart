import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Config.
import 'package:project/src/config/index.dart';

// Models.
import 'package:project/src/models/generic/session_model.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';

class AppLocalizations {
  static const String spanishCode = 'es';
  static const String englishCode = 'en';

  static const List<String> languageCodes = [
    spanishCode,
    englishCode
  ];

  Locale locale;

  AppLocalizations(this.locale);

  // Helper method that keeps the code in the widgets concise.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from the MaterialApp.
  static LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static Map<String, String>? _localizedStrings;

  void reload() async {
    delegate = _AppLocalizationsDelegate();
    await load();
  }

  Future<bool> load() async {
    SessionModel session = Preferences().session;
    String languageCode = session.languageCode;

    if (languageCode.isEmpty) {
      languageCode = locale.languageCode;

      if (!_AppLocalizationsDelegate().isSupported(locale)) {
        languageCode = spanishCode;
      }

      session.languageCode = languageCode;
      Preferences().session = session;
    }

    String jsonString = await rootBundle.loadString('lang/$languageCode.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // Method that will be called from every widget which needs a localized text.
  String translate(String key) {
    return _localizedStrings![key] == null ? Strings.nullString : _localizedStrings![key]!;
  }

  // Get supported locales.
  static List<Locale> getSupportedLocales() {
    return languageCodes.map((String languageCode) => getLocaleByLanguageCode(languageCode))
        .toList();
  }

  // Get locale by language code.
  static Locale getLocaleByLanguageCode(String? languageCode) {
    switch(languageCode) {
      case AppLocalizations.spanishCode: return Locale(languageCode!, 'ES');
      case AppLocalizations.englishCode: return Locale(languageCode!, 'US');
      default: return const Locale(AppLocalizations.englishCode, 'US');
    }
  }
}

// LocalizationsDelegate is a factory for a set of localized resources.
// In this case, the localized strings will be gotten in an AppLocalizations object.
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {

  // This delegate instance will never change.
  _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      AppLocalizations.spanishCode,
      AppLocalizations.englishCode,
    ].contains(locale.languageCode); // Include all supported language codes.
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();

    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}