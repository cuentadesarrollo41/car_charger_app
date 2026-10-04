import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

// Config.
import 'package:project/src/config/index.dart';

// Model.
import 'package:project/src/models/generic/session_model.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

class StateBloc {
  final _sessionController = BehaviorSubject<SessionModel>();
  final _appVersionController = BehaviorSubject<String>();
  final _keyboardVisibilityController = BehaviorSubject<KeyboardVisibilityController>();
  final _keyBoardIsShownController = BehaviorSubject<bool>();
  final _endDrawerIsOpenedController = BehaviorSubject<bool>();
  final _loadingTextController = BehaviorSubject<String>();

  // Get values from Stream.
  Stream<SessionModel> get sessionStream => _sessionController.stream;
  Stream<String> get appVersionStream => _appVersionController.stream;
  Stream<KeyboardVisibilityController> get keyboardVisibilityControllerStream =>_keyboardVisibilityController.stream;
  Stream<bool> get keyboardIsShownStream => _keyBoardIsShownController.stream;
  Stream<bool> get endDrawerIsOpenedStream => _endDrawerIsOpenedController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;

  // Set values to Stream.
  Function(SessionModel) get changeSession => _sessionController.sink.add;
  Function(String) get changeAppVersion => _appVersionController.sink.add;
  Function(KeyboardVisibilityController)
  get changeKeyboardVisibilityController => _keyboardVisibilityController.sink.add;
  Function(bool) get changeKeyboardIsShown => _keyBoardIsShownController.sink.add;
  Function(bool) get changeEndDrawerIsOpened => _endDrawerIsOpenedController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;

  // Get last values of the streams.
  SessionModel get session => _sessionController.value;
  String get appVersion => _appVersionController.value;
  KeyboardVisibilityController get keyboardVisibilityController => _keyboardVisibilityController.value;
  bool get keyboardIsShown => _keyBoardIsShownController.value;
  bool get endDrawerIsOpened => _endDrawerIsOpenedController.value;
  String get loadingText => _loadingTextController.value;

  // Close Stream Controllers.
  void dispose() {
    _sessionController.close();
    _appVersionController.close();
    _keyboardVisibilityController.close();
    _keyBoardIsShownController.close();
    _endDrawerIsOpenedController.close();
    _loadingTextController.close();
  }

  // Reset fields.
  void reset() {
    changeSession(Preferences().session);
    changeAppVersion(Strings.emptyString);
    changeKeyboardVisibilityController(KeyboardVisibilityController());
    changeKeyboardIsShown(false);
    changeEndDrawerIsOpened(false);
    changeLoadingText(Strings.emptyString);

    // Define listener.
    keyboardVisibilityController.onChange.listen(
      (bool visible) => changeKeyboardIsShown(visible),
    );
  }

  // Update session.
  void updateSession(SessionModel session) {
    changeSession(session);
    Preferences().session = session;
  }

  // Update session language.
  void updateSessionLanguage(Locale locale, String languageCode) {
    session.languageCode = languageCode;

    Preferences().session = session;
    AppLocalizations(locale).reload();

    changeSession(session);
  }

  // Logout.
  void logout() {
    session.logout();
    updateSession(session);
  }

  // Check if bloc is initialized.
  bool blocIsInit() => _loadingTextController.hasValue;
}
