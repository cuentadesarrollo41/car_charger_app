import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/charging_session_model.dart';
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/routes.dart';
import 'package:project/src/commons/utils/utils.dart';

// Pages.
import 'package:project/src/pages/index.dart';

// Widgets.
import 'package:project/src/widgets/app/common/item_charging_session.dart';
import 'package:project/src/widgets/app/common/modal_bottom_sheet_charging_session.dart';
import 'package:project/src/widgets/generic/clickables/text_clickable.dart';
import 'package:project/src/widgets/generic/loaders/skeleton_custom.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class SectionLastCharges extends StatefulWidget {
  const SectionLastCharges({
    super.key
  });

  @override
  State<SectionLastCharges> createState() => _SectionLastChargesState();
}

class _SectionLastChargesState extends State<SectionLastCharges> {
  late HistoryBloc historyBloc;

  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Sizes.margin14,
      children: [
        _createHeader(),
        _createList()
      ]
    );
  }

  // Method that initializes the variables.
  void _init() {
    historyBloc = BlocProvider.historyBloc(context);
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the header.
  Widget _createHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      TextInter(
        text: AppLocalizations.of(context)!.translate('charging_last'),
        fontSize: screenProperties.fontText,
        fontWeight: FontWeight.w700
      ),

      TextClickable(
        text: AppLocalizations.of(context)!.translate('view_all'),
        fontSize: screenProperties.fontExtraSmall,
        color: CustomColors.lime,
        onClicked: _onViewAllClicked
      )
    ]
  );

  // Method that creates the list of charging sessions.
  Widget _createList() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: _getChargingSessions().asMap().entries.map((MapEntry<int, ChargingSessionModel> entry) => ItemChargingSession(
      index: entry.key,
      isLast: false,
      chargingSession: entry.value,
      onClicked: () => _onChargingSessionClicked(entry.value)
    )).toList()
  );

  // Method that returns the charging sessions to draw: the real ones or, while loading as skeleton with no data yet, placeholder ones.
  List<ChargingSessionModel> _getChargingSessions() => SkeletonCustom.getItems<ChargingSessionModel>(
    context: context,
    items: historyBloc.list,
    length: Numbers.skeletonListLength,
    createPlaceholder: () => ChargingSessionModel()
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks "view all": opens the history page.
  void _onViewAllClicked() => Utils.navigatorPush(context: context, child: const HistoryPage(), routeName: Routes.history);

  // Method that is called when the user clicks a charging session: shows its detail.
  void _onChargingSessionClicked(ChargingSessionModel chargingSession) => Utils.showModalBottomSheetCustom(
    context: context,
    bottomSheet: ModalBottomSheetChargingSession(chargingSession: chargingSession)
  );
}
