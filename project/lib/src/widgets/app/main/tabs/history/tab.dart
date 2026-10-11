import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Helpers.
import './helpers/index.dart';

// Commons.
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';
import 'package:project/src/widgets/app/main/common/main_tab_layout.dart';

class TabHistory extends RefreshableWidget {
  const TabHistory({
    required super.refreshDateTime,
    super.key
  });

  @override
  State<TabHistory> createState() => _TabHistoryState();
}

class _TabHistoryState extends State<TabHistory> {
  late StateBloc stateBloc;
  late HistoryBloc historyBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    stateBloc = BlocProvider.stateBloc(context);
    historyBloc = BlocProvider.historyBloc(context);
  }

  @override
  Widget build(BuildContext context) => MainTabLayout(
    refreshDateTime: widget.refreshDateTime,
    title: AppLocalizations.of(context)!.translate('tab_history_title'),
    subtitle: AppLocalizations.of(context)!.translate('tab_history_subtitle'),
    getData: () => HelperInitialData.getData(stateBloc: stateBloc, historyBloc: historyBloc),
    handleResponse: (Map<String, dynamic> data) => HelperInitialData.handleGetDataResponse(
      historyBloc: historyBloc,
      data: data,
      setState: () => setState(() {})
    ),
    createContent: _createContent,
    useSkeleton: true
  );

  // Method that creates the content when there is a linked charger.
  Widget _createContent() => Container();
}
