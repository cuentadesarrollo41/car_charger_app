import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Services.
import 'package:project/src/services/history_service.dart';

// Helpers.
import 'package:project/src/helpers/api/action_helper.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/numbers.dart';

abstract class HelperGetChargingSessions {
  // Method that loads the next page of charging sessions and appends it to the list.
  static Future<void> getNextPage({ required BuildContext context, required void Function() onFinished }) {
    final HistoryListBloc historyListBloc = BlocProvider.historyListBloc(context);
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    return ActionHelper.exec(
      context: context,
      getLoadingText: () => historyListBloc.loadingText,
      setLoadingText: (String text) => historyListBloc.changeLoadingText(text),
      loadingTextStream: historyListBloc.loadingTextStream,
      loadingKey: 'loading',
      showDialog: false,
      call: () => HistoryService.getList(
        chargerId: stateBloc.session.selectedChargerId,
        page: historyListBloc.page + 1,
        limit: Numbers.defaultLimit25,
        language: stateBloc.session.languageCode,
        token: stateBloc.session.token
      ),
      onSuccess: (Map<String, dynamic> response) {
        historyListBloc.changePage(historyListBloc.page + 1);
        historyListBloc.changeCount(response[Fields.count]);
        historyListBloc.changeList([ ...historyListBloc.list, ...response[Fields.list] ]);
        onFinished();
      },
      onError: onFinished
    );
  }
}
