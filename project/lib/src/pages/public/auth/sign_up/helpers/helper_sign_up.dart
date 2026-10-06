import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Services.
import 'package:project/src/services/auth_service.dart';

// Helpers.
import 'package:project/src/helpers/api/action_helper.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

abstract class HelperSignUp {
  // Method that is called when the user clicks the sign up button.
  static void onSignUpButtonClicked({ required BuildContext context, required Map<String, FocusNode> focusNodes }) {
    final SignUpBloc signUpBloc = BlocProvider.signUpBloc(context);
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    ActionHelper.exec(
      context: context,
      getLoadingText: () => signUpBloc.loadingText,
      setLoadingText: signUpBloc.changeLoadingText,
      loadingTextStream: signUpBloc.loadingTextStream,
      validateInlineFields: () => validateFields(context: context),
      focusNodes: focusNodes,
      loadingKey: 'loading',
      call: () => AuthService.signUp(
        email: signUpBloc.email.trim(),
        password: signUpBloc.password,
        language: stateBloc.session.languageCode
      ),
      onSuccess: (Map<String, dynamic> response) => Utils.startSession(context: context, token: response[Fields.token])
    );
  }

  // Method that validates the fields. Sets the first error in the bloc and returns its field (empty if valid).
  static String validateFields({ required BuildContext context }) {
    final SignUpBloc signUpBloc = BlocProvider.signUpBloc(context);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    if (signUpBloc.email.trim().isEmpty) {
      signUpBloc.setFieldError(Fields.email, localizations.translate('error_sign_up_email_validation'));
      return Fields.email;
    }

    if (!EmailValidator.validate(signUpBloc.email.trim())) {
      signUpBloc.setFieldError(Fields.email, localizations.translate('error_sign_up_email_format_validation'));
      return Fields.email;
    }

    if (signUpBloc.password.isEmpty) {
      signUpBloc.setFieldError(Fields.password, localizations.translate('error_sign_up_password_validation'));
      return Fields.password;
    }

    if (!Utils.passwordIsValid(password: signUpBloc.password)) {
      signUpBloc.setFieldError(Fields.password, localizations.translate('error_sign_up_password_format_validation').replaceFirst(Strings.replaceCode, Numbers.passwordLengthMin.toString()));
      return Fields.password;
    }

    signUpBloc.resetFieldErrors();

    return Strings.emptyString;
  }
}
