import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Models.
import 'package:project/src/models/charging_session_model.dart';
import 'package:project/src/models/generic/screen_properties_model.dart';

// Helpers.
import './helpers/index.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/utils/utils.dart';

// Widgets.
import 'package:project/src/widgets/app/common/item_charging_session.dart';
import 'package:project/src/widgets/app/common/modal_bottom_sheet_charging_session.dart';
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';
import 'package:project/src/widgets/generic/texts/text_not_found.dart';

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

  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (hasLoaded && historyListBloc.list.length < historyListBloc.count && scrollController.offset >= scrollController.position.maxScrollExtent && historyListBloc.loadingText.isEmpty) {
        hasLoaded = false;
        _getNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

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

  // Method that creates the content: the list of charging sessions, or the "no results" text.
  @override
  Widget buildContent() => StreamBuilder<List<ChargingSessionModel>>(
    stream: historyListBloc.listStream,
    builder: (BuildContext context, AsyncSnapshot<List<ChargingSessionModel>> snapshot) => StreamBuilder<String>(
      stream: historyListBloc.loadingTextStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        final List<ChargingSessionModel> chargingSessions = _getChargingSessions(context);
        final bool isSkeleton = Skeletonizer.maybeOf(context)?.enabled ?? false;

        if (chargingSessions.isEmpty) {
          return TextNotFound(text: AppLocalizations.of(context)!.translate('results_not_found'));
        }

        final bool isLoadingMore = historyListBloc.loadingText.isNotEmpty && historyListBloc.list.isNotEmpty;

        return ListView.builder(
          controller: isSkeleton ? null : scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: isLoadingMore ? chargingSessions.length + 1 : chargingSessions.length,
          itemBuilder: (BuildContext context, int index) => index == chargingSessions.length
            ? _createLoaderMore()
            : ItemChargingSession(
              index: index,
              isLast: index == chargingSessions.length - 1 && !isLoadingMore,
              chargingSession: chargingSessions[index],
              onClicked: () => _onChargingSessionClicked(chargingSessions[index])
            )
        );
      }
    )
  );

  // Method that creates the loader shown at the end of the list while the next page is loading.
  Widget _createLoaderMore() => const Padding(
    padding: EdgeInsets.only(top: Sizes.margin16, bottom: Sizes.defaultBottomMargin),
    child: Center(child: CircularProgressIndicator(color: CustomColors.lime))
  );

  // Method that returns the charging sessions to draw: the real ones or, while drawn as skeleton with an empty list, placeholder ones.
  List<ChargingSessionModel> _getChargingSessions(BuildContext context) {
    final bool isSkeleton = Skeletonizer.maybeOf(context)?.enabled ?? false;

    if (historyListBloc.list.isNotEmpty || !isSkeleton) {
      return historyListBloc.list;
    }

    return List<ChargingSessionModel>.generate(Numbers.skeletonPageListLength, (int index) => ChargingSessionModel());
  }

  // Method that loads the next page of charging sessions.
  void _getNextPage() => HelperGetChargingSessions.getNextPage(context: context, onFinished: () => hasLoaded = true);

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks a charging session: shows its detail.
  void _onChargingSessionClicked(ChargingSessionModel chargingSession) => Utils.showModalBottomSheetCustom(
    context: context,
    bottomSheet: ModalBottomSheetChargingSession(chargingSession: chargingSession)
  );
}
