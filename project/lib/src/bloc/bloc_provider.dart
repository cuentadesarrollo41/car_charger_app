import 'package:flutter/material.dart';

// Import.
import 'package:project/src/bloc/index.dart';

// Export.
export 'package:project/src/bloc/index.dart';

class BlocProvider extends InheritedWidget {
  static BlocProvider? _instance;

  factory BlocProvider({ Key? key, required Widget child }) {
    _instance ??= BlocProvider._internal(key: key, child: child);

    return _instance!;
  }

  BlocProvider._internal({ super.key, required super.child });

  final ForgotPasswordBloc _forgotPasswordBloc = ForgotPasswordBloc();
  final HistoryBloc _historyBloc = HistoryBloc();
  final HistoryListBloc _historyListBloc = HistoryListBloc();
  final LoginBloc _loginBloc = LoginBloc();
  final MainBloc _mainBloc = MainBloc();
  final MyProfileBloc _myProfileBloc = MyProfileBloc();
  final SettingsBloc _settingsBloc = SettingsBloc();
  final SignUpBloc _signUpBloc = SignUpBloc();
  final StateBloc _stateBloc = StateBloc();
  final UpdatePasswordBloc _updatePasswordBloc = UpdatePasswordBloc();
  final UserNameBloc _userNameBloc = UserNameBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ForgotPasswordBloc forgotPasswordBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._forgotPasswordBloc;
  static HistoryBloc historyBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._historyBloc;
  static HistoryListBloc historyListBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._historyListBloc;
  static LoginBloc loginBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._loginBloc;
  static MainBloc mainBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._mainBloc;
  static MyProfileBloc myProfileBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._myProfileBloc;
  static SettingsBloc settingsBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._settingsBloc;
  static SignUpBloc signUpBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._signUpBloc;
  static StateBloc stateBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._stateBloc;
  static UpdatePasswordBloc updatePasswordBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._updatePasswordBloc;
  static UserNameBloc userNameBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._userNameBloc;
}
