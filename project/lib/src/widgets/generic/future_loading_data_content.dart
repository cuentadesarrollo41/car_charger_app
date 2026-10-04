import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/constants/tabs.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/route_tracker.dart';
import 'package:project/src/commons/utils/routes.dart';
import 'package:project/src/commons/utils/utils.dart';

// Pages.
import 'package:project/src/pages/index.dart';

class FutureLoadingDataContent extends StatefulWidget {
  final bool hasLoaded;
  final String loadingText;
  final Color progressBarColor;
  final List<String> allowedRouteNames;

  final Widget Function() createLoadedContent;
  final void Function(String) changeLoadingText;
  final Future Function() getData;
  final void Function({ required Map<String, dynamic> data }) handleGetDataResponse;
  final void Function({ required BuildContext context }) onErrorRetryButtonPressed;
  final void Function(BuildContext context, bool isAuthorized)? onErrorCancelButtonPressed;
  final void Function() errorCallback;

  const FutureLoadingDataContent({
    required this.hasLoaded,
    required this.loadingText,
    this.progressBarColor = CustomColors.redPrimary,
    this.allowedRouteNames = const <String> [],
    required this.createLoadedContent,
    required this.changeLoadingText,
    required this.getData,
    required this.handleGetDataResponse,
    required this.onErrorRetryButtonPressed,
    this.onErrorCancelButtonPressed,
    required this.errorCallback,
    super.key
  });

  @override
  State<FutureLoadingDataContent> createState() => _FutureLoadingDataContentState();
}

class _FutureLoadingDataContentState extends State<FutureLoadingDataContent> {
  late StateBloc stateBloc;
  late bool openDialog; // Used because page is loaded twice.
  late bool hasError;

  late ScreenPropertiesModel screenProperties;

  @override
  void initState() {
    openDialog = false;
    hasError = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    if (hasError) {
      return Container();
    }

    if (widget.hasLoaded) {
      return widget.createLoadedContent();
    }

    widget.changeLoadingText(widget.loadingText);

    return FutureBuilder(
      future: widget.getData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Container(
              width: screenProperties.size.width,
              height: screenProperties.size.height,
              alignment: Alignment.center,
              child: CircularProgressIndicator(color: widget.progressBarColor)
            );
          case ConnectionState.done:
            break;
        }

        widget.changeLoadingText(Strings.emptyString);

        // Show error content.
        if (snapshot.data == null || (snapshot.data[Fields.statusCode] != Backend.code200 && snapshot.data[Fields.statusCode] != Backend.code201)) {
          if (!openDialog) {
            Future.delayed(Duration.zero, () {
              if (context.mounted) {
                _showErrorDialog(snapshot.data);
              }
            });
          }

          openDialog = true;
          hasError = true;

          widget.errorCallback(); // Update hasLoaded value.

          return Container();
        }

        widget.handleGetDataResponse(data: snapshot.data!);

        return widget.createLoadedContent();
      }
    );
  }

  // Method that initializes the variables.
  void _init() {
    stateBloc = BlocProvider.stateBloc(context);
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that shows the error dialog.
  void _showErrorDialog(Map<String, dynamic>? data) {
    String title = data != null && data[Fields.title] != null ? data[Fields.title] : AppLocalizations.of(context)!.translate('error_generic');
    String text = data != null && data[Fields.text] != null ? data[Fields.text] : AppLocalizations.of(context)!.translate('error_generic_text');
    String positiveName = AppLocalizations.of(context)!.translate('retry');
    String? negativeName = AppLocalizations.of(context)!.translate('cancel');

    bool isUnauthorized = false;

    if (data != null) {
      switch (data[Fields.statusCode]) {
        case Backend.codeNoConnection:
          title = AppLocalizations.of(context)!.translate('error_connection');
          text = AppLocalizations.of(context)!.translate('error_connection_text');
          break;
        case Backend.code401:
        case Backend.code403:
          isUnauthorized = true;
          title = AppLocalizations.of(context)!.translate('error_unauthorized');
          text = AppLocalizations.of(context)!.translate('error_unauthorized_text');
          positiveName = AppLocalizations.of(context)!.translate('continue');
          negativeName = null;
          break;
      }
    }

    Utils.showAlertDialog(
      context: context,
      title: title,
      text: text,
      positiveName: positiveName,
      negativeName: negativeName,
      positiveAction: isUnauthorized
        ? (BuildContext auxContext) => Utils.logout(context: context)
        : _onErrorRetryButtonClicked,
      negativeAction: isUnauthorized
        ? null
        : widget.onErrorCancelButtonPressed == null
        ? _onErrorCancelButtonClicked
        : (BuildContext context) => widget.onErrorCancelButtonPressed!(this.context, !isUnauthorized)
    );
  }

  // Method that is called when the user clicks the retry button.
  void _onErrorRetryButtonClicked(BuildContext context) {
    openDialog = false;
    hasError = false;

    widget.onErrorRetryButtonPressed(context: this.context);
  }

  // Method that is called when the user clicks the no connection or error cancel button.
  void _onErrorCancelButtonClicked(BuildContext context) {
    Navigator.pop(this.context);

    MainBloc mainBloc = BlocProvider.mainBloc(context);

    if (routeTracker.currentRoute == Routes.main && mainBloc.blocIsInit() && mainBloc.tab == Tabs.home) {
      Utils.logout(context: context);
    } else if (Navigator.canPop(context)) {
      Navigator.pop(this.context);
    } else {
      Utils.navigatorPushAndRemoveUntil(context: context, child: MainPage(), routeName: Routes.main);
    }
  }
}