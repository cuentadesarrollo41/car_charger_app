import 'package:flutter/scheduler.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Services.
import 'package:project/src/services/history_service.dart';

// Helpers.
import 'package:project/src/helpers/api/initial_data_runner.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';

abstract class HelperInitialData {
  // Method that fetches the initial data (the history of the selected period, only if there is a charger linked).
  static Future<Map<String, dynamic>> getData({ required StateBloc stateBloc, required HistoryBloc historyBloc }) {
    final bool hasCharger = stateBloc.session.selectedChargerId.isNotEmpty;

    return InitialDataRunner.runTagged(
      stateBloc: stateBloc,
      checkConnection: hasCharger,
      callsByKey: hasCharger
        ? { Fields.history: () => _getHistory(stateBloc, historyBloc) }
        : {}
    );
  }

  // Method that handles the get data response: saves the energy list and the charging sessions in the bloc.
  static void handleGetDataResponse({ required HistoryBloc historyBloc, required Map<String, dynamic> data, required void Function() setState }) {
    try {
      historyBloc.changeEnergyList(data[Fields.history][Fields.energyList]);
      historyBloc.changeList(data[Fields.history][Fields.list]);
    } catch(e) { /* Empty */ }

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) => setState());
  }

  // ***************************************************************************
  // Pure API calls.
  // ***************************************************************************
  // Method that fetches the history data from the API.
  static Future<Map<String, dynamic>> _getHistory(StateBloc stateBloc, HistoryBloc historyBloc) => HistoryService.getData(
    chargerId: stateBloc.session.selectedChargerId,
    historyPeriod: historyBloc.historyPeriod,
    language: stateBloc.session.languageCode,
    token: stateBloc.session.token
  );
}
