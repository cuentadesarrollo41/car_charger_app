import 'package:flutter/scheduler.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Helpers.
import 'package:project/src/helpers/api/initial_data_runner.dart';

abstract class HelperInitialData {
  // Method that fetches the initial data (the own user, refreshed only when the cached one is old).
  static Future<Map<String, dynamic>> getData({ required StateBloc stateBloc }) => InitialDataRunner.runTagged(
    stateBloc: stateBloc,
    callGetAccount: true,
  );

  // Method that handles the get data response (the user is already saved in the session by the runner).
  static void handleGetDataResponse({ required void Function(bool) changeHasLoaded, required void Function() setState }) {
    changeHasLoaded(true);
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) => setState());
  }
}
