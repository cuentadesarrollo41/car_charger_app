import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/charging_session_model.dart';
import 'package:project/src/models/generic/screen_properties_model.dart';

// Helpers.
import './helpers/index.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import 'package:project/src/widgets/app/common/item_charging_session.dart';
import 'package:project/src/widgets/app/common/modal_bottom_sheet_charging_session.dart';
import 'package:project/src/widgets/generic/list/paginated_list_view_custom.dart';
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';
import 'package:project/src/widgets/generic/texts/section_introduction_texts.dart';

class HistoryContent extends RefreshableWidget {
  const HistoryContent({
    required super.refreshDateTime,
    super.key
  });

  @override
  State<HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<HistoryContent> with InitialLoadHandler<HistoryContent> {
  late HistoryListBloc historyListBloc;

  late ScreenPropertiesModel screenProperties;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    historyListBloc = BlocProvider.historyListBloc(context);
    screenProperties = ScreenPropertiesModel(context: context);
  }

  @override
  StateBloc get stateBloc => BlocProvider.stateBloc(context);

  @override
  bool get useSkeleton => true;

  @override
  Widget build(BuildContext context) => buildInitialDataContent();

  @override
  Future<Map<String, dynamic>> getData() => HelperInitialData.getData(stateBloc: stateBloc, historyListBloc: historyListBloc);

  @override
  void handleResponse(Map<String, dynamic> data) => HelperInitialData.handleGetDataResponse(
    historyListBloc: historyListBloc,
    data: data,
    changeHasLoaded: (bool value) => hasLoaded = value,
    setState: () => setState(() {})
  );

  // Method that creates the content: the header and the paginated list of charging sessions.
  @override
  Widget buildContent() => PaginatedListViewCustom<ChargingSessionModel>(
    itemsStream: historyListBloc.listStream,
    loadingTextStream: historyListBloc.loadingTextStream,
    getCount: () => historyListBloc.count,
    onLoadMore: () => HelperGetChargingSessions.getNextPage(context: context),
    createPlaceholder: () => ChargingSessionModel(),
    emptyText: AppLocalizations.of(context)!.translate('results_not_found'),
    padding: EdgeInsets.only(
      left: screenProperties.paddingCardHorizontal,
      top: Sizes.margin16,
      right: screenProperties.paddingCardHorizontal,
      bottom: Sizes.defaultBottomMargin
    ),
    header: _createHeader(),
    createItem: (ChargingSessionModel chargingSession, int index, bool isLast) => ItemChargingSession(
      index: index,
      isLast: isLast,
      chargingSession: chargingSession,
      onClicked: () => _onChargingSessionClicked(chargingSession)
    )
  );

  // Method that creates the header: title and subtitle.
  Widget _createHeader() => Padding(
    padding: const EdgeInsets.only(bottom: Sizes.margin30),
    child: SectionIntroductionTexts(
      title: AppLocalizations.of(context)!.translate('charging_activity'),
      subtitle: AppLocalizations.of(context)!.translate('charging_activity_text')
    )
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks a charging session: shows its detail.
  void _onChargingSessionClicked(ChargingSessionModel chargingSession) => Utils.showModalBottomSheetCustom(
    context: context,
    bottomSheet: ModalBottomSheetChargingSession(chargingSession: chargingSession)
  );
}
