import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Helpers.
import './helpers/index.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import './components/index.dart';
import 'package:project/src/widgets/generic/clickables/buttons/colored/button_colored_red.dart';
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
  late SettingsBloc settingsBloc;

  late ScreenPropertiesModel screenProperties;

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
    settingsBloc = BlocProvider.settingsBloc(context);
    screenProperties = ScreenPropertiesModel(context: context);

    if (hasLoaded) {
      return;
    }

    settingsBloc.reset();
    settingsBloc.fillFromCharger(stateBloc.session.selectedCharger);
    hasLoaded = true;
  }

  @override
  Widget build(BuildContext context) => MainTabLayout(
    refreshDateTime: widget.refreshDateTime,
    title: AppLocalizations.of(context)!.translate('tab_settings_title'),
    subtitle: AppLocalizations.of(context)!.translate('tab_settings_subtitle'),
    getData: () => HelperInitialData.getData(stateBloc: stateBloc),
    handleResponse: (Map<String, dynamic> data) => HelperInitialData.handleGetDataResponse(
      stateBloc: stateBloc,
      settingsBloc: settingsBloc,
      data: data,
      setState: () => setState(() {})
    ),
    createContent: _createContent,
    useSkeleton: true,
    scrollHeader: true
  );

  // Method that creates the content when there is a linked charger.
  Widget _createContent() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Sizes.margin16,
    children: [
      const SectionChargerName(),
      const SectionCurrentLimit(),
      const SectionConnectivity(),

      _createUnlinkButton()
    ]
  );

  // Method that creates the unlink button.
  Widget _createUnlinkButton() => ButtonColoredRed(
    text: AppLocalizations.of(context)!.translate('charger_unlink'),
    fontSize: screenProperties.fontExtraSmall,
    mainAxisSize: MainAxisSize.max,
    onClicked: _onUnlinkButtonClicked
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the unlink button.
  void _onUnlinkButtonClicked() => HelperUnlinkCharger.onUnlinkButtonClicked(context: context);
}
