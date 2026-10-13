import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Helpers.
import './helpers/index.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/button_custom.dart';
import 'package:project/src/widgets/generic/containers/content_container_custom.dart';
import 'package:project/src/widgets/generic/inputs/titled_input_text_field.dart';
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';

class TabUpdatePassword extends RefreshableWidget {
  const TabUpdatePassword({
    required super.refreshDateTime,
    super.key
  });

  @override
  State<TabUpdatePassword> createState() => _TabUpdatePasswordState();
}

class _TabUpdatePasswordState extends State<TabUpdatePassword> {
  late UpdatePasswordBloc updatePasswordBloc;
  late StateBloc stateBloc;

  late ScreenPropertiesModel screenProperties;

  late bool hasLoaded;

  late Map<String, FocusNode> focusNodes;

  @override
  void initState() {
    hasLoaded = false;

    focusNodes = { Fields.oldPassword: FocusNode(), Fields.newPassword: FocusNode() };

    super.initState();
  }

  @override
  void dispose() {
    Utils.disposeFocusNodes(focusNodes: focusNodes.values);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    updatePasswordBloc = BlocProvider.updatePasswordBloc(context);
    stateBloc = BlocProvider.stateBloc(context);

    screenProperties = ScreenPropertiesModel(context: context);

    if (hasLoaded) {
      return;
    }

    updatePasswordBloc.reset();
    hasLoaded = true;
  }

  @override
  Widget build(BuildContext context) => ContentContainerCustom(
    title: AppLocalizations.of(context)!.translate('password_new'),
    subtitle: AppLocalizations.of(context)!.translate('password_new_text'),
    marginTop: Sizes.margin20,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createInputs(),
        const SizedBox(height: Sizes.margin20),

        ButtonCustom(
          text: AppLocalizations.of(context)!.translate('password_save'),
          fontSize: screenProperties.fontExtraSmall,
          onClicked: _onSaveButtonClicked
        )
      ]
    )
  );

  // Method that creates the inputs.
  Widget _createInputs() => StreamBuilder<Map<String, String>>(
    stream: updatePasswordBloc.fieldErrorsStream,
    builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createInput('password_current', Fields.oldPassword, Strings.emptyString, _onOldPasswordChanged),
        const SizedBox(height: Sizes.margin16),

        _createInput('password_new', Fields.newPassword, AppLocalizations.of(context)!.translate('password_hint').replaceFirst(Strings.replaceCode, Numbers.passwordLengthMin.toString()), _onNewPasswordChanged)
      ]
    )
  );

  // Method that creates an input.
  Widget _createInput(String titleKey, String field, String hint, void Function(String value) onChanged) => TitledInputTextField(
    title: AppLocalizations.of(context)!.translate(titleKey),
    hint: hint,
    initialText: Strings.emptyString,
    titleFontSize: screenProperties.fontExtraSmall,
    fontSize: screenProperties.fontSmall,
    isMandatory: true,
    textInputType: TextInputType.visiblePassword,
    allowShowText: true,
    obscureText: true,
    errorText: updatePasswordBloc.fieldErrors[field] ?? Strings.emptyString,
    focusNode: focusNodes[field],
    onValueChanged: onChanged
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the save button.
  void _onSaveButtonClicked() => HelperUpdatePassword.onSaveButtonClicked(context: context, focusNodes: focusNodes);

  // ***************************************************************************
  // On change listeners.
  // ***************************************************************************
  void _onOldPasswordChanged(String value) => updatePasswordBloc.changeFieldValue(Fields.oldPassword, updatePasswordBloc.changeOldPassword, value);
  void _onNewPasswordChanged(String value) => updatePasswordBloc.changeFieldValue(Fields.newPassword, updatePasswordBloc.changeNewPassword, value);
}
