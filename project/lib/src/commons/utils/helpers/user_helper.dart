import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Config.
import 'package:project/src/config/preferences/preferences.dart';

// Models.
import 'package:project/src/models/generic/session_model.dart';
import 'package:project/src/models/user_model.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/numbers.dart';
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

  // Method that starts the session with the token received after login / sign up and goes to the main page.
  static void startSession({ required BuildContext context, required String token }) {
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    stateBloc.updateSession(SessionModel(
      token: token,
      languageCode: stateBloc.session.languageCode,
      user: UserModel(id: decodedToken[Fields.data][Fields.id]),
      updateUserLastDate: DateTime(Numbers.firstYear)
    ));

    Utils.navigatorPushAndRemoveUntil(context: context, type: PageTransitionType.fade, child: const MainPage(), routeName: Routes.main);
  }

  // Method that checks if user is authenticated.
  static bool userIsAuthenticated() {
    SessionModel session = Preferences().session;
    return session.token.isNotEmpty;
  }

  // Method that checks if password is valid.
  static bool passwordIsValid({ required String password }) => password.trim().length >= Numbers.passwordLengthMin;
}