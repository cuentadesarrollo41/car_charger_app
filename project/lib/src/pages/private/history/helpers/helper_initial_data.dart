import 'package:flutter/scheduler.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Services.
import 'package:project/src/services/history_service.dart';

// Helpers.
import 'package:project/src/helpers/api/initial_data_runner.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/numbers.dart';

abstract class HelperInitialData {
  // Method that fetches the initial data (the first page of the charging sessions, only if there is a charger linked).
  static Future<Map<String, dynamic>> getData({ required StateBloc stateBloc, required HistoryListBloc historyListBloc }) {
    final bool hasCharger = stateBloc.session.selectedChargerId.isNotEmpty;

    return InitialDataRunner.runTagged(
      stateBloc: stateBloc,
      checkConnection: hasCharger,
      callsByKey: hasCharger
        ? { Fields.list: () => HistoryService.getList(chargerId: stateBloc.session.selectedChargerId, page: Numbers.firstPage, limit: Numbers.defaultLimit25, language: stateBloc.session.languageCode, token: stateBloc.session.token) }
        : {}
    );
  }

  // Method that handles the get data response: saves the charging sessions in the bloc.
  static void handleGetDataResponse({ required HistoryListBloc historyListBloc, required Map<String, dynamic> data, required void Function(bool) changeHasLoaded, required void Function() setState }) {
    changeHasLoaded(true);

    try {
      historyListBloc.changePage(Numbers.firstPage);
      historyListBloc.changeCount(data[Fields.list][Fields.count]);
      historyListBloc.changeList(data[Fields.list][Fields.list]);
    } catch(e) { /* Empty */ }

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) => setState());
  }
}
