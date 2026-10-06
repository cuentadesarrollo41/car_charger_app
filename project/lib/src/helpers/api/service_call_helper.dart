import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

abstract class ServiceCallHelper {
  static Future<Map<String, dynamic>?> handle({
    required BuildContext context,
    required Future<Map<String, dynamic>> Function() call,
    required void Function(String) changeLoadingText,
    bool closeProgressDialog = true,
    Set<int> successCodes = const {Backend.code200},
  }) async {
    final Map<String, dynamic> response = await call();

    if (!successCodes.contains(response[Fields.statusCode])) {
      if (context.mounted) {
        changeLoadingText(Strings.emptyString);

        if (closeProgressDialog) {
          Navigator.pop(context);
        }

        Utils.showAlertDialog(
          context: context,
          title: response[Fields.title],
          text: response[Fields.text],
          positiveName: AppLocalizations.of(context)!.translate('continue'),
          negativeName: null,
          positiveAction: Navigator.pop,
          negativeAction: null,
        );
      }

      return null;
    }

    return response;
  }
}
