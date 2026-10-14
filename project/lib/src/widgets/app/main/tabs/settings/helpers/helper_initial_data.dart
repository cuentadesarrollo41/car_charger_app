import 'package:flutter/scheduler.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Services.
import 'package:project/src/services/charge_point_service.dart';

// Helpers.
import 'package:project/src/helpers/api/initial_data_runner.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';

abstract class HelperInitialData {
  // Method that fetches the initial data (the selected charger, only if there is one linked and the cached one is old).
  static Future<Map<String, dynamic>> getData({ required StateBloc stateBloc }) {
    final bool refreshCharger = stateBloc.session.selectedChargerId.isNotEmpty && stateBloc.session.allowRefreshCharger();

    return InitialDataRunner.runTagged(
      stateBloc: stateBloc,
      checkConnection: refreshCharger,
      callsByKey: refreshCharger
        ? { Fields.charger: () => _getCharger(stateBloc) }
        : {}
    );
  }

  // Method that handles the get data response: replaces the charger in the session's list with the one received.
  static void handleGetDataResponse({ required StateBloc stateBloc, required SettingsBloc settingsBloc, required Map<String, dynamic> data, required void Function() setState }) {
    try {
      stateBloc.session.updateCharger(data[Fields.charger][Fields.item]);
      stateBloc.updateSession(stateBloc.session);
    } catch(e) { /* Empty */ }

    settingsBloc.fillFromCharger(stateBloc.session.selectedCharger);

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) => setState());
  }

  // ***************************************************************************
  // Pure API calls.
  // ***************************************************************************
  // Method that fetches the charger data from the API.
  static Future<Map<String, dynamic>> _getCharger(StateBloc stateBloc) async => ChargePointService.getOne(
    id: stateBloc.session.selectedChargerId,
    language: stateBloc.session.languageCode,
    token: stateBloc.session.token
  );
}
