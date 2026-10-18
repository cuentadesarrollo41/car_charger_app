import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';
import 'package:project/src/models/link_charger/bluetooth_charger_model.dart';

// Helpers.
import 'package:project/src/pages/private/link_charger/helpers/index.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/app/link_charger/common/index.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';
import 'package:project/src/widgets/generic/texts/text_not_found.dart';

class TabLinkChargerSelectCharger extends StatefulWidget {
  const TabLinkChargerSelectCharger({
    super.key
  });

  @override
  State<TabLinkChargerSelectCharger> createState() => _TabLinkChargerSelectChargerState();
}

class _TabLinkChargerSelectChargerState extends State<TabLinkChargerSelectCharger> {
  late LinkChargerBloc linkChargerBloc;
  late ScreenPropertiesModel screenProperties;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    linkChargerBloc = BlocProvider.linkChargerBloc(context);
    screenProperties = ScreenPropertiesModel(context: context);
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<void>(
    stream: linkChargerBloc.selectChargerChangesStream,
    builder: (BuildContext context, AsyncSnapshot<void> snapshot) => linkChargerBloc.isSearching
      ? LinkChargerWaiting(
        title: AppLocalizations.of(context)!.translate('charger_link_searching'),
        text: AppLocalizations.of(context)!.translate('charger_link_searching_text')
      )
      : _createContent()
  );

  // Method that creates the content of the list: the results and the search again link.
  Widget _createContent() => LinkChargerTabLayout(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Sizes.margin16,
      children: [
        linkChargerBloc.chargers.isEmpty
          ? const TextNotFound(topMargin: Sizes.margin20)
          : _createChargers(),
        LinkChargerSearchAgain(onClicked: _onSearchAgainClicked)
      ]
    ),
  );

  // Method that creates the items of the found chargers.
  Widget _createChargers() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Sizes.margin16,
    children: [
      _createDescription(),
      ...linkChargerBloc.chargers.asMap().entries.map((MapEntry<int, BluetoothChargerModel> entry) => ItemLinkChargerOption(
        index: entry.key,
        isLast: false,
        iconData: FontAwesomeIcons.plug,
        title: entry.value.name,
        subtitle: entry.value.model,
        isSelected: entry.value.id == linkChargerBloc.selectedChargerId,
        onClicked: () => _onChargerClicked(entry.value)
      ))
    ]
  );

  // Method that creates the chargers description.
  Widget _createDescription() => TextInter(
    text: AppLocalizations.of(context)!.translate('charger_link_select_text'),
    fontSize: screenProperties.fontSmall,
    color: CustomColors.textSecondary,
    fontWeight: FontWeight.w400
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks a charger of the list.
  void _onChargerClicked(BluetoothChargerModel charger) => linkChargerBloc.changeSelectedChargerId(charger.id);

  // Method that is called when the user clicks the search again link.
  void _onSearchAgainClicked() => HelperBluetooth.searchChargers(context: context);
}
