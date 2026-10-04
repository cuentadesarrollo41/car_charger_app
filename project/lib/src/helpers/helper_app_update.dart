import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Services.
import 'package:project/src/services/app_version_service.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

abstract class HelperAppUpdate {
  // Method that checks if the app needs an update. Returns true if outdated (dialog shown).
  static Future<bool> checkIsOutdated({ required BuildContext context }) async {
    if (!kReleaseMode || dotenv.env[Fields.checkLatestVersionUnderscore] != Strings.stringTrue) {
      return false;
    }

    try {
      return Platform.isIOS
        ? await _checkIOS(context)
        : await _checkAndroid(context);
    } catch (e) {
      return false;
    }
  }

  // Method that checks for updates on iOS via iTunes Lookup.
  static Future<bool> _checkIOS(BuildContext context) async {
    final Map<String, dynamic> response = await AppVersionService.getLatestVersion();

    if (response[Fields.statusCode] != Backend.code200) {
      return false;
    }

    final String? latestVersion = response[Fields.version];
    final String? storeUrl = response[Fields.url];

    if (latestVersion == null || storeUrl == null) {
      return false;
    }

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (!_checkCurrentOutdated(packageInfo.version, latestVersion)) {
      return false;
    }

    if (!context.mounted) {
      return true;
    }

    _showUpdateDialog(context, storeUrl);
    return true;
  }

  // Method that checks for updates on Android via Google Play In-App Update API.
  static Future<bool> _checkAndroid(BuildContext context) async {
    final AppUpdateInfo info = await InAppUpdate.checkForUpdate();

    if (info.updateAvailability != UpdateAvailability.updateAvailable) {
      return false;
    }

    await InAppUpdate.performImmediateUpdate();
    return true;
  }

  // Returns true if current version is older than the latest.
  static bool _checkCurrentOutdated(String current, String latest) {
    try {
      final List<int> currentParts = current.split(Strings.dot).map(int.parse).toList();
      final List<int> latestParts = latest.split(Strings.dot).map(int.parse).toList();

      for (int i = 0; i < latestParts.length; i++) {
        final int c = i < currentParts.length ? currentParts[i] : 0;
        if (c < latestParts[i]) return true;
        if (c > latestParts[i]) return false;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Method that shows the non-dismissable update dialog.
  static void _showUpdateDialog(BuildContext context, String storeUrl) => Utils.showAlertDialog(
    context: context,
    title: AppLocalizations.of(context)!.translate('app_update_title'),
    text: AppLocalizations.of(context)!.translate('app_update_text'),
    positiveName: AppLocalizations.of(context)!.translate('app_update_confirm'),
    negativeName: null,
    positiveAction: (BuildContext auxContext) => Utils.loadUrl(url: storeUrl),
    negativeAction: null,
  );
}