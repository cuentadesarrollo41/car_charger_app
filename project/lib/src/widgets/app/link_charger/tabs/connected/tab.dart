import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Helpers.
import 'package:project/src/pages/private/link_charger/helpers/index.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/button_custom.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class TabLinkChargerConnected extends StatefulWidget {
  const TabLinkChargerConnected({
    super.key
  });

  @override
  State<TabLinkChargerConnected> createState() => _TabLinkChargerConnectedState();
}

class _TabLinkChargerConnectedState extends State<TabLinkChargerConnected> {
  late LinkChargerBloc linkChargerBloc;
  late ScreenPropertiesModel screenProperties;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    linkChargerBloc = BlocProvider.linkChargerBloc(context);
    screenProperties = ScreenPropertiesModel(context: context);
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: screenProperties.paddingCardHorizontal),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          FontAwesomeIcons.circleCheck,
          color: CustomColors.lime,
          size: screenProperties.size.width * Numbers.successIconScreenWidthFactor
        ),
        const SizedBox(height: Sizes.margin24),

        TextInter(
          text: AppLocalizations.of(context)!.translate('charger_link_ready'),
          fontSize: screenProperties.fontBigTitle,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center
        ),
        const SizedBox(height: Sizes.margin12),

        TextInter(
          text: AppLocalizations.of(context)!.translate('charger_link_ready_text').replaceFirst(Strings.replaceCode, linkChargerBloc.linkedChargerName),
          fontSize: screenProperties.fontSmall,
          color: CustomColors.textSecondary,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center
        ),
        const SizedBox(height: Sizes.margin32),

        ButtonCustom(
          text: AppLocalizations.of(context)!.translate('go_home'),
          fontSize: screenProperties.fontExtraSmall,
          onClicked: _onGoHomeButtonClicked
        )
      ]
    )
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the go home button.
  void _onGoHomeButtonClicked() => HelperConnectCharger.finish(context: context);
}
