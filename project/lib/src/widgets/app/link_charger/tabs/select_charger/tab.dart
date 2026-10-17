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
import 'package:project/src/widgets/app/link_charger/tabs/select_charger/components/index.dart';
import 'package:project/src/widgets/generic/clickables/ink_well_custom.dart';
import 'package:project/src/widgets/generic/containers/conditional_widget.dart';
import 'package:project/src/widgets/generic/texts/icon_text.dart';
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
  Widget build(BuildContext context) => StreamBuilder<bool>(
    stream: linkChargerBloc.isSearchingStream,
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) => (snapshot.data ?? linkChargerBloc.isSearching)
      ? LinkChargerWaiting(
        title: AppLocalizations.of(context)!.translate('charger_link_searching'),
        text: AppLocalizations.of(context)!.translate('charger_link_searching_text')
      )
      : _createList()
  );

  // Method that creates the list of found chargers.
  Widget _createList() => StreamBuilder<List<BluetoothChargerModel>>(
    stream: linkChargerBloc.chargersStream,
    builder: (BuildContext context, AsyncSnapshot<List<BluetoothChargerModel>> snapshot) => StreamBuilder<String>(
      stream: linkChargerBloc.selectedChargerIdStream,
      builder: (BuildContext context, AsyncSnapshot<String> selectedSnapshot) => LinkChargerTabLayout(
        child: _createContent(
          snapshot.data ?? linkChargerBloc.chargers,
          selectedSnapshot.data ?? linkChargerBloc.selectedChargerId
        )
      )
    )
  );

  // Method that creates the content of the list: the results and the search again link.
  Widget _createContent(List<BluetoothChargerModel> chargers, String selectedChargerId) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ConditionalWidget(
        showChild: chargers.isEmpty,
        createChild: () => const TextNotFound(topMargin: Sizes.margin20),
        createFallbackChild: () => _createChargers(chargers, selectedChargerId)
      ),

      const SizedBox(height: Sizes.margin16),
      _createSearchAgain()
    ]
  );

  // Method that creates the text and the items of the found chargers.
  Widget _createChargers(List<BluetoothChargerModel> chargers, String selectedChargerId) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextInter(
        text: AppLocalizations.of(context)!.translate('charger_link_select_text'),
        fontSize: screenProperties.fontSmall,
        color: CustomColors.textSecondary,
        fontWeight: FontWeight.w400
      ),
      const SizedBox(height: Sizes.margin16),

      ...chargers.asMap().entries.map((MapEntry<int, BluetoothChargerModel> entry) => ItemBluetoothCharger(
        index: entry.key,
        isLast: entry.key == chargers.length - 1,
        isSelected: entry.value.id == selectedChargerId,
        charger: entry.value,
        onClicked: () => _onChargerClicked(entry.value)
      ))
    ]
  );

  // Method that creates the link that starts a new search.
  Widget _createSearchAgain() => Center(
    child: InkWellCustom(
      onTap: _onSearchAgainClicked,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.margin8),
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

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks a charger of the list.
  void _onChargerClicked(BluetoothChargerModel charger) => linkChargerBloc.changeSelectedChargerId(charger.id);

  // Method that is called when the user clicks the search again link.
  void _onSearchAgainClicked() => HelperBluetooth.searchChargers(context: context);
}
