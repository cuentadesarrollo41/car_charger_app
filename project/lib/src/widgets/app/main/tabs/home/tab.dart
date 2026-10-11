import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';
import 'package:project/src/models/generic/session_model.dart';

// Helpers.
import './helpers/index.dart';

// Commons.
import 'package:project/src/commons/utils/app_localizations.dart';
import 'package:project/src/commons/constants/strings.dart';

// Widgets.
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';
import 'package:project/src/widgets/app/main/common/main_tab_layout.dart';

class TabHome extends RefreshableWidget {
  const TabHome({
    required super.refreshDateTime,
    super.key
  });

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  late StateBloc stateBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    stateBloc = BlocProvider.stateBloc(context);
  }

  @override
  Widget build(BuildContext context) => MainTabLayout(
    refreshDateTime: widget.refreshDateTime,
    title: AppLocalizations.of(context)!.translate('tab_home_title').replaceFirst(Strings.replaceCode, stateBloc.session.user.name),
    subtitle: AppLocalizations.of(context)!.translate('tab_home_subtitle'),
    getData: () => HelperInitialData.getData(stateBloc: stateBloc),
    handleResponse: (Map<String, dynamic> data) => HelperInitialData.handleGetDataResponse(
      data: data,
      setState: () => setState(() {})
    ),
    createContent: _createContent,
    useSkeleton: true,
  );

  // Method that creates the content when there is a linked charger.
  Widget _createContent() => StreamBuilder<SessionModel>(
    stream: stateBloc.sessionStream,
    builder: (BuildContext context, AsyncSnapshot<SessionModel> asyncSnapshot) => Container()
  );
}
