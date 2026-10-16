import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/app/link_charger/common/index.dart';
import 'package:project/src/widgets/generic/containers/card/card_container.dart';
import 'package:project/src/widgets/generic/lines/line.dart';
import 'package:project/src/widgets/generic/texts/icon_text.dart';
import 'package:project/src/widgets/generic/texts/section_introduction_texts.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class TabLinkChargerStart extends StatefulWidget {
  const TabLinkChargerStart({
    super.key
  });

  @override
  State<TabLinkChargerStart> createState() => _TabLinkChargerStartState();
}

class _TabLinkChargerStartState extends State<TabLinkChargerStart> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return LinkChargerTabLayout(
      child: _createContent()
    );
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the content of the tab.
  Widget _createContent() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionIntroductionTexts(
        title: AppLocalizations.of(context)!.translate('charger_link_prepare'),
        subtitle: AppLocalizations.of(context)!.translate('charger_link_prepare_text')
      ),
      const SizedBox(height: Sizes.margin24),

      _createCard()
    ]
  );

  // Method that creates the card.
  Widget _createCard() => CardContainer(
    horizontalPadding: screenProperties.paddingCardHorizontal,
    verticalPadding: screenProperties.paddingCardVertical,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _createTitle(),
        const SizedBox(height: Sizes.margin8),

        ..._createRows()
      ]
    )
  );

  // Method that creates the title of the card.
  Widget _createTitle() => IconText(
    iconData: FontAwesomeIcons.circleInfo,
    iconColor: CustomColors.lime,
    iconSize: Sizes.font18,
    text: AppLocalizations.of(context)!.translate('charger_link_before_start'),
    fontSize: screenProperties.fontSmall,
    fontWeight: FontWeight.w700,
    spacing: Sizes.margin8
  );

  // Method that creates the checklist rows, with a line between them.
  List<Widget> _createRows() => [
    const SizedBox(height: Sizes.margin16),

    _createRow('charger_link_check_on'),
    _createLine(),

    _createRow('charger_link_check_bluetooth'),
    _createLine(),

    _createRow('charger_link_check_near')
  ];

  // Method that creates the line drawn between two rows.
  Widget _createLine() => const Line(
    height: Sizes.defaultBorderSize,
    width: double.infinity,
    color: CustomColors.backgroundLine,
    verticalMargin: Sizes.margin16
  );

  // Method that creates a row with its check text and its check icon.
  Widget _createRow(String textKey) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: TextInter(
          text: AppLocalizations.of(context)!.translate(textKey),
          fontSize: screenProperties.fontExtraSmall,
          fontWeight: FontWeight.w400
        )
      ),
      const FaIcon(
        FontAwesomeIcons.circleCheck,
        color: CustomColors.lime,
        size: Sizes.font18
      )
    ]
  );
}
