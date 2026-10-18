import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';

// Widgets.
import 'package:project/src/widgets/app/main/common/container_charger_not_linked.dart';
import 'package:project/src/widgets/generic/containers/content_container_custom.dart';
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';
import 'package:project/src/widgets/generic/texts/section_introduction_texts.dart';

class MainTabLayout extends RefreshableWidget {
  final String title;
  final String subtitle;
  final Widget? titleExtraWidget;
  final Future<Map<String, dynamic>> Function() getData;
  final Widget Function() createContent;
  final void Function(Map<String, dynamic> data) handleResponse;
  final bool useSkeleton;
  final bool scrollHeader;

  const MainTabLayout({
    required super.refreshDateTime,
    required this.title,
    required this.subtitle,
    this.titleExtraWidget,
    required this.getData,
    required this.createContent,
    required this.handleResponse,
    this.useSkeleton = false,
    this.scrollHeader = false,
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
  bool get useSkeleton => widget.useSkeleton;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      ContentContainerCustom(
        title: widget.scrollHeader ? Strings.emptyString : widget.title,
        subtitle: widget.scrollHeader ? Strings.emptyString : widget.subtitle,
        titleExtraWidget: widget.scrollHeader ? null : widget.titleExtraWidget,
        isListView: false,
        child: buildInitialDataContent()
      ),

      if (!hasLoaded && !widget.useSkeleton) Positioned.fill(
        child: const Center(
          child: CircularProgressIndicator(color: CustomColors.lime)
        )
      )
    ]
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
        if (widget.scrollHeader) _createHeader(),

        !hasLoaded || stateBloc.session.selectedChargerId.isNotEmpty
          ? widget.createContent()
          : const ContainerChargerNotLinked(),

        const SizedBox(height: Sizes.defaultBottomMargin)
      ]
    )
  );

  // Method that creates the header inside the scroll: title, subtitle and the extra widget.
  Widget _createHeader() => Padding(
    padding: const EdgeInsets.only(bottom: Sizes.margin30),
    child: SectionIntroductionTexts(
      title: widget.title,
      subtitle: widget.subtitle,
      extraWidget: widget.titleExtraWidget
    )
  );
}
