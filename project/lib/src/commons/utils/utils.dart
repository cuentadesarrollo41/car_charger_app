import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Helpers.
import './helpers/index.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/page_transition.dart';

abstract class Utils {
  // ***************************************************************************
  // Dialog.
  // ***************************************************************************
  static void showAlertDialog({ required BuildContext context, required String? title, required String? text, required String positiveName, String? negativeName, required dynamic positiveAction, required dynamic negativeAction }) => DialogHelper.showAlertDialog(context: context, title: title, text: text, positiveName: positiveName, negativeName: negativeName, positiveAction: positiveAction, negativeAction: negativeAction);
  static void showProgressBarAlertDialog({ required BuildContext context, required Stream stream, Color color = CustomColors.lime }) => DialogHelper.showProgressBarAlertDialog(context: context, stream: stream, color: color);
  static dynamic showModalBottomSheetCustom({ required BuildContext context, required Widget child }) async => DialogHelper.showModalBottomSheetCustom(context: context, child: child);
  static Future<void> showSnackBar({ required BuildContext context, required String text, required void Function()? onDismiss }) => DialogHelper.showSnackBar(context: context, text: text, onDismiss: onDismiss);

  // ***************************************************************************
  // Connectivity.
  // ***************************************************************************
  static Future<bool> deviceIsConnected() async => ConnectivityHelper.deviceIsConnected();

  // ***************************************************************************
  // Data operations.
  // ***************************************************************************
  static String capitalize({ required String text }) => DataOperationsHelper.capitalize(text: text);

  // ***************************************************************************
  // Loaders.
  // ***************************************************************************
  static void loadUrl({ required String url, LaunchMode mode = LaunchMode.platformDefault }) async => LoadersHelper.loadUrl(url: url, mode: mode);

  // ***************************************************************************
  // Image.
  // ***************************************************************************
  static Future<Uint8List> getBytesFromAsset({ required String path, int? width }) async => ImageHelper.getBytesFromAsset(path: path, width: width);
  static Future<Uint8List> getBytesFromImageBytes({ required List<int> bytes, required int width }) async => ImageHelper.getBytesFromImageBytes(bytes: bytes, width: width);

  // ***************************************************************************
  // Date.
  // ***************************************************************************
  static String getStringFromDate({ required DateTime date, bool reverse = true, bool onlyDate = false, bool onlyTime = false, bool showSeconds = true, String separator = Strings.hyphen, String separatorDateMin = Strings.separatorDateMinutes }) => DateHelper.getStringFromDate(date: date, reverse: reverse, onlyDate: onlyDate, onlyTime: onlyTime, showSeconds: showSeconds,separator: separator, separatorDateMin: separatorDateMin);
  static String getFormattedStringFromDate({ required BuildContext context, required DateTime date, bool showTime = false }) => DateHelper.getFormattedStringFromDate(context: context, date: date, showTime: showTime);
  static String getFormattedStringFromDateAndTime({ required BuildContext context, required DateTime date }) => DateHelper.getFormattedStringFromDateAndTime(context: context, date: date);
  static String getFormattedStringFromDateWithText({ required BuildContext context, required String language, required DateTime date, String referenceTextKey = 'date_presentation', bool monthAsText = true }) => DateHelper.getFormattedStringFromDateWithText(context: context, language: language, date: date, referenceTextKey: referenceTextKey, monthAsText: monthAsText);
  static String getLocalizedTimeString({ required String time, required String language }) => DateHelper.getLocalizedTimeString(time: time, language: language);

  // ***************************************************************************
  // Screen.
  // ***************************************************************************
  static bool screenIsPhone({ required BuildContext context}) => ScreenHelper.screenIsPhone(context: context);
  static bool screenIsTablet({ required BuildContext context}) => ScreenHelper.screenIsTablet(context: context);
  static bool screenIsMonitor({ required BuildContext context}) => ScreenHelper.screenIsMonitor(context: context);
  static bool screenHasHamburgerMenu({ required BuildContext context}) => ScreenHelper.screenHasHamburgerMenu(context: context);

  // ***************************************************************************
  // Navigation.
  // ***************************************************************************
  static Future<dynamic> navigatorPush({ required BuildContext context, PageTransitionType type = PageTransitionType.rightToLeft, required Widget child, required String routeName }) => NavigationHelper.navigatorPush(context: context, type: type, child: child, routeName: routeName);
  static Future<dynamic> navigatorPushAndRemoveUntil({ required BuildContext context, PageTransitionType type = PageTransitionType.rightToLeft, required Widget child, required String routeName }) => NavigationHelper.navigatorPushAndRemoveUntil(context: context, type: type, child: child, routeName: routeName);
  static void navigatorPopUntil({ required BuildContext context, required String routeName }) => NavigationHelper.navigatorPopUntil(context: context, routeName: routeName);

  // ***************************************************************************
  // User.
  // ***************************************************************************
  static void logout({ required BuildContext context }) async => UserHelper.logout(context: context);
  static void startSession({ required BuildContext context, required String token }) => UserHelper.startSession(context: context, token: token);
  static bool userIsAuthenticated() => UserHelper.userIsAuthenticated();
  static bool passwordIsValid({ required String password }) => UserHelper.passwordIsValid(password: password);

  // ***************************************************************************
  // Bottom sheet.
  // ***************************************************************************
  static Future<void> showCustomModalBottomSheet({ required BuildContext context, required Widget bottomSheet, void Function(Map<String, dynamic> response)? onSuccess, void Function()? onCancel }) => BottomSheetHelper.showCustomModalBottomSheet(context: context, bottomSheet: bottomSheet, onSuccess: onSuccess, onCancel: onCancel);

  // ***************************************************************************
  // Focus.
  // ***************************************************************************
  static void disposeFocusNodes({ required Iterable<FocusNode> focusNodes }) => FocusHelper.disposeFocusNodes(focusNodes: focusNodes);
  static void unfocus() => FocusHelper.unfocus();
}