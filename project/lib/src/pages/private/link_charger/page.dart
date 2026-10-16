import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

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
import 'package:project/src/widgets/generic/containers/conditional_widget.dart';
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: StreamBuilder<int>(
        stream: linkChargerBloc.tabStream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) => ScaffoldCustom(
          scaffoldKey: scaffoldKey,
          appBar: linkChargerBloc.tab == Tabs.linkConnected
            ? null
            : AppBarCustom(
              scaffoldKey: scaffoldKey,
              appBarMode: AppBarModes.text,
              showMenu: false,
              title: AppLocalizations.of(context)!.translate(Tabs.linkTabsKeys[linkChargerBloc.tab]),
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
      ConditionalWidget(
        showChild: linkChargerBloc.tab != Tabs.linkConnected,
        createChild: _createProgressLine
      ),

      ConditionalWidget(
        showChild: Tabs.linkStepTabs.contains(linkChargerBloc.tab) && linkChargerBloc.tab != Tabs.linkConnecting,
        createChild: _createStep
      ),

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

  // Method that creates the fixed bottom buttons of the current tab.
  Widget _createButtons() {
    final Widget buttons;

    switch (linkChargerBloc.tab) {
      case Tabs.linkStart: buttons = _createStartButton(); break;
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

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the start button.
  void _onStartButtonClicked() => linkChargerBloc.changeTab(Tabs.linkSelectCharger);

  // Method that is called when the user clicks the back button.
  void _onBackButtonClicked() {
    if (linkChargerBloc.tab == Tabs.linkStart || linkChargerBloc.tab == Tabs.linkConnected) {
      Navigator.pop(context);
    } else {
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
