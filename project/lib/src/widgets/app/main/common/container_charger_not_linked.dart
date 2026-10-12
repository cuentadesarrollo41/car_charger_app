import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/routes.dart';
import 'package:project/src/commons/utils/utils.dart';

// Pages.
import 'package:project/src/pages/index.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/button_custom.dart';
import 'package:project/src/widgets/generic/containers/card/card_container.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';
import 'package:project/src/widgets/generic/texts/title_section.dart';

class ContainerChargerNotLinked extends StatefulWidget {
  const ContainerChargerNotLinked({
    super.key
  });

  @override
  State<ContainerChargerNotLinked> createState() => _ContainerChargerNotLinkedState();
}

class _ContainerChargerNotLinkedState extends State<ContainerChargerNotLinked> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return CardContainer(
      horizontalPadding: screenProperties.paddingCardHorizontal,
      verticalPadding: screenProperties.paddingCardVertical,
      dashedBorder: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _createIcon(),
          const SizedBox(height: Sizes.margin20),

          TitleSection(text: AppLocalizations.of(context)!.translate('charger_add')),
          const SizedBox(height: Sizes.margin12),

          _createDescription(),
          const SizedBox(height: Sizes.margin24),

          _createButton()
        ],
      )
    );
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the icon.
  Widget _createIcon() => Container(
    padding: const EdgeInsets.all(Sizes.margin22),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Sizes.borderRadius16),
      color: CustomColors.lime12
    ),
    child: const FaIcon(
      FontAwesomeIcons.plus,
      color: CustomColors.lime,
      size: Sizes.font28
    )
  );

  // Method that creates the description.
  Widget _createDescription() => TextInter(
    text: AppLocalizations.of(context)!.translate('charger_add_text'),
    fontSize: screenProperties.fontSmall,
    color: CustomColors.textSecondary,
    textAlign: TextAlign.center
  );

  // Method that creates the button.
  Widget _createButton() => ButtonCustom(
    text: AppLocalizations.of(context)!.translate('charger_link'),
    fontSize: screenProperties.fontExtraSmall,
    onClicked: _onLinkChargerButtonClicked
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the link charger button.
  void _onLinkChargerButtonClicked() => Utils.navigatorPush(context: context, child: const LinkChargerPage(), routeName: Routes.linkCharger);
}
