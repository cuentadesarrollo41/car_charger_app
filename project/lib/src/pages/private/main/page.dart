import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Commons.
import 'package:project/src/commons/constants/app_bar_modes.dart';
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/tabs.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/routes.dart';
import 'package:project/src/commons/utils/utils.dart';

// Pages.
import 'package:project/src/pages/index.dart';

// Widgets.
import 'package:project/src/widgets/app/main/main_tabs.dart';
import 'package:project/src/widgets/app/main/tabs/index.dart';
import 'package:project/src/widgets/generic/app_bar/app_bar_custom.dart';
import 'package:project/src/widgets/generic/app_update_lifecycle_widget.dart';
import 'package:project/src/widgets/generic/containers/conditional_widget.dart';
import 'package:project/src/widgets/generic/containers/scaffold_custom.dart';
import 'package:project/src/widgets/generic/modal_bottom_sheets/modal_bottom_sheet_confirmation.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late MainBloc mainBloc;
  late StateBloc stateBloc;

  late bool hasLoaded;

  late GlobalKey<ScaffoldState> scaffoldKey;

  late StreamSubscription<int>? changeTabSubscription;

  late TabController tabController;

  @override
  void initState() {
    hasLoaded = false;

    tabController = TabController(length: Tabs.defaultList.length, vsync: this, initialIndex: Tabs.home);
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

    return AppUpdateLifecycleWidget(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: _onPopInvokedWithResult,
        child: StreamBuilder<int>(
          stream: mainBloc.tabStream,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) => ScaffoldCustom(
            scaffoldKey: scaffoldKey,
            appBar: AppBarCustom(
              scaffoldKey: scaffoldKey,
              appBarMode: AppBarModes.main,
              showMenu: false,
              onProfileButtonClicked: _onProfileButtonClicked,
            ),
            contentIsList: false,
            leftPadding: 0,
            rightPadding: 0,
            safeBottom: false,
            createBody: _createContent,
          ),
        ),
      ),
    );
  }

  // Method that initializes the variables.
  void _init() {
    mainBloc = BlocProvider.mainBloc(context);
    stateBloc = BlocProvider.stateBloc(context);

    if (hasLoaded) {
      return;
    }

    mainBloc.reset();
    hasLoaded = true;

    // Subscriptions.
    // -- Subscribe to tab change event.
    changeTabSubscription = mainBloc.tabStream.listen((int tab) {
      tabController.animateTo(
        tab,
        duration: const Duration(milliseconds: Numbers.delayScroll),
        curve: Curves.decelerate,
      );
    });

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) => setState(() {}));
  }

  // Method that creates the content.
  Widget _createContent() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(child: _createTabsContent()),
      _createTabs(),
    ],
  );

  // Method that creates the tabs content.
  Widget _createTabsContent() => TabBarView(
    physics: const NeverScrollableScrollPhysics(),
    controller: tabController,
    children: [
      TabHome(refreshDateTime: mainBloc.refreshDateTime),
      TabCharging(refreshDateTime: mainBloc.refreshDateTime),
      TabHistory(refreshDateTime: mainBloc.refreshDateTime),
      TabSettings(refreshDateTime: mainBloc.refreshDateTime),
    ],
  );

  // Method that creates the tabs.
  Widget _createTabs() {
    final bool hideTabsMainContent = false;

    return StreamBuilder<bool>(
      stream: stateBloc.keyboardIsShownStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) => ConditionalWidget(
        showChild: !stateBloc.keyboardIsShown && MediaQuery.of(context).viewInsets.bottom <= 0,
        createChild: () => MainTabs(hideMainContent: hideTabsMainContent),
      ),
    );
  }

  // Method that is called when the user clicks the back button.
  void _onBackButtonClicked() {
    if (mainBloc.tab == Tabs.home) {
      Utils.showModalBottomSheetCustom(
        context: context,
        bottomSheet: ModalBottomSheetConfirmation(
          title: AppLocalizations.of(context)!.translate('exit'),
          texts: [
            TextSpan(text: AppLocalizations.of(context)!.translate('exit_text'))
          ],
          primaryButtonText: AppLocalizations.of(context)!.translate('no'),
          secondaryButtonText: AppLocalizations.of(context)!.translate('yes'),
          primaryButtonColor: CustomColors.redDark,
          secondaryButtonColor: CustomColors.backgroundGhost,
          onPrimaryButtonClicked: () => Navigator.pop(context),
          onSecondaryButtonClicked: SystemNavigator.pop
        ),
      );
    } else {
      mainBloc.changeTab(Tabs.home);
    }
  }

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the native back button.
  void _onPopInvokedWithResult(bool didPop, dynamic result) {
    if (didPop) {
      return;
    }

    _onBackButtonClicked();
  }

  // Method that is called when the user clicks the profile button.
  void _onProfileButtonClicked() => Utils.navigatorPush(context: context, child: MyProfilePage(), routeName: Routes.myProfile);
}
