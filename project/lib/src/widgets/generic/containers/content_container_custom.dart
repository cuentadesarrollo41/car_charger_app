import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';

// Widgets.
import 'package:project/src/widgets/generic/texts/section_introduction_texts.dart';

class ContentContainerCustom extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool isListView;
  final bool isWhite;
  final Widget? titleExtraWidget;

  final void Function()? onTitleClicked;

  const ContentContainerCustom({
    required this.title,
    this.subtitle = Strings.emptyString,
    required this.child,
    this.isListView = true,
    this.isWhite = false,
    this.titleExtraWidget,
    this.onTitleClicked,
    super.key
  });

  @override
  State<ContentContainerCustom> createState() => _ContentContainerCustomState();
}

class _ContentContainerCustomState extends State<ContentContainerCustom> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return Container(
      margin: const EdgeInsets.only(top: Sizes.margin16),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
         if (widget.title.isNotEmpty || widget.subtitle.isNotEmpty) _createHeader(),
          SizedBox(height: widget.title.isNotEmpty || widget.subtitle.isNotEmpty ? Sizes.margin30 : 0),

          Expanded(child: _createContainer()),
        ],
      ),
    );
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the header.
  Widget _createHeader() => SectionIntroductionTexts(
    title: widget.title,
    subtitle: widget.subtitle,
    horizontalPadding: screenProperties.paddingCardHorizontal
  );

  // Method that creates container.
  Widget _createContainer() => ClipRRect(
    borderRadius: BorderRadiusGeometry.only(
      topLeft: Radius.circular(Sizes.borderRadius20),
      topRight: Radius.circular(Sizes.borderRadius20)
    ),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: screenProperties.paddingCardHorizontal,
        right: screenProperties.paddingCardHorizontal,
      ),
      decoration: BoxDecoration(
        color: widget.isWhite ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Sizes.borderRadius20)),
      ),
      child: widget.isListView
        ? SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.child,
              const SizedBox(height: Sizes.defaultBottomMargin)
            ],
          )
        )
        : widget.child,
    ),
  );
}
