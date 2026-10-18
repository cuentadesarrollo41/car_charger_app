import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/ink_well_custom.dart';
import 'package:project/src/widgets/generic/texts/icon_text.dart';

class LinkChargerSearchAgain extends StatefulWidget {
  final void Function() onClicked;

  const LinkChargerSearchAgain({
    required this.onClicked,
    super.key
  });

  @override
  State<LinkChargerSearchAgain> createState() => _LinkChargerSearchAgainState();
}

class _LinkChargerSearchAgainState extends State<LinkChargerSearchAgain> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return _createLink();
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the link that starts a new search.
  Widget _createLink() => Center(
    child: InkWellCustom(
      onTap: widget.onClicked,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.margin8),
        child: IconText(
          iconData: FontAwesomeIcons.arrowRotateRight,
          iconSize: Sizes.font14,
          text: AppLocalizations.of(context)!.translate('charger_link_search_again'),
          fontSize: screenProperties.fontExtraSmall,
          fontWeight: FontWeight.w700,
          spacing: Sizes.margin8
        )
      )
    )
  );
}
