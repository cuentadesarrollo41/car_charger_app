import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Commons.
import 'package:project/src/commons/constants/app_bar_modes.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/tabs.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/app/my_profile/tabs/index.dart';
import 'package:project/src/widgets/generic/app_bar/app_bar_custom.dart';
import 'package:project/src/widgets/generic/containers/scaffold_custom.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({
    super.key
  });

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> with SingleTickerProviderStateMixin {
  late MyProfileBloc myProfileBloc;

  late bool hasLoaded;

  late GlobalKey<ScaffoldState> scaffoldKey;

  late StreamSubscription<int>? changeTabSubscription;

  late TabController tabController;

  @override
  void initState() {
    hasLoaded = false;

    tabController = TabController(length: Tabs.myProfileTabs.length, vsync: this, initialIndex: Tabs.home);
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
        stream: myProfileBloc.tabStream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) => ScaffoldCustom(
          scaffoldKey: scaffoldKey,
          appBar: AppBarCustom(
            scaffoldKey: scaffoldKey,
            appBarMode: AppBarModes.text,
            showMenu: false,
            title: AppLocalizations.of(context)!.translate(Tabs.myProfileTabsKeys[myProfileBloc.tab]),
            onBackButtonClicked: _onBackButtonClicked
          ),
          contentIsList: false,
          leftPadding: 0,
          rightPadding: 0,
          safeBottom: false,
          createBody: _createContent
        )
      )
    );
  }

  // Method that initializes the variables.
  void _init() {
    myProfileBloc = BlocProvider.myProfileBloc(context);

    if (hasLoaded) {
      return;
    }

    myProfileBloc.reset();
    hasLoaded = true;

    // Subscriptions.
    // -- Subscribe to tab change event.
    changeTabSubscription = myProfileBloc.tabStream.listen((int tab) {
      tabController.animateTo(
        tab,
        duration: const Duration(milliseconds: Numbers.delayScroll),
        curve: Curves.decelerate
      );
    });

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) => setState(() {}));
  }

  // Method that creates the content.
  Widget _createContent() => TabBarView(
    physics: const NeverScrollableScrollPhysics(),
    controller: tabController,
    children: [
      TabMyProfileHome(refreshDateTime: myProfileBloc.refreshDateTime),
      TabUserName(refreshDateTime: myProfileBloc.refreshDateTime),
      TabUpdatePassword(refreshDateTime: myProfileBloc.refreshDateTime)
    ]
  );

  // Method that is called when the user clicks the back button.
  void _onBackButtonClicked() {
    if (myProfileBloc.tab == Tabs.home) {
      Navigator.pop(context);
    } else {
      myProfileBloc.changeTab(Tabs.home);
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
}
