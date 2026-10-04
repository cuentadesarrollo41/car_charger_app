import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Commons.
import 'package:project/src/commons/constants/tabs.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/route_tracker.dart';
import 'package:project/src/commons/utils/routes.dart';
import 'package:project/src/commons/utils/utils.dart';

// Pages.
import 'package:project/src/pages/index.dart';

// Widgets.
import 'package:project/src/widgets/generic/future_loading_data_content.dart';

/// Base class for all StatefulWidgets that use InitialLoadHandler.
/// Ensures refreshDateTime is always available for didUpdateWidget detection.
abstract class RefreshableWidget extends StatefulWidget {
  final DateTime refreshDateTime;

  const RefreshableWidget({
    required this.refreshDateTime,
    super.key,
  });
}

/// Mixin for the State of any Content widget that extends RefreshableWidget.
///
/// Handles:
/// - Initial data loading via FutureBuilder
/// - Automatic reload detection via refreshDateTime
/// - Loading text via stateBloc (no need to implement changeLoadingText)
/// - Error handling (retry, cancel, unauthorized)
///
/// Required to implement:
/// - [stateBloc] — return BlocProvider.stateBloc(context)
/// - [getData] — return the Future that loads initial data
/// - [handleResponse] — process the loaded data into BLoCs
/// - [buildContent] — return the widget tree once data is loaded
mixin InitialLoadHandler<T extends RefreshableWidget> on State<T> {
  late bool hasLoaded;
  Future<Map<String, dynamic>>? futureData;

  /// Override to change the loading text key. Defaults to 'loading'.
  String get loadingTextKey => 'loading';

  /// Return BlocProvider.stateBloc(context).
  /// Used internally by changeLoadingText — no need to override it.
  StateBloc get stateBloc;

  Future<Map<String, dynamic>> getData();
  void handleResponse(Map<String, dynamic> data);
  Widget buildContent();

  /// Managed automatically — do not override.
  void changeLoadingText(String text) => stateBloc.changeLoadingText(text);

  String getLoadingText() => AppLocalizations.of(context)!.translate(loadingTextKey);

  @override
  void initState() {
    super.initState();
    hasLoaded = false;
  }

  /// Automatically detects when the parent Page triggers a reload
  /// by changing refreshDateTime. Resets hasLoaded and futureData.
  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.refreshDateTime != widget.refreshDateTime) {
      hasLoaded = false;
      futureData = null;
      setState(() {});
    }
  }

  /// Retry logic — can be overridden if needed.
  void onRetryPressed(BuildContext context) {
    hasLoaded = false;
    futureData = null;

    Navigator.pop(context);

    setState(() {});
  }

  /// Cancel logic — can be overridden if needed.
  void onCancelPressed(BuildContext context, bool isAuthorized) {
    Future.microtask(() {
      if (!context.mounted) return;

      MainBloc mainBloc = BlocProvider.mainBloc(context);

      if (!isAuthorized || routeTracker.currentRoute == Routes.main && mainBloc.blocIsInit() && mainBloc.tab == Tabs.home) {
        return Utils.logout(context: context);
      }

      Navigator.pop(context);

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Utils.navigatorPushAndRemoveUntil(context: context, child: MainPage(), routeName: Routes.main);
      }
    });
  }

  /// Main entry point — call this from build().
  Widget buildInitialDataContent() {
    return FutureLoadingDataContent(
      hasLoaded: hasLoaded,
      loadingText: getLoadingText(),
      changeLoadingText: changeLoadingText,
      getData: () {
        futureData ??= getData();
        return futureData!;
      },
      handleGetDataResponse: ({required Map<String, dynamic> data}) {
        handleResponse(data);
        hasLoaded = true;
      },
      onErrorRetryButtonPressed: ({required BuildContext context}) {
        onRetryPressed(context);
        futureData = null;
      },
      errorCallback: () => hasLoaded = true,
      onErrorCancelButtonPressed: (BuildContext context, bool isAuthorized) {
        hasLoaded = true;
        onCancelPressed(context, isAuthorized);
      },
      createLoadedContent: buildContent,
    );
  }
}
