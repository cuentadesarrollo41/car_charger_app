import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/containers/card/card_container.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class SectionConnectivity extends StatefulWidget {
  const SectionConnectivity({
    super.key
  });

  @override
  State<SectionConnectivity> createState() => _SectionConnectivityState();
}

class _SectionConnectivityState extends State<SectionConnectivity> {
  late StateBloc stateBloc;

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
    stateBloc = BlocProvider.stateBloc(context);
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the title.
  Widget _createTitle() => TextInter(
    text: AppLocalizations.of(context)!.translate('connectivity'),
    fontSize: screenProperties.fontSmall,
    fontWeight: FontWeight.w700
  );

  // Method that creates the content.
  Widget _createContent() {
    final String networkName = stateBloc.session.selectedCharger.networkName;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextInter(
          text: AppLocalizations.of(context)!.translate('wifi_network'),
          fontSize: screenProperties.fontExtraSmall,
          color: CustomColors.textSecondary,
        ),
        TextInter(
          text: networkName.isEmpty ? Strings.hyphen : networkName,
          fontSize: screenProperties.fontExtraSmall,
          color: CustomColors.textSecondary,
          fontWeight: FontWeight.w600
        )
      ]
    );
  }
}
