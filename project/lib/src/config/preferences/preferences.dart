import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Models.
import 'package:project/src/models/generic/session_model.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/strings.dart';

class Preferences {
  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();

  SharedPreferences? _sharedPreferences;

  Future<void> initPreferences() async => _sharedPreferences = await SharedPreferences.getInstance();

  // Firebase token.
  String get firebaseToken => _sharedPreferences!.getString(Fields.firebaseToken) == null || _sharedPreferences!.getString(Fields.firebaseToken)!.isEmpty
    ? Strings.emptyString
    : _sharedPreferences!.getString(Fields.firebaseToken)!;
  set firebaseToken (String firebaseToken) => _sharedPreferences!.setString(Fields.firebaseToken, firebaseToken);

  // Session.
  SessionModel get session => SessionModel.fromJson(_sharedPreferences!.get(Fields.session) == null ? {} : jsonDecode(_sharedPreferences!.getString(Fields.session)!));
  set session (SessionModel session) => _sharedPreferences!.setString(Fields.session, jsonEncode(session.toJson()));

  // Check if shared preferences is initialized.
  bool sharedPreferencesIsInitialized() => _sharedPreferences != null;

  // Reset.
  void reset() => session = SessionModel();
}