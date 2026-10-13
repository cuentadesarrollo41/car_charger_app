import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Services.
import 'package:project/src/services/user_service.dart';

// Helpers.
import 'package:project/src/helpers/api/action_helper.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/constants/tabs.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

abstract class HelperUserName {
  // Method that is called when the user clicks the save button.
  static void onSaveButtonClicked({ required BuildContext context, required Map<String, FocusNode> focusNodes }) {
    final UserNameBloc userNameBloc = BlocProvider.userNameBloc(context);
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    ActionHelper.exec(
      context: context,
      getLoadingText: () => userNameBloc.loadingText,
      setLoadingText: userNameBloc.changeLoadingText,
      loadingTextStream: userNameBloc.loadingTextStream,
      validateInlineFields: () => validateFields(context: context),
      focusNodes: focusNodes,
      loadingKey: 'saving_changes',
      successTextKey: 'success_user_name_updated',
      useSnackBar: true,
      call: () => UserService.updateOwnUser(
        token: stateBloc.session.token,
        name: userNameBloc.name.trim(),
        language: stateBloc.session.languageCode
      ),
      onSuccess: (Map<String, dynamic> response) => _onSaveSuccess(context: context)
    );
  }

  // Method that validates the fields: sets the first error in the bloc and returns its field (empty if valid).
  static String validateFields({ required BuildContext context }) {
    final UserNameBloc userNameBloc = BlocProvider.userNameBloc(context);

    if (userNameBloc.name.trim().isEmpty) {
      userNameBloc.setFieldError(Fields.name, AppLocalizations.of(context)!.translate('error_profile_user_name_validation'));

      return Fields.name;
    }

    userNameBloc.resetFieldErrors();

    return Strings.emptyString;
  }

  // Method that is called when the name is saved: updates the session and goes back to the main tab of My Profile.
  static void _onSaveSuccess({ required BuildContext context }) {
    final UserNameBloc userNameBloc = BlocProvider.userNameBloc(context);
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    stateBloc.session.user.name = userNameBloc.name.trim();
    stateBloc.updateSession(stateBloc.session);

    BlocProvider.myProfileBloc(context).changeTab(Tabs.home);
  }
}
