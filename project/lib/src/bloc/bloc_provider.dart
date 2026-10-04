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
  final LoginBloc _loginBloc = LoginBloc();
  final MainBloc _mainBloc = MainBloc();
  final SignUpBloc _signUpBloc = SignUpBloc();
  final StateBloc _stateBloc = StateBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ForgotPasswordBloc forgotPasswordBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._forgotPasswordBloc;
  static LoginBloc loginBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._loginBloc;
  static MainBloc mainBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._mainBloc;
  static SignUpBloc signUpBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._signUpBloc;
  static StateBloc stateBloc(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BlocProvider>()!._stateBloc;
}
