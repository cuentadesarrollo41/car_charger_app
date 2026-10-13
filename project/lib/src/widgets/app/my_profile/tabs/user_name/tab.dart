import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Helpers.
import './helpers/index.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/button_custom.dart';
import 'package:project/src/widgets/generic/containers/content_container_custom.dart';
import 'package:project/src/widgets/generic/inputs/titled_input_text_field.dart';
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';

class TabUserName extends RefreshableWidget {
  const TabUserName({
    required super.refreshDateTime,
    super.key
  });

  @override
  State<TabUserName> createState() => _TabUserNameState();
}

class _TabUserNameState extends State<TabUserName> {
  late UserNameBloc userNameBloc;
  late StateBloc stateBloc;

  late ScreenPropertiesModel screenProperties;

  late bool hasLoaded;

  late Map<String, FocusNode> focusNodes;

  @override
  void initState() {
    hasLoaded = false;

    focusNodes = { Fields.name: FocusNode() };

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

    userNameBloc = BlocProvider.userNameBloc(context);
    stateBloc = BlocProvider.stateBloc(context);

    screenProperties = ScreenPropertiesModel(context: context);

    if (hasLoaded) {
      return;
    }

    userNameBloc.reset(stateBloc.session.user.name);
    hasLoaded = true;
  }

  @override
  Widget build(BuildContext context) => ContentContainerCustom(
    title: AppLocalizations.of(context)!.translate('user_name'),
    subtitle: AppLocalizations.of(context)!.translate('user_name_text'),
    marginTop: Sizes.margin20,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createInput(),
        const SizedBox(height: Sizes.margin20),

        ButtonCustom(
          text: AppLocalizations.of(context)!.translate('save_changes'),
          fontSize: screenProperties.fontExtraSmall,
          onClicked: _onSaveButtonClicked
        )
      ]
    )
  );

  // Method that creates the input.
  Widget _createInput() => StreamBuilder<Map<String, String>>(
    stream: userNameBloc.fieldErrorsStream,
    builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) => TitledInputTextField(
      title: AppLocalizations.of(context)!.translate('user_name'),
      hint: Strings.emptyString,
      initialText: userNameBloc.name,
      titleFontSize: screenProperties.fontExtraSmall,
      fontSize: screenProperties.fontSmall,
      isMandatory: true,
      textInputType: TextInputType.name,
      errorText: userNameBloc.fieldErrors[Fields.name] ?? Strings.emptyString,
      focusNode: focusNodes[Fields.name],
      onValueChanged: _onNameChanged
    )
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the save button.
  void _onSaveButtonClicked() => HelperUserName.onSaveButtonClicked(context: context, focusNodes: focusNodes);

  // ***************************************************************************
  // On change listeners.
  // ***************************************************************************
  void _onNameChanged(String value) => userNameBloc.changeFieldValue(Fields.name, userNameBloc.changeName, value);
}
