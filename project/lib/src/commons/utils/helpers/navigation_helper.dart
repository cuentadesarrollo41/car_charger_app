import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/utils/page_transition.dart';

abstract class NavigationHelper {
  // Method used to navigate with push.
  static Future<dynamic> navigatorPush({ required BuildContext context, PageTransitionType type = PageTransitionType.rightToLeft, required Widget child, required String routeName }) {
    return Navigator.push(context, PageTransition(type: type, child: child, name: routeName));
  }

  // Method used to navigate with push and remove until.
  static Future<dynamic> navigatorPushAndRemoveUntil({ required BuildContext context, PageTransitionType type = PageTransitionType.rightToLeft, required Widget child, required String routeName }) {
    return Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        type: type,
        child: child,
        name: routeName
      ),
      (Route<dynamic> route) => false
    );
  }

  // Method used to navigate with pops until route name is reached.
  static void navigatorPopUntil({ required BuildContext context, required String routeName }) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }
}