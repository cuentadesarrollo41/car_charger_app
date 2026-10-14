import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Helpers.
import '../helpers/index.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/button_custom.dart';
import 'package:project/src/widgets/generic/containers/card/card_container.dart';
import 'package:project/src/widgets/generic/inputs/input_text_field.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class SectionChargerName extends StatefulWidget {
  const SectionChargerName({
    super.key
  });

  @override
  State<SectionChargerName> createState() => _SectionChargerNameState();
}

class _SectionChargerNameState extends State<SectionChargerName> {
  late SettingsBloc settingsBloc;

  late ScreenPropertiesModel screenProperties;

  late Map<String, FocusNode> focusNodes;

  @override
  void initState() {
    focusNodes = { Fields.name: FocusNode() };
    super.initState();
  }

  @override
  void dispose() {
    Utils.disposeFocusNodes(focusNodes: focusNodes.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return CardContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createTitle(),
          const SizedBox(height: Sizes.margin12),

          _createInput(),
          const SizedBox(height: Sizes.margin16),

          _createSaveButton()
        ]
      )
    );
  }

  // Method that initializes the variables.
  void _init() {
    settingsBloc = BlocProvider.settingsBloc(context);
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the title.
  Widget _createTitle() => TextInter(
    text: AppLocalizations.of(context)!.translate('charger_name'),
    fontSize: screenProperties.fontSmall,
    fontWeight: FontWeight.w700
  );

  // Method that creates the input.
  Widget _createInput() => StreamBuilder<Map<String, String>>(
    stream: settingsBloc.fieldErrorsStream,
    builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) => InputTextField(
      hint: Strings.emptyString,
      initialText: settingsBloc.chargerName,
      fontSize: screenProperties.fontSmall,
      textInputType: TextInputType.text,
      errorText: settingsBloc.fieldErrors[Fields.name] ?? Strings.emptyString,
      focusNode: focusNodes[Fields.name],
      onValueChanged: _onChargerNameChanged
    )
  );

  // Method that creates the save button.
  Widget _createSaveButton() => ButtonCustom(
    text: AppLocalizations.of(context)!.translate('save_name'),
    fontSize: screenProperties.fontExtraSmall,
    onClicked: _onSaveNameButtonClicked
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the save button.
  void _onSaveNameButtonClicked() => HelperSettings.onSaveNameButtonClicked(context: context, focusNodes: focusNodes);

  // ***************************************************************************
  // On change listeners.
  // ***************************************************************************
  void _onChargerNameChanged(String value) => settingsBloc.changeFieldValue(Fields.name, settingsBloc.changeChargerName, value);
}
