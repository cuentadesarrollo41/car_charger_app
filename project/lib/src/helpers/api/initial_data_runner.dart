// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Helpers.
import './initial_common_calls.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/utils/utils.dart';

class InitialDataRunner {
  static Future<Map<String, dynamic>> runTagged({
    required StateBloc stateBloc,
    bool callGetAccount = true,
    Map<String, Future<Map<String, dynamic>> Function()> callsByKey = const {},
    bool refreshAccount = false,
    bool checkConnection = true,
  }) async {
    if (checkConnection && !await Utils.deviceIsConnected()) {
      return {Fields.statusCode: Backend.codeNoConnection};
    }

    if (callsByKey.isEmpty && !callGetAccount) {
      return {Fields.statusCode: Backend.code200};
    }

    // Execute calls.
    final responses = <String, dynamic>{};
    Map<String, dynamic> response = {};

    if (callGetAccount) {
      response = await InitialCommonCalls.getUser(
        stateBloc,
        refreshAccount,
        checkConnection,
      );

      if (response[Fields.statusCode] != Backend.code200) {
        return response;
      }

      responses[Fields.user] = response;

      // Update account.
      stateBloc.session.user = response[Fields.item];
      stateBloc.session.updateUserLastDate = response[Fields.updateUserLastDate];
      stateBloc.updateSession(stateBloc.session);
    }

    final List<MapEntry<String, Future<Map<String, dynamic>> Function()>>
    entries = callsByKey.entries.toList();

    for (final entry in entries) {
      response = await entry.value();

      responses[entry.key] = response;

      if (response[Fields.statusCode] != Backend.code200) {
        return response;
      }
    }

    responses[Fields.statusCode] = Backend.code200;
    return responses;
  }

  // Save session data.
  static void applyUserFromTagged({required StateBloc stateBloc, required Map<String, dynamic> data }) {
    final userBlock = (data[Fields.user] as Map?)?.cast<String, dynamic>();

    if (userBlock == null) {
      return;
    }

    try {
      if (userBlock.containsKey(Fields.user)) {
        stateBloc.session.user = userBlock[Fields.user];
      }

      if (userBlock.containsKey(Fields.updateUserLastDate)) {
        stateBloc.session.updateUserLastDate =
            userBlock[Fields.updateUserLastDate];
      }

      stateBloc.updateSession(stateBloc.session);
    } catch (e) {
      /* Empty */
    }
  }
}

// Cast data.
extension TaggedDataX on Map<String, dynamic> {
  Map<String, dynamic>? box(String key) {
    final raw = this[key];

    return raw is Map ? raw.cast<String, dynamic>() : null;
  }
}
