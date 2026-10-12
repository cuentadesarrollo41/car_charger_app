import 'package:flutter/material.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Helpers.
import './helpers/index.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';

// Widgets.
import './components/index.dart';
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';
import 'package:project/src/widgets/generic/containers/content_container_custom.dart';

class TabMyProfileHome extends RefreshableWidget {
  const TabMyProfileHome({
    required super.refreshDateTime,
    super.key
  });

  @override
  State<TabMyProfileHome> createState() => _TabMyProfileHomeState();
}

class _TabMyProfileHomeState extends State<TabMyProfileHome> with InitialLoadHandler<TabMyProfileHome> {
  late ScreenPropertiesModel screenProperties;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenProperties = ScreenPropertiesModel(context: context);
  }

  @override
  StateBloc get stateBloc => BlocProvider.stateBloc(context);

  @override
  bool get useSkeleton => true;

  @override
  Widget build(BuildContext context) => buildInitialDataContent();

  @override
  Future<Map<String, dynamic>> getData() => HelperInitialData.getData(stateBloc: stateBloc);

  @override
  void handleResponse(Map<String, dynamic> data) => HelperInitialData.handleGetDataResponse(
    changeHasLoaded: (bool value) => hasLoaded = value,
    setState: () => setState(() {})
  );

  // Method that creates the content once the data is loaded.
  @override
  Widget buildContent() => ContentContainerCustom(
    title: Strings.emptyString,
    child: Column(
      children: const [
        SectionEmail(),
        SizedBox(height: Sizes.margin20),

        SectionManagement()
      ]
    )
  );
}
