import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

/// Mixin for the State of any Page widget (list, detail, home or any page
/// that loads data and controls a Content widget via refreshDateTime).
///
/// Handles:
/// - scaffoldKey initialization
/// - screenProperties initialization
/// - hasLoaded flag and first-frame scheduling
/// - reloadPage logic
///
/// Required to implement:
/// - [onInit] — called once when the page loads for the first time.
///   Use it to reset BLoCs, initialize variables, controllers, etc.
/// - [updateRefreshDateTime] — called on every reload.
///   Typically: bloc.changeRefreshDateTime(DateTime.now())
///
/// For pages with a filter end drawer, add this directly in the Page
/// (no mixin needed — it's just one line):
///   void _onOpenFilterButtonClicked() => scaffoldKey.currentState!.openEndDrawer();
mixin PageHandler<T extends StatefulWidget> on State<T> {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late ScreenPropertiesModel screenProperties;
  late bool hasLoaded;

  /// Called once on first load. Reset BLoCs and initialize any variables here.
  void onInit();

  /// Called on every reload. Typically: bloc.changeRefreshDateTime(DateTime.now())
  void updateRefreshDateTime();

  @override
  void initState() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    hasLoaded = false;
    super.initState();
  }

  /// Call this at the top of build(BuildContext context).
  void initPage(BuildContext context) {
    screenProperties = ScreenPropertiesModel(context: context);

    if (hasLoaded) {
      return;
    }

    onInit();

    hasLoaded = true;

    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  /// Call this to reload the page.
  /// Pass init: true to re-run onInit() (full reset).
  /// Pass init: false to only refresh the data (keep BLoC state).
  void reloadPage(bool init) {
    if (init) {
      hasLoaded = false;
    }

    updateRefreshDateTime();
    setState(() {});
  }
}
