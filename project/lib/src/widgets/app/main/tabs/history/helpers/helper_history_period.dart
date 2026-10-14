import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Commons.
import 'package:project/src/commons/constants/history_periods.dart';
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import '../components/index.dart';

abstract class HelperHistoryPeriod {
  // Method that is called when the user clicks the period button: shows the period options.
  static void onPeriodButtonClicked({ required BuildContext context }) => Utils.showModalBottomSheetCustom(
    context: context,
    bottomSheet: ModalBottomSheetHistoryPeriod(
      selectedPeriod: BlocProvider.historyBloc(context).historyPeriod,
      onPeriodSelected: (String period) => _onPeriodSelected(context: context, period: period)
    )
  );

  // Method that is called when a period is selected: closes the sheet and reloads the tab with the new period.
  static void _onPeriodSelected({ required BuildContext context, required String period }) {
    final HistoryBloc historyBloc = BlocProvider.historyBloc(context);

    Navigator.pop(context);

    if (period == historyBloc.historyPeriod) {
      return;
    }

    historyBloc.changeHistoryPeriod(period);
    historyBloc.changeEnergyList([]);
    historyBloc.changeList([]);
    historyBloc.changeRefreshDateTime(DateTime.now());
  }

  // Method that returns the translation key of a period.
  static String getPeriodKey(String period) {
    switch (period) {
      case HistoryPeriods.month: return 'period_month';
      case HistoryPeriods.year: return 'period_year';
      default: return 'period_week';
    }
  }
}
