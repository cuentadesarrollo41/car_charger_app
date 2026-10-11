import 'package:flutter/scheduler.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Helpers.
import 'package:project/src/helpers/api/initial_data_runner.dart';

abstract class HelperInitialData {
  // Method that fetches the initial data (always refreshes the own user, with its chargers).
  static Future<Map<String, dynamic>> getData({ required StateBloc stateBloc }) => InitialDataRunner.runTagged(
    stateBloc: stateBloc,
    callGetAccount: true,
    refreshAccount: true
  );

  // Method that handles the get data response (the user and the selected charger are already saved in the session by the runner).
  static void handleGetDataResponse({ required Map<String, dynamic> data, required void Function() setState }) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) => setState());
  }
}
