import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/app/main/common/container_charger_not_linked.dart';
import 'package:project/src/widgets/generic/containers/conditional_widget.dart';
import 'package:project/src/widgets/generic/containers/content_container_custom.dart';
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';

class MainTabLayout extends RefreshableWidget {
  final String title;
  final String subtitle;
  final Future<Map<String, dynamic>> Function() getData;
  final Widget Function() createContent;
  final void Function(Map<String, dynamic> data) handleResponse;
  final bool useSkeleton;

  const MainTabLayout({
    required super.refreshDateTime,
    required this.title,
    required this.subtitle,
    required this.getData,
    required this.createContent,
    required this.handleResponse,
    this.useSkeleton = false,
    super.key
  });

  @override
  State<MainTabLayout> createState() => _MainTabLayoutState();
}

class _MainTabLayoutState extends State<MainTabLayout> with InitialLoadHandler<MainTabLayout> {
  @override
  StateBloc get stateBloc => BlocProvider.stateBloc(context);

  @override
  bool get showLoader => false;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      ContentContainerCustom(
        title: widget.title,
        subtitle: widget.subtitle,
        isListView: false,
        child: Stack(
          children: [
            buildInitialDataContent(),

            Positioned.fill(
              child: ConditionalWidget(
                showChild: !hasLoaded && widget.useSkeleton,
                createChild: _createSkeleton
              )
            )
          ]
        )
      ),

      Positioned.fill(
        child: ConditionalWidget(
          showChild: !hasLoaded && !widget.useSkeleton,
          createChild: () => const Center(
            child: CircularProgressIndicator(color: CustomColors.lime)
          )
        )
      )
    ]
  );

  // Method that creates the skeleton shown while loading: the same content as once loaded, rendered as a skeleton.
  Widget _createSkeleton() => Skeletonizer(
    enabled: true,
    child: buildContent()
  );

  @override
  Future<Map<String, dynamic>> getData() => widget.getData();

  @override
  void handleResponse(Map<String, dynamic> data) {
    widget.handleResponse(data);

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  // Method that creates the content once the data is loaded: the tab content, or the "charger not linked" card.
  @override
  Widget buildContent() => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConditionalWidget(
          showChild: !hasLoaded || stateBloc.session.selectedChargerId.isNotEmpty,
          createChild: widget.createContent,
          createFallbackChild: () => const ContainerChargerNotLinked()
        ),
        const SizedBox(height: Sizes.defaultBottomMargin)
      ]
    )
  );
}
