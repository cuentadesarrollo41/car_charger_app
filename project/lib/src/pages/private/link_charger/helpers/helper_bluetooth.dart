import 'package:flutter/material.dart';

// Config.
import 'package:project/src/config/index.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Services.
import 'package:project/src/services/ble_service.dart';

// Helpers.
import './helper_permission_dialog.dart';

// Commons.
import 'package:project/src/commons/constants/tabs.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import 'package:project/src/widgets/app/link_charger/tabs/select_charger/helpers/index.dart';

abstract class HelperBluetooth {
  // Method that checks the Bluetooth permission and state and, if everything is ready, searches the chargers and shows the select charger tab.
  static Future<void> searchChargers({ required BuildContext context }) async {
    final String permissionState = await PermissionsService.requestBluetoothPermission();

    if (!context.mounted) {
      return;
    }

    if (permissionState != PermissionsStates.granted) {
      HelperPermissionDialog.show(
        context: context,
        textKey: 'error_bluetooth_permission_text',
        requestPermission: PermissionsService.requestBluetoothPermission,
        onGranted: () => _checkBluetooth(context)
      );

      return;
    }

    await _checkBluetooth(context);
  }

  // Method that checks that Bluetooth is supported and turned on before moving to the select charger tab.
  static Future<void> _checkBluetooth(BuildContext context) async {
    if (!await BleService.isSupported()) {
      if (!context.mounted) {
        return;
      }

      return _showError(context, 'error_bluetooth_not_supported', 'error_bluetooth_not_supported_text');
    }

    if (!await BleService.isOn()) {
      await BleService.turnOn();

      if (!await BleService.isOn()) {
        if (!context.mounted) {
          return;
        }

        return _showError(context, 'error_bluetooth_off', 'error_bluetooth_off_text');
      }
    }

    if (!context.mounted) {
      return;
    }

    // The search is started before moving, so the tab opens directly in the searching state.
    HelperSearchChargers.search(context: context);

    BlocProvider.linkChargerBloc(context).changeTab(Tabs.linkSelectCharger);
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
