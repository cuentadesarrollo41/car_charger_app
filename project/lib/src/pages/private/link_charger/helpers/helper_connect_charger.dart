import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/charger_model.dart';
import 'package:project/src/models/link_charger/bluetooth_charger_model.dart';

// Services.
import 'package:project/src/services/charge_point_service.dart';

// Helpers.
import 'package:project/src/helpers/api/action_helper.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/tabs.dart';

abstract class HelperConnectCharger {
  // Method that registers the charger in the backend and then configures it through Bluetooth, showing the connecting tab meanwhile.
  static void connect({ required BuildContext context }) {
    final LinkChargerBloc linkChargerBloc = BlocProvider.linkChargerBloc(context);
    final StateBloc stateBloc = BlocProvider.stateBloc(context);
    final BluetoothChargerModel? charger = linkChargerBloc.selectedCharger;

    if (charger == null) {
      return;
    }

    linkChargerBloc.changeTab(Tabs.linkConnecting);

    ActionHelper.exec(
      context: context,
      getLoadingText: () => linkChargerBloc.loadingText,
      setLoadingText: linkChargerBloc.changeLoadingText,
      loadingTextStream: linkChargerBloc.loadingTextStream,
      loadingKey: 'connecting',
      showDialog: false,
      call: () => ChargePointService.create(
        serialNumber: charger.serialNumber,
        networkName: linkChargerBloc.networkSsid,
        language: stateBloc.session.languageCode,
        token: stateBloc.session.token
      ),
      onSuccess: (Map<String, dynamic> response) {
        linkChargerBloc.changeLinkedCharger(response[Fields.item]);
        linkChargerBloc.changeChargerProvisioning(response[Fields.provisioning]);
        _configureCharger(context: context);
      },
      onError: () => linkChargerBloc.changeTab(Tabs.linkSelectNetwork)
    );
  }

  // Method that finishes the link flow: closes the page and shows the Home tab, refreshing the main tabs so they show the new charger.
  static void finish({ required BuildContext context }) {
    final MainBloc mainBloc = BlocProvider.mainBloc(context);

    Navigator.pop(context);

    mainBloc.changeRefreshDateTime(DateTime.now());
    mainBloc.changeTab(Tabs.home);
  }

  // Method that configures the charger through Bluetooth with the registered charger data and the Wi-Fi credentials.
  // TODO: pending steps: 1) connect to selectedCharger.device; 2) subscribe to the charger response characteristic;
  // 3) write the configuration: chargerProvisioning (authorizationKey, ocppHost, ocppPort, ocppPath) + networkSsid + networkPassword (message format pending);
  // 4) wait for the charger result with a timeout; 5) disconnect;
  // 6) on success call _onChargerConfigured, on error show the message and go back to Tabs.linkSelectNetwork.
  // The Bluetooth connection is not used yet: its license for commercial use is pending a decision.
  static Future<void> _configureCharger({ required BuildContext context }) async {
    if (context.mounted) {
      _onChargerConfigured(context: context);
    }
  }

  // Method that finishes the link: saves the registered charger in the session as the selected one and shows the connected tab.
  static void _onChargerConfigured({ required BuildContext context }) {
    final StateBloc stateBloc = BlocProvider.stateBloc(context);
    final LinkChargerBloc linkChargerBloc = BlocProvider.linkChargerBloc(context);
    final ChargerModel charger = linkChargerBloc.linkedCharger;

    final int index = stateBloc.session.user.chargers.indexWhere((ChargerModel element) => element.id == charger.id);

    if (index == -1) {
      stateBloc.session.user.chargers.add(charger);
    } else {
      stateBloc.session.user.chargers[index] = charger;
    }

    stateBloc.session.selectedChargerId = charger.id;
    stateBloc.session.updateChargerLastDate = DateTime.now(); // The charger data has just come from the backend.
    stateBloc.updateSession(stateBloc.session);

    linkChargerBloc.changeTab(Tabs.linkConnected);
  }
}
