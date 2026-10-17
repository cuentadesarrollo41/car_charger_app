import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/link_charger/bluetooth_charger_model.dart';

// Services.
import 'package:project/src/services/ble_service.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

abstract class HelperSearchChargers {
  // Method that searches the chargers near the device, showing the searching state while the scan runs.
  static Future<void> search({ required BuildContext context }) async {
    final LinkChargerBloc linkChargerBloc = BlocProvider.linkChargerBloc(context);

    if (linkChargerBloc.isSearching) {
      return;
    }

    linkChargerBloc.changeIsSearching(true);
    linkChargerBloc.changeChargers([]);
    linkChargerBloc.changeSelectedChargerId(Strings.emptyString);

    bool hasError = false;
    List<BluetoothChargerModel> chargers = [];

    try {
      chargers = await BleService.scan(namePrefix: Strings.chargerBluetoothPrefix);
    } catch (e) {
      hasError = true;
    }

    linkChargerBloc.changeChargers(chargers);
    linkChargerBloc.changeIsSearching(false);

    if (!hasError) {
      return;
    }

    final bool isBluetoothOn = await BleService.isOn();

    if (!context.mounted) {
      return;
    }

    if (!isBluetoothOn) {
      return _showError(context, 'error_bluetooth_off', 'error_bluetooth_off_text');
    }

    _showError(context, 'error_generic', 'error_generic_text');
  }

  // Method that shows an error dialog with the given title and text keys.
  static void _showError(BuildContext context, String titleKey, String textKey) => Utils.showAlertDialog(
    context: context,
    title: AppLocalizations.of(context)!.translate(titleKey),
    text: AppLocalizations.of(context)!.translate(textKey),
    positiveName: AppLocalizations.of(context)!.translate('ok'),
    negativeName: null,
    positiveAction: (BuildContext dialogContext) => Navigator.pop(dialogContext),
    negativeAction: null
  );
}
