import 'dart:io';

import 'package:flutter/material.dart';

// Config.
import 'package:project/src/config/index.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Services.
import 'package:project/src/services/wifi_service.dart';

// Helpers.
import './helper_permission_dialog.dart';

// Commons.
import 'package:project/src/commons/constants/states.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/constants/tabs.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

abstract class HelperWifi {
  // Method that checks the Wi-Fi permission and state and, if everything is ready, loads the networks and shows the select network tab.
  static Future<void> searchNetworks({ required BuildContext context }) async {
    final String permissionState = await PermissionsService.requestWifiPermission();

    if (!context.mounted) {
      return;
    }

    // iOS cannot scan, so the current network is read when possible and the user can always type a network name.
    if (Platform.isIOS) {
      await _loadNetworks(context);

      return;
    }

    if (permissionState != PermissionsStates.granted) {
      HelperPermissionDialog.show(
        context: context,
        textKey: 'error_wifi_permission_text',
        requestPermission: PermissionsService.requestWifiPermission,
        onGranted: () => _loadNetworks(context)
      );

      return;
    }

    await _loadNetworks(context);
  }

  // Method that opens the select network tab in loading state and loads the Wi-Fi networks of the device.
  static Future<void> _loadNetworks(BuildContext context) async {
    switch (await WifiService.getScanState()) {
      case States.wifiScanLocationOff:
        if (!context.mounted) {
          return;
        }

        return _showError(context, 'error_location_off', 'error_location_off_text');
      // The scan needs the precise location permission, so the explanation dialog asks for it again or opens the app settings.
      case States.wifiScanPermissionRequired:
        if (!context.mounted) {
          return;
        }

        return HelperPermissionDialog.show(
          context: context,
          textKey: 'error_wifi_permission_text',
          requestPermission: PermissionsService.requestWifiPermission,
          onGranted: () => _loadNetworks(context)
        );
    }

    if (!context.mounted) {
      return;
    }

    LinkChargerBloc linkChargerBloc = BlocProvider.linkChargerBloc(context);

    linkChargerBloc.changeSelectedNetworkSsid(Strings.emptyString);
    linkChargerBloc.changeIsOtherNetwork(false);
    linkChargerBloc.changeOtherNetworkName(Strings.emptyString);
    linkChargerBloc.changeNetworkPassword(Strings.emptyString);

    linkChargerBloc.changeIsLoadingNetworks(true);
    linkChargerBloc.changeNetworks([]);

    // The tab opens loading, so it never shows the networks of a previous search.
    linkChargerBloc.changeTab(Tabs.linkSelectNetwork);

    bool hasError = false;

    if (Platform.isIOS) {
      final String currentNetworkName = await WifiService.getCurrentNetworkName();

      linkChargerBloc.changeCurrentNetworkName(currentNetworkName);
    } else {
      try {
        linkChargerBloc.changeNetworks(await WifiService.scan());
      } catch (e) {
        hasError = true;
      }
    }

    linkChargerBloc.changeIsLoadingNetworks(false);

    if (!context.mounted) {
      return;
    }

    if (hasError) {
      _showError(context, 'error_generic', 'error_generic_text');
    }
  }

  // Method that shows an error dialog with the given title and text keys.
  static void _showError(BuildContext context, String titleKey, String textKey) => Utils.showAlertDialog(
    context: context,
    title: AppLocalizations.of(context)!.translate(titleKey),
    text: AppLocalizations.of(context)!.translate(textKey),
    positiveName: AppLocalizations.of(context)!.translate('ok'),
    negativeName: null,
    positiveAction: (BuildContext context) => Navigator.pop(context),
    negativeAction: null
  );
}
