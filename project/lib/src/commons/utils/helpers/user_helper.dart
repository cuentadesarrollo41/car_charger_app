import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Config.
import 'package:project/src/config/preferences/preferences.dart';

// Models.
import 'package:project/src/models/generic/session_model.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/page_transition.dart';
import 'package:project/src/commons/utils/routes.dart';
import 'package:project/src/commons/utils/utils.dart';

// Pages.
import 'package:project/src/pages/index.dart';

abstract class UserHelper {
  // Method that logs the user out.
  static void logout({ required BuildContext context }) async {
    StateBloc stateBloc = BlocProvider.stateBloc(context);

    if (stateBloc.loadingText.isNotEmpty) {
      return;
    }

    stateBloc.changeLoadingText(AppLocalizations.of(context)!.translate('logging_out'));
    Utils.showProgressBarAlertDialog(context: context, stream: stateBloc.loadingTextStream);

    /*if (await Utils.deviceIsConnected()) {
      await AuthService.logout(
        token: stateBloc.session.token,
        firebaseToken: Preferences().firebaseToken,
        language: stateBloc.session.languageCode
      );
    }
    */

    stateBloc.changeLoadingText(Strings.emptyString);
    stateBloc.logout();
    stateBloc.changeEndDrawerIsOpened(false);

    if (!context.mounted) {
      return;
    }

    Utils.navigatorPushAndRemoveUntil(context: context, type: PageTransitionType.rightToLeft, child: const LoginPage(), routeName: Routes.login);
  }

  // Method that checks if user is authenticated.
  static bool userIsAuthenticated() {
    SessionModel session = Preferences().session;
    return session.token.isNotEmpty;
  }

  // Method that checks if password is valid.
  static bool passwordIsValid({ required String password }) {
    //final regex = RegExp('^.{${ Numbers.passwordLengthMin },${ Numbers.passwordLengthMax }}\$');
    //return regex.hasMatch(password);
    return password.length == 4;
  }
}