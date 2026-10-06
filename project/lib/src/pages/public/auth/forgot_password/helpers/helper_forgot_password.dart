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
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

abstract class HelperForgotPassword {
  // Method that is called when the user clicks the recover password button.
  static void onRecoverPasswordButtonClicked({ required BuildContext context, required Map<String, FocusNode> focusNodes }) {
    final ForgotPasswordBloc forgotPasswordBloc = BlocProvider.forgotPasswordBloc(context);
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    ActionHelper.exec(
      context: context,
      getLoadingText: () => forgotPasswordBloc.loadingText,
      setLoadingText: forgotPasswordBloc.changeLoadingText,
      loadingTextStream: forgotPasswordBloc.loadingTextStream,
      validateInlineFields: () => validateFields(context: context),
      focusNodes: focusNodes,
      loadingKey: 'loading',
      successTextKey: 'success_password_recover',
      useSnackBar: true,
      call: () => AuthService.recoverPassword(
        email: forgotPasswordBloc.email.trim(),
        language: stateBloc.session.languageCode
      ),
      onSuccess: (Map<String, dynamic> response) => Navigator.pop(context)
    );
  }

  // Method that validates the fields. Sets the first error in the bloc and returns its field (empty if valid).
  static String validateFields({ required BuildContext context }) {
    final ForgotPasswordBloc forgotPasswordBloc = BlocProvider.forgotPasswordBloc(context);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    if (forgotPasswordBloc.email.trim().isEmpty) {
      forgotPasswordBloc.setFieldError(Fields.email, localizations.translate('error_forgot_password_email_validation'));
      return Fields.email;
    }

    if (!EmailValidator.validate(forgotPasswordBloc.email.trim())) {
      forgotPasswordBloc.setFieldError(Fields.email, localizations.translate('error_forgot_password_email_format_validation'));
      return Fields.email;
    }

    forgotPasswordBloc.resetFieldError();

    return Strings.emptyString;
  }
}
