import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Services.
import 'package:project/src/services/user_service.dart';

// Helpers.
import 'package:project/src/helpers/api/action_helper.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/constants/tabs.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

abstract class HelperUpdatePassword {
  // Method that is called when the user clicks the save button.
  static void onSaveButtonClicked({ required BuildContext context, required Map<String, FocusNode> focusNodes }) {
    final UpdatePasswordBloc updatePasswordBloc = BlocProvider.updatePasswordBloc(context);
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    ActionHelper.exec(
      context: context,
      getLoadingText: () => updatePasswordBloc.loadingText,
      setLoadingText: updatePasswordBloc.changeLoadingText,
      loadingTextStream: updatePasswordBloc.loadingTextStream,
      validateInlineFields: () => validateFields(context: context),
      focusNodes: focusNodes,
      loadingKey: 'password_changing',
      successTextKey: 'success_password_updated',
      useSnackBar: true,
      call: () => UserService.updatePassword(
        token: stateBloc.session.token,
        oldPassword: updatePasswordBloc.oldPassword,
        newPassword: updatePasswordBloc.newPassword,
        language: stateBloc.session.languageCode
      ),
      onSuccess: (Map<String, dynamic> response) => _onSaveSuccess(context: context)
    );
  }

  // Method that validates the fields: sets the first error in the bloc and returns its field (empty if valid).
  static String validateFields({ required BuildContext context }) {
    final UpdatePasswordBloc updatePasswordBloc = BlocProvider.updatePasswordBloc(context);
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    if (updatePasswordBloc.oldPassword.isEmpty) {
      updatePasswordBloc.setFieldError(Fields.oldPassword, localizations.translate('error_profile_password_validation'));

      return Fields.oldPassword;
    }

    if (!Utils.passwordIsValid(password: updatePasswordBloc.newPassword)) {
      updatePasswordBloc.setFieldError(Fields.newPassword, localizations.translate('error_profile_password_format_validation').replaceFirst(Strings.replaceCode, Numbers.passwordLengthMin.toString()));

      return Fields.newPassword;
    }

    updatePasswordBloc.resetFieldErrors();

    return Strings.emptyString;
  }

  // Method that is called when the password is saved: goes back to the main tab of My Profile.
  static void _onSaveSuccess({ required BuildContext context }) => BlocProvider.myProfileBloc(context).changeTab(Tabs.home);
}
