import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Services.
import 'package:project/src/services/ble_service.dart';

// Helpers.
import './helpers/index.dart';

// Commons.
import 'package:project/src/commons/constants/app_bar_modes.dart';
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/constants/tabs.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/app/link_charger/tabs/index.dart';
import 'package:project/src/widgets/generic/app_bar/app_bar_custom.dart';
import 'package:project/src/widgets/generic/clickables/buttons/button_custom.dart';
import 'package:project/src/widgets/generic/clickables/buttons/colored/button_colored_ghost.dart';
import 'package:project/src/widgets/generic/containers/scaffold_custom.dart';
import 'package:project/src/widgets/generic/loaders/progress_line_custom.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class LinkChargerPage extends StatefulWidget {
  const LinkChargerPage({
    super.key
  });

  @override
  State<LinkChargerPage> createState() => _LinkChargerPageState();
}

class _LinkChargerPageState extends State<LinkChargerPage> with SingleTickerProviderStateMixin {
  late LinkChargerBloc linkChargerBloc;

  late ScreenPropertiesModel screenProperties;

  late bool hasLoaded;

  late GlobalKey<ScaffoldState> scaffoldKey;

  late StreamSubscription<int>? changeTabSubscription;

  late TabController tabController;

  @override
  void initState() {
    hasLoaded = false;

    tabController = TabController(length: Tabs.linkTabs.length, vsync: this, initialIndex: Tabs.linkStart);
    scaffoldKey = GlobalKey<ScaffoldState>();

    super.initState();
  }

  @override
  void dispose() {
    changeTabSubscription?.cancel();
    tabController.dispose();
    BleService.stopScan();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: StreamBuilder<void>(
        stream: linkChargerBloc.pageChangesStream,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) => ScaffoldCustom(
          scaffoldKey: scaffoldKey,
          appBar: linkChargerBloc.tab == Tabs.linkConnected
            ? null
            : AppBarCustom(
              scaffoldKey: scaffoldKey,
              appBarMode: AppBarModes.text,
              showMenu: false,
              title: AppLocalizations.of(context)!.translate(_getTitleKey()),
              onBackButtonClicked: _onBackButtonClicked
            ),
          contentIsList: false,
          showBackgroundLogo: false,
          safeBottom: true,
          createBody: _createContent
        )
      )
    );
  }

  // Method that initializes the variables.
  void _init() {
    linkChargerBloc = BlocProvider.linkChargerBloc(context);
    screenProperties = ScreenPropertiesModel(context: context);

    if (hasLoaded) {
      return;
    }

    linkChargerBloc.reset();
    hasLoaded = true;

    // Subscriptions.
    // -- Subscribe to tab change event.
    changeTabSubscription = linkChargerBloc.tabStream.listen((int tab) {
      tabController.animateTo(
        tab,
        duration: const Duration(milliseconds: Numbers.delayScroll),
        curve: Curves.decelerate
      );
    });

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) => setState(() {}));
  }

  // Method that creates the content: the progress line, the tabs and the bottom buttons.
  Widget _createContent() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (linkChargerBloc.tab != Tabs.linkConnected) _createProgressLine(),
      if (_showStep()) _createStep(),

      Expanded(
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: const [
            TabLinkChargerStart(),
            TabLinkChargerSelectCharger(),
            TabLinkChargerSelectNetwork(),
            TabLinkChargerConnecting(),
            TabLinkChargerConnected()
          ]
        )
      ),

      _createButtons()
    ]
  );

  // Method that creates the progress line below the app bar.
  Widget _createProgressLine() => Padding(
    padding: EdgeInsets.only(
      left: screenProperties.paddingCardHorizontal,
      top: Sizes.margin8,
      right: screenProperties.paddingCardHorizontal
    ),
    child: ProgressLineCustom(value: (linkChargerBloc.tab + 1) / Tabs.linkTabs.length)
  );

  // Method that creates the step label ("PASO X DE 4") below the progress line.
  Widget _createStep() => Padding(
    padding: EdgeInsets.only(
      left: screenProperties.paddingCardHorizontal,
      top: Sizes.margin20,
      right: screenProperties.paddingCardHorizontal,
      bottom: Sizes.margin8
    ),
    child: TextInter(
      text: AppLocalizations.of(context)!.translate('charger_link_step')
        .replaceFirst(Strings.replaceCode, (Tabs.linkStepTabs.indexOf(linkChargerBloc.tab) + 1).toString())
        .replaceFirst(Strings.replaceCode, Tabs.linkStepTabs.length.toString())
        .toUpperCase(),
      fontSize: screenProperties.fontSmallest,
      fontWeight: FontWeight.w700,
      color: CustomColors.lime
    )
  );

  // Method that checks whether the select charger tab is searching for chargers.
  bool _isSearching() => linkChargerBloc.tab == Tabs.linkSelectCharger && linkChargerBloc.isSearching;

  // Method that returns the key of the app bar title of the current tab.
  String _getTitleKey() => _isSearching() ? 'searching' : Tabs.linkTabsKeys[linkChargerBloc.tab];

  // Method that checks whether the step label must be shown for the current tab.
  bool _showStep() => Tabs.linkStepTabs.contains(linkChargerBloc.tab)
    && linkChargerBloc.tab != Tabs.linkConnecting
    && !_isSearching();

  // Method that creates the fixed bottom buttons of the current tab.
  Widget _createButtons() {
    if (_isSearching()) {
      return const SizedBox.shrink();
    }

    final Widget buttons;

    switch (linkChargerBloc.tab) {
      case Tabs.linkStart: buttons = _createStartButton(); break;
      case Tabs.linkSelectCharger: buttons = _createChargerSelectionButtons(); break;
      case Tabs.linkSelectNetwork: buttons = _createNetworkSelectionButtons(); break;
      default: return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(
        left: screenProperties.paddingCardHorizontal,
        top: Sizes.margin12,
        right: screenProperties.paddingCardHorizontal,
        bottom: Sizes.margin16
      ),
      child: buttons
    );
  }

  // Method that creates the bottom button of the start tab.
  Widget _createStartButton() => ButtonCustom(
    text: AppLocalizations.of(context)!.translate('charger_link_search'),
    fontSize: screenProperties.fontExtraSmall,
    onClicked: _onStartButtonClicked
  );

  // Method that creates the charger selection buttons.
  Widget _createChargerSelectionButtons() => StreamBuilder<String>(
    stream: linkChargerBloc.selectedChargerIdStream,
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) => _createBackAndPrimaryButtons(
      'continue',
      linkChargerBloc.selectedChargerId.isNotEmpty,
      _onContinueButtonClicked
    )
  );

  // Method that creates the network selection buttons.
  Widget _createNetworkSelectionButtons() => StreamBuilder<bool>(
    stream: linkChargerBloc.canConnectStream,
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) => _createBackAndPrimaryButtons(
      'connect',
      snapshot.data ?? linkChargerBloc.canConnect,
      _onConnectButtonClicked
    )
  );

  // Method that creates the back button and the primary button of the tab.
  Widget _createBackAndPrimaryButtons(String textKey, bool isEnabled, void Function() onClicked) => Row(
    children: [
      Expanded(
        flex: Numbers.flexSecondaryButton,
        child: ButtonColoredGhost(
          text: AppLocalizations.of(context)!.translate('back'),
          fontSize: screenProperties.fontExtraSmall,
          mainAxisSize: MainAxisSize.max,
          onClicked: _onBackButtonClicked
        )
      ),
      const SizedBox(width: Sizes.margin12),

      Expanded(
        flex: Numbers.flexPrimaryButton,
        child: _createPrimaryButton(textKey, isEnabled, onClicked)
      )
    ]
  );

  // Method that creates the primary button of the tab, which stays disabled while it is not allowed.
  Widget _createPrimaryButton(String textKey, bool isEnabled, void Function() onClicked) => ButtonCustom(
    text: AppLocalizations.of(context)!.translate(textKey),
    fontSize: screenProperties.fontExtraSmall,
    backgroundColor: isEnabled ? CustomColors.lime : CustomColors.lime36,
    borderColor: isEnabled ? CustomColors.lime : CustomColors.lime36,
    overlayColor: isEnabled ? CustomColors.lime80 : CustomColors.lime36,
    overlayBorderColor: isEnabled ? CustomColors.lime80 : CustomColors.lime36,
    onClicked: isEnabled ? onClicked : null
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the start button.
  void _onStartButtonClicked() => HelperBluetooth.searchChargers(context: context);

  // Method that is called when the user clicks the continue button.
  void _onContinueButtonClicked() => HelperWifi.searchNetworks(context: context);

  // Method that is called when the user clicks the connect button: registers the charger and starts its configuration.
  void _onConnectButtonClicked() {
    FocusScope.of(context).unfocus();
    HelperConnectCharger.connect(context: context);
  }

  // Method that is called when the user clicks the back button.
  void _onBackButtonClicked() {
    // While the charger is being connected nothing is done: the process must not be left half done. On error the helper goes back to the select network tab by itself. This applies to the app bar back and to the system back.
    if (linkChargerBloc.tab == Tabs.linkConnecting) {
      return;
    }

    if (linkChargerBloc.tab == Tabs.linkStart || linkChargerBloc.tab == Tabs.linkConnected) {
      Navigator.pop(context);
    } else if (linkChargerBloc.tab == Tabs.linkSelectNetwork) {
      // The chargers and the selection are kept, so no new scan is started.
      linkChargerBloc.changeTab(Tabs.linkSelectCharger);
    } else {
      if (linkChargerBloc.tab == Tabs.linkSelectCharger) {
        BleService.stopScan();
      }

      linkChargerBloc.changeTab(Tabs.linkStart);
    }
  }

  // Method that is called when the user clicks the native back button.
  void _onPopInvokedWithResult(bool didPop, dynamic result) {
    if (didPop) {
      return;
    }

    _onBackButtonClicked();
  }
}
