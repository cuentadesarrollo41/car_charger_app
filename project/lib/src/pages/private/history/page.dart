import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Commons.
import 'package:project/src/commons/constants/app_bar_modes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import './content.dart';
import 'package:project/src/widgets/generic/app_bar/app_bar_custom.dart';
import 'package:project/src/widgets/generic/containers/content_container_custom.dart';
import 'package:project/src/widgets/generic/containers/scaffold_custom.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late HistoryListBloc historyListBloc;

  late bool hasLoaded;

  @override
  void initState() {
    hasLoaded = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return ScaffoldCustom(
      appBar: AppBarCustom(
        appBarMode: AppBarModes.text,
        showMenu: false,
        title: AppLocalizations.of(context)!.translate('history'),
        onBackButtonClicked: _onBackButtonClicked
      ),
      showBackgroundLogo: false,
      createBody: _createContent
    );
  }

  // Method that initializes the variables.
  void _init() {
    historyListBloc = BlocProvider.historyListBloc(context);

    if (hasLoaded) {
      return;
    }

    historyListBloc.reset();
    hasLoaded = true;
  }

  // Method that creates the content: the fixed header and the list of charging sessions.
  Widget _createContent() => ContentContainerCustom(
    title: AppLocalizations.of(context)!.translate('charging_activity'),
    subtitle: AppLocalizations.of(context)!.translate('charging_activity_text'),
    isListView: false,
    child: StreamBuilder<DateTime>(
      stream: historyListBloc.refreshDateTimeStream,
      builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) => HistoryContent(refreshDateTime: historyListBloc.refreshDateTime)
    )
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the back button.
  void _onBackButtonClicked() => Navigator.pop(context);
}
