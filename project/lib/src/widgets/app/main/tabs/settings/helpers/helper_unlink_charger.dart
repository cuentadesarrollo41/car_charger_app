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
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/tabs.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import 'package:project/src/widgets/generic/modal_bottom_sheets/modal_bottom_sheet_confirmation.dart';

abstract class HelperUnlinkCharger {
  // Method that is called when the user clicks the unlink button: asks for confirmation before unlinking the charger.
  static void onUnlinkButtonClicked({ required BuildContext context }) => Utils.showModalBottomSheetCustom(
    context: context,
    bottomSheet: ModalBottomSheetConfirmation(
      title: AppLocalizations.of(context)!.translate('charger_unlink_question'),
      texts: [ TextSpan(text: AppLocalizations.of(context)!.translate('charger_unlink_question_text')) ],
      primaryButtonText: AppLocalizations.of(context)!.translate('unlink'),
      secondaryButtonText: AppLocalizations.of(context)!.translate('cancel'),
      primaryButtonColor: CustomColors.redDark,
      secondaryButtonColor: CustomColors.backgroundGhost,
      onPrimaryButtonClicked: () => _unlinkCharger(context),
      onSecondaryButtonClicked: () => Navigator.pop(context)
    )
  );

  // Method that unlinks the charger: closes the bottom sheet and calls the service.
  static void _unlinkCharger(BuildContext context) {
    final SettingsBloc settingsBloc = BlocProvider.settingsBloc(context);
    final StateBloc stateBloc = BlocProvider.stateBloc(context);
    final String chargerId = stateBloc.session.selectedChargerId;

    Navigator.pop(context);

    ActionHelper.exec(
      context: context,
      getLoadingText: () => settingsBloc.loadingText,
      setLoadingText: settingsBloc.changeLoadingText,
      loadingTextStream: settingsBloc.loadingTextStream,
      loadingKey: 'charger_unlinking',
      successTextKey: 'success_charger_unlinked',
      useSnackBar: true,
      call: () => ChargePointService.unlink(
        id: chargerId,
        language: stateBloc.session.languageCode,
        token: stateBloc.session.token
      ),
      onSuccess: (Map<String, dynamic> response) => _onUnlinkSuccess(context: context, chargerId: chargerId)
    );
  }

  // Method that is called when the charger is unlinked: removes it from the session, selects the next one (or none) and goes to the Home tab.
  static void _onUnlinkSuccess({ required BuildContext context, required String chargerId }) {
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    stateBloc.session.user.chargers.removeWhere((ChargerModel charger) => charger.id == chargerId);
    stateBloc.session.updateSelectedCharger();
    stateBloc.updateSession(stateBloc.session);

    BlocProvider.mainBloc(context).changeTab(Tabs.home);
  }
}
