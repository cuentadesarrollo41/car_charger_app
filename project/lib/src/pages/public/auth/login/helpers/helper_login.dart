import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/session_model.dart';
import 'package:project/src/models/user_model.dart';

// Services.
import 'package:project/src/services/auth_service.dart';

// Helpers.
import 'package:project/src/helpers/api/action_helper.dart';

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

abstract class HelperLogin {
  // Method that is called when the user clicks the login button.
  static void onLoginButtonClicked({ required BuildContext context, required Map<String, FocusNode> focusNodes }) {
    FocusManager.instance.primaryFocus?.unfocus();

    final String field = validateFields(context: context);

    if (field.isNotEmpty) {
      focusNodes[field]?.requestFocus();

      return;
    }

    final LoginBloc loginBloc = BlocProvider.loginBloc(context);
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    ActionHelper.exec(
      context: context,
      getLoadingText: () => loginBloc.loadingText,
      setLoadingText: loginBloc.changeLoadingText,
      loadingTextStream: loginBloc.loadingTextStream,
      validateFields: () => Strings.emptyString, // Fields are validated inline before.
      loadingKey: 'loading',
      call: () => AuthService.login(
        email: loginBloc.email.trim(),
        password: loginBloc.password,
        language: stateBloc.session.languageCode
      ),
      onSuccess: (Map<String, dynamic> response) => _onLoginSuccess(context: context, response: response)
    );
  }

  // Method that validates the fields. Sets the first error in the bloc and returns its field (empty if valid).
  static String validateFields({ required BuildContext context }) {
    final LoginBloc loginBloc = BlocProvider.loginBloc(context);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    if (loginBloc.email.trim().isEmpty) {
      loginBloc.setFieldError(Fields.email, localizations.translate('error_login_email_validation'));
      return Fields.email;
    }

    if (!EmailValidator.validate(loginBloc.email.trim())) {
      loginBloc.setFieldError(Fields.email, localizations.translate('error_login_email_format_validation'));
      return Fields.email;
    }

    if (loginBloc.password.isEmpty) {
      loginBloc.setFieldError(Fields.password, localizations.translate('error_login_password_validation'));
      return Fields.password;
    }

    if (!Utils.passwordIsValid(password: loginBloc.password)) {
      loginBloc.setFieldError(Fields.password, localizations.translate('error_login_password_format_validation').replaceFirst(Strings.replaceCode, Numbers.passwordLengthMin.toString()));
      return Fields.password;
    }

    loginBloc.resetFieldError();

    return Strings.emptyString;
  }

  // Method that is called when the login is successful.
  static void _onLoginSuccess({ required BuildContext context, required Map<String, dynamic> response }) {
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    Map<String, dynamic> decodedToken = JwtDecoder.decode(response[Fields.token]);

    stateBloc.updateSession(SessionModel(
      token: response[Fields.token],
      languageCode: stateBloc.session.languageCode,
      user: UserModel(id: decodedToken[Fields.data][Fields.id]),
      updateUserLastDate: DateTime(Numbers.firstYear),
    ));

    Utils.navigatorPushAndRemoveUntil(context: context, type: PageTransitionType.fade, child: const MainPage(), routeName: Routes.main);
  }
}
