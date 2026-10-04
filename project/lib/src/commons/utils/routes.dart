import 'package:flutter/material.dart';

// Pages.
import 'package:project/src/pages/index.dart';

class Routes {
  static const String login = 'login';
  static const String main = 'main';
  static const String splash = 'splash';

  static Map<String, Widget Function(BuildContext)> getRoutes() => {
    login: (BuildContext context) => const LoginPage(),
    main: (BuildContext context) => const MainPage(),
    splash: (BuildContext context) => const SplashPage(),
  };
}