import 'package:flutter/material.dart';

// Pages.
import 'package:project/src/pages/index.dart';

class Routes {
  static const String editPassword = 'editPassword';
  static const String editUserName = 'editUserName';
  static const String forgotPassword = 'forgotPassword';
  static const String login = 'login';
  static const String main = 'main';
  static const String myProfile = 'myProfile';
  static const String signUp = 'signUp';
  static const String splash = 'splash';

  static Map<String, Widget Function(BuildContext)> getRoutes() => {
    editPassword: (BuildContext context) => const EditPasswordPage(),
    editUserName: (BuildContext context) => const EditUserNamePage(),
    forgotPassword: (BuildContext context) => const ForgotPasswordPage(),
    login: (BuildContext context) => const LoginPage(),
    main: (BuildContext context) => const MainPage(),
    myProfile: (BuildContext context) => const MyProfilePage(),
    signUp: (BuildContext context) => const SignUpPage(),
    splash: (BuildContext context) => const SplashPage(),
  };
}