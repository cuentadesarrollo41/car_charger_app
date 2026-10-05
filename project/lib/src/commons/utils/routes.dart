import 'package:flutter/material.dart';

// Pages.
import 'package:project/src/pages/index.dart';

class Routes {
  static const String forgotPassword = 'forgotPassword';
  static const String login = 'login';
  static const String main = 'main';
  static const String signUp = 'signUp';
  static const String splash = 'splash';

  static Map<String, Widget Function(BuildContext)> getRoutes() => {
    forgotPassword: (BuildContext context) => const ForgotPasswordPage(),
    login: (BuildContext context) => const LoginPage(),
    main: (BuildContext context) => const MainPage(),
    signUp: (BuildContext context) => const SignUpPage(),
    splash: (BuildContext context) => const SplashPage(),
  };
}