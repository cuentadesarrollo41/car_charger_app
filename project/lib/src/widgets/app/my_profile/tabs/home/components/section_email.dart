import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/containers/card/card_container.dart';
import 'package:project/src/widgets/generic/containers/rounded_container_icon.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class SectionEmail extends StatefulWidget {
  const SectionEmail({
    super.key
  });

  @override
  State<SectionEmail> createState() => _SectionEmailState();
}

class _SectionEmailState extends State<SectionEmail> {
  late StateBloc stateBloc;

  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return CardContainer(
      horizontalPadding: screenProperties.paddingCardHorizontal,
      verticalPadding: screenProperties.paddingCardVertical,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: screenProperties.paddingCardHorizontal,
        children: [
          _createIcon(),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Sizes.margin4,
              children: [
                _createTitle(),
                _createText()
              ]
            )
          )
        ]
      )
    );
  }

  // Method that initializes the variables.
  void _init() {
    stateBloc = BlocProvider.stateBloc(context);
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the icon.
  Widget _createIcon() => RoundedContainerIcon(
    height: null,
    horizontalPadding: Sizes.margin24,
    iconData: FontAwesomeIcons.solidUser,
    iconSize: Sizes.font30,
    borderColor: null
  );

  // Method that creates the title.
  Widget _createTitle() => TextInter(
    text: AppLocalizations.of(context)!.translate('email_your_access'),
    fontSize: screenProperties.fontSmall,
    fontWeight: FontWeight.w800
  );

  // Method that creates the text.
  Widget _createText() => TextInter(
    text: stateBloc.session.user.email,
    fontSize: screenProperties.fontExtraSmall,
    color: CustomColors.textSecondary
  );
}
