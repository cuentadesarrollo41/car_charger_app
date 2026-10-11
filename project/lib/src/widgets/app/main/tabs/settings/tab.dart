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

class TabSettings extends RefreshableWidget {
  const TabSettings({
    required super.refreshDateTime,
    super.key
  });

  @override
  State<TabSettings> createState() => _TabSettingsState();
}

class _TabSettingsState extends State<TabSettings> {
  late StateBloc stateBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    stateBloc = BlocProvider.stateBloc(context);
  }

  @override
  Widget build(BuildContext context) => MainTabLayout(
    refreshDateTime: widget.refreshDateTime,
    title: AppLocalizations.of(context)!.translate('tab_settings_title'),
    subtitle: AppLocalizations.of(context)!.translate('tab_settings_subtitle'),
    getData: () => HelperInitialData.getData(stateBloc: stateBloc),
    handleResponse: (Map<String, dynamic> data) => HelperInitialData.handleGetDataResponse(
      stateBloc: stateBloc,
      data: data,
      setState: () => setState(() {})
    ),
    createContent: _createContent,
    useSkeleton: true
  );

  // Method that creates the content when there is a linked charger.
  Widget _createContent() => Container();
}
