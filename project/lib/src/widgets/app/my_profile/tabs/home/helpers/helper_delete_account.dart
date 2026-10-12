import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Services.
import 'package:project/src/services/user_service.dart';

// Helpers.
import 'package:project/src/helpers/api/action_helper.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import 'package:project/src/widgets/generic/modal_bottom_sheets/modal_bottom_sheet_confirmation.dart';

abstract class HelperDeleteAccount {
  // Method that deletes the user's account and, on success, logs out.
  static void onDeleteAccountConfirmed({ required BuildContext context }) => Utils.showModalBottomSheetCustom(
    context: context,
    bottomSheet: ModalBottomSheetConfirmation(
      title: AppLocalizations.of(context)!.translate('account_delete'),
      texts: [ TextSpan(text: AppLocalizations.of(context)!.translate('account_delete_text')) ],
      primaryButtonText: AppLocalizations.of(context)!.translate('account_delete_my'),
      secondaryButtonText: AppLocalizations.of(context)!.translate('cancel'),
      primaryButtonColor: CustomColors.redDark,
      secondaryButtonColor: CustomColors.backgroundGhost,
      onPrimaryButtonClicked: () {
        Navigator.pop(context);
        _deleteAccount(context);
      },
      onSecondaryButtonClicked: () => Navigator.pop(context)
    )
  );

  // Method that deletes the account.
  static void _deleteAccount(BuildContext context) {
    final MyProfileBloc myProfileBloc = BlocProvider.myProfileBloc(context);
    final StateBloc stateBloc = BlocProvider.stateBloc(context);

    ActionHelper.exec(
      context: context,
      getLoadingText: () => myProfileBloc.loadingText,
      setLoadingText: myProfileBloc.changeLoadingText,
      loadingTextStream: myProfileBloc.loadingTextStream,
      loadingKey: 'account_deleting',
      successTextKey: 'success_account_deleted',
      useSnackBar: true,
      call: () => UserService.deleteOwnUser(
        language: stateBloc.session.languageCode,
        token: stateBloc.session.token
      ),
      onSuccess: (Map<String, dynamic> response) => Utils.logout(context: context)
    );
  }
}
