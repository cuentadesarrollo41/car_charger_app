import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Services.
import 'package:project/src/services/download_service.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

abstract class HelperDownloadFile {
  // ***************************************************************************
  // DOWNLOAD FILE.
  // ***************************************************************************
  static void onDownloadButtonClicked(BuildContext context, String url, String name, String loadingText, { String shareText = Strings.emptyString, void Function()? callback }) async {
    StateBloc stateBloc = BlocProvider.stateBloc(context);

    if (stateBloc.loadingText.isNotEmpty) {
      return;
    }

    if (!await Utils.deviceIsConnected()) {
      if (!context.mounted) {
        return;
      }

      return Utils.showAlertDialog(context: context, title: AppLocalizations.of(context)!.translate('error_connection'), text: AppLocalizations.of(context)!.translate('error_connection_text'), positiveName: AppLocalizations.of(context)!.translate('ok'), negativeName: null, positiveAction: Navigator.pop, negativeAction: null);
    }

    if (!context.mounted) {
      return;
    }

    stateBloc.changeLoadingText(loadingText);
    Utils.showProgressBarAlertDialog(context: context, stream: stateBloc.loadingTextStream);

    final Map<String, dynamic> response = await DownloadService.downloadFile(
      token: stateBloc.session.token,
      url: url,
      name: name,
      language: stateBloc.session.languageCode
    );

    if (!context.mounted) {
      return;
    }

    stateBloc.changeLoadingText(Strings.emptyString);
    Navigator.pop(context); // Close progress bar dialog.

    // Handle response.
    if (response[Fields.statusCode] != Backend.code200) {
      return Utils.showAlertDialog(context: context, title: response[Fields.title], text: response[Fields.text], positiveName: AppLocalizations.of(context)!.translate('ok'), negativeName: null, positiveAction: Navigator.pop, negativeAction: null);
    }

    await OpenFile.open(response[Fields.file].path);

    callback?.call();
  }
}