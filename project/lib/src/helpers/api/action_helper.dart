import 'package:flutter/material.dart';

// Helpers.
import 'package:project/src/helpers/api/service_call_helper.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

abstract class ActionHelper {
  static Future<void> exec({
    required BuildContext context,
    required String Function() getLoadingText,
    required void Function(String) setLoadingText,
    required Stream<String> loadingTextStream,
    String Function()? validateFields, // Returns an error message shown in a dialog (empty if valid).
    String Function()? validateInlineFields, // Returns the field with the first inline error (empty if valid).
    Map<String, FocusNode> focusNodes = const {},
    required Future<Map<String, dynamic>> Function() call,
    required String loadingKey,
    String? successTextKey,
    String successTitleKey = 'information',
    void Function(Map<String, dynamic> response)? onSuccess,
    void Function()? onError,
    Set<int> successCodes = const {Backend.code200},
    bool showDialog = true,
    bool checkConnection = true,
    bool useSnackBar = false,
  }) async {
    if (getLoadingText().isNotEmpty) {
      return;
    }

    // Inline validation: the error text is already set in the bloc by the caller.
    if (validateInlineFields != null) {
      Utils.unfocus();

      final String field = validateInlineFields();

      if (field.isNotEmpty) {
        focusNodes[field]?.requestFocus();
        return;
      }
    }

    // Dialog validation.
    final String validationError = validateFields?.call() ?? Strings.emptyString;

    if (validationError.isNotEmpty) {
      return Utils.showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.translate('error_validation'),
        text: validationError,
        positiveName: AppLocalizations.of(context)!.translate('ok'),
        negativeName: null,
        positiveAction: Navigator.pop,
        negativeAction: null,
      );
    }

    final bool isConnected = await Utils.deviceIsConnected();

    if (checkConnection && !isConnected) {
      if (!context.mounted) {
        return;
      }

      return Utils.showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.translate('error_connection'),
        text: AppLocalizations.of(context)!.translate('error_connection_text'),
        positiveName: AppLocalizations.of(context)!.translate('continue'),
        negativeName: null,
        positiveAction: Navigator.pop,
        negativeAction: null,
      );
    }

    if (!context.mounted) {
      return;
    }

    setLoadingText(AppLocalizations.of(context)!.translate(loadingKey));

    if (showDialog) {
      Utils.showProgressBarAlertDialog(
        context: context,
        stream: loadingTextStream,
      );
    }

    // Call services.
    final Map<String, dynamic>? response = await ServiceCallHelper.handle(
      context: context,
      call: call,
      changeLoadingText: setLoadingText,
      successCodes: successCodes,
    );

    if (response == null) {
      return onError?.call();
    }

    if (!context.mounted) {
      return;
    }

    setLoadingText(Strings.emptyString);

    if (showDialog) {
      Navigator.pop(context);
    }

    // Show dialog only if success text is not empty.
    if (successTextKey == null) {
      return onSuccess?.call(response);
    }

    if (useSnackBar) {
      await Utils.showSnackBar(
        context: context,
        text: AppLocalizations.of(context)!.translate(successTextKey),
        onDismiss: onSuccess == null ? null : () => onSuccess.call(response)
      );

      return onSuccess?.call(response);
    }

    Utils.showAlertDialog(
      context: context,
      title: AppLocalizations.of(context)!.translate(successTitleKey),
      text: AppLocalizations.of(context)!.translate(successTextKey),
      positiveName: AppLocalizations.of(context)!.translate('continue'),
      negativeName: null,
      positiveAction: (BuildContext auxContext) {
        Navigator.pop(auxContext);
        onSuccess?.call(response);
      },
      negativeAction: null,
    );
  }
}
