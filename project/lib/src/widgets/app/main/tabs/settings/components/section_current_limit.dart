import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Helpers.
import '../helpers/index.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/containers/card/card_container.dart';
import 'package:project/src/widgets/generic/inputs/slider_custom.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class SectionCurrentLimit extends StatefulWidget {
  const SectionCurrentLimit({
    super.key
  });

  @override
  State<SectionCurrentLimit> createState() => _SectionCurrentLimitState();
}

class _SectionCurrentLimitState extends State<SectionCurrentLimit> {
  late SettingsBloc settingsBloc;

  late ScreenPropertiesModel screenProperties;

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

          _createContent()
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
    text: AppLocalizations.of(context)!.translate('current_limit'),
    fontSize: screenProperties.fontSmall,
    fontWeight: FontWeight.w700
  );

  // Method that creates the content.
  Widget _createContent() => StreamBuilder<int>(
    stream: settingsBloc.currentLimitAmpsStream,
    builder: (BuildContext context, AsyncSnapshot<int> snapshot) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createLabels(),
        const SizedBox(height: Sizes.margin8),

        _createSlider()
      ]
    )
  );

  // Method that creates the labels.
  Widget _createLabels() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      TextInter(
        text: '${ Numbers.currentLimitAmpsMin } ${ Strings.ampsUnit }',
        fontSize: screenProperties.fontSmallest,
        color: CustomColors.textSecondary
      ),
      TextInter(
        text: '${ settingsBloc.currentLimitAmps } ${ Strings.ampsUnit }',
        fontSize: screenProperties.fontSubtitle,
        fontWeight: FontWeight.w700
      ),
      TextInter(
        text: '${ Numbers.currentLimitAmpsMax } ${ Strings.ampsUnit }',
        fontSize: screenProperties.fontSmallest,
        color: CustomColors.textSecondary
      )
    ]
  );

  // Method that creates the slider.
  Widget _createSlider() => SliderCustom(
    value: settingsBloc.currentLimitAmps.toDouble(),
    min: Numbers.currentLimitAmpsMin.toDouble(),
    max: Numbers.currentLimitAmpsMax.toDouble(),
    divisions: Numbers.currentLimitAmpsMax - Numbers.currentLimitAmpsMin,
    onChanged: (double value) => settingsBloc.changeCurrentLimitAmps(value.round()),
    onChangeEnd: (double value) => HelperSettings.onCurrentLimitChangeEnd(context: context)
  );
}
