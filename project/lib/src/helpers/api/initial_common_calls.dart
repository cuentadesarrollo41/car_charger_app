import 'package:project/src/bloc/state_bloc.dart';

// Services.
import 'package:project/src/services/user_service.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/utils/utils.dart';

abstract class InitialCommonCalls {
  static Future<Map<String, dynamic>> getUser(StateBloc stateBloc, bool refresh, bool checkConnection) async {
    final bool isConnected = await Utils.deviceIsConnected();

    if (checkConnection && !isConnected) {
      return { Fields.statusCode: Backend.codeNoConnection };
    }

    return isConnected && (refresh || stateBloc.session.allowRefresh())
      ? UserService.getOwnUser(
        token: stateBloc.session.token,
        language: stateBloc.session.languageCode,
      )
      : {
        Fields.statusCode: Backend.code200,
        Fields.item: stateBloc.session.user,
        Fields.updateUserLastDate: stateBloc.session.updateUserLastDate,
      };
  }
}
