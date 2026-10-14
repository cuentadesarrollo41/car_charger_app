import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Helpers.
import './helpers/index.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import './components/index.dart';
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';
import 'package:project/src/widgets/generic/lines/line.dart';
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

  late bool hasLoaded;

  @override
  void initState() {
    hasLoaded = false;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    stateBloc = BlocProvider.stateBloc(context);
    historyBloc = BlocProvider.historyBloc(context);

    if (hasLoaded) {
      return;
    }

    historyBloc.reset();
    hasLoaded = true;
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<DateTime>(
    stream: historyBloc.refreshDateTimeStream,
    builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) => MainTabLayout(
      refreshDateTime: _getRefreshDateTime(),
      title: AppLocalizations.of(context)!.translate('tab_history_title'),
      subtitle: AppLocalizations.of(context)!.translate('tab_history_subtitle'),
      titleExtraWidget: ButtonHistoryPeriod(onClicked: _onPeriodButtonClicked),
      getData: () => HelperInitialData.getData(stateBloc: stateBloc, historyBloc: historyBloc),
      handleResponse: (Map<String, dynamic> data) => HelperInitialData.handleGetDataResponse(
        historyBloc: historyBloc,
        data: data,
        setState: () => setState(() {})
      ),
      createContent: _createContent,
      useSkeleton: true
    )
  );

  // Method that creates the content when there is a linked charger.
  Widget _createContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionEnergy(),

      _createLine(),
      const SizedBox(height: Sizes.margin18),

      const SectionLastCharges()
    ]
  );

  // Method that creates a line.
  Widget _createLine() => Line(
    height: Sizes.defaultBorderSize,
    width: double.infinity,
    color: CustomColors.backgroundLine,
    verticalMargin: Sizes.margin6
  );

  // Method that returns the refresh date of the tab: the most recent between the main one and the history one (period change).
  DateTime _getRefreshDateTime() => historyBloc.refreshDateTime.isAfter(widget.refreshDateTime) ? historyBloc.refreshDateTime : widget.refreshDateTime;

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the period button.
  void _onPeriodButtonClicked() => HelperHistoryPeriod.onPeriodButtonClicked(context: context);
}
