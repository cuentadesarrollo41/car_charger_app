import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/charger_model.dart';

// Services.
import 'package:project/src/services/charge_point_service.dart';

// Helpers.
import 'package:project/src/helpers/api/action_helper.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

abstract class HelperSettings {
  // Method that saves the charger name (keeps the saved current limit).
  static void onSaveNameButtonClicked({ required BuildContext context, required Map<String, FocusNode> focusNodes }) {
    final SettingsBloc settingsBloc = BlocProvider.settingsBloc(context);
    final StateBloc stateBloc = BlocProvider.stateBloc(context);
    final ChargerModel charger = stateBloc.session.selectedCharger;

    ActionHelper.exec(
      context: context,
      getLoadingText: () => settingsBloc.loadingText,
      setLoadingText: settingsBloc.changeLoadingText,
      loadingTextStream: settingsBloc.loadingTextStream,
      validateInlineFields: () => validateNameFields(context: context),
      focusNodes: focusNodes,
      loadingKey: 'saving_changes',
      successTextKey: 'success_charger_name_updated',
      useSnackBar: true,
      call: () => ChargePointService.updateOne(
        id: charger.id,
        name: settingsBloc.chargerName.trim(),
        currentLimitAmps: charger.currentLimitAmps,
        language: stateBloc.session.languageCode,
        token: stateBloc.session.token
      ),
      onSuccess: (Map<String, dynamic> response) => _onChargerUpdated(context: context, response: response)
    );
  }

  // Method that saves the current limit (keeps the saved name). If it fails, the slider goes back to the saved value.
  static void onCurrentLimitChangeEnd({ required BuildContext context }) {
    final SettingsBloc settingsBloc = BlocProvider.settingsBloc(context);
    final StateBloc stateBloc = BlocProvider.stateBloc(context);
    final ChargerModel charger = stateBloc.session.selectedCharger;

    ActionHelper.exec(
      context: context,
      getLoadingText: () => settingsBloc.loadingText,
      setLoadingText: settingsBloc.changeLoadingText,
      loadingTextStream: settingsBloc.loadingTextStream,
      loadingKey: 'saving_changes',
      successTextKey: 'success_charger_limit_updated',
      useSnackBar: true,
      call: () => ChargePointService.updateOne(
        id: charger.id,
        name: charger.name,
        currentLimitAmps: settingsBloc.currentLimitAmps,
        language: stateBloc.session.languageCode,
        token: stateBloc.session.token
      ),
      onError: () => settingsBloc.changeCurrentLimitAmps(charger.currentLimitAmps),
      onSuccess: (Map<String, dynamic> response) => _onChargerUpdated(context: context, response: response)
    );
  }

  // Method that validates the name. Sets the error in the bloc and returns its field (empty if valid).
  static String validateNameFields({ required BuildContext context }) {
    final SettingsBloc settingsBloc = BlocProvider.settingsBloc(context);

    if (settingsBloc.chargerName.trim().isEmpty) {
      settingsBloc.setFieldError(Fields.name, AppLocalizations.of(context)!.translate('error_settings_charger_name_validation'));

      return Fields.name;
    }

    settingsBloc.resetFieldErrors();

    return Strings.emptyString;
  }

  // Method that is called when the charger is updated: saves it in the session and syncs the bloc.
  static void _onChargerUpdated({ required BuildContext context, required Map<String, dynamic> response }) {
    final SettingsBloc settingsBloc = BlocProvider.settingsBloc(context);
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    final ChargerModel charger = response[Fields.item];

    stateBloc.session.updateCharger(charger);
    stateBloc.updateSession(stateBloc.session);

    settingsBloc.fillFromCharger(charger);
  }
}
