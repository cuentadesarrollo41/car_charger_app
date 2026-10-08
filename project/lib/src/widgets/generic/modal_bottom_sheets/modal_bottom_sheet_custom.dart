import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/colored/button_colored_ghost.dart';
import 'package:project/src/widgets/generic/texts/title_section.dart';

class ModalBottomSheetCustom extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final ScrollController? scrollController;
  final double closeButtonTopMargin;
  final Widget? bottomButtons;

  const ModalBottomSheetCustom({
    required this.title,
    required this.children,
    this.scrollController,
    this.closeButtonTopMargin = Sizes.margin20,
    this.bottomButtons,
    super.key
  });

  @override
  State<ModalBottomSheetCustom> createState() => _ModalBottomSheetCustomState();
}

class _ModalBottomSheetCustomState extends State<ModalBottomSheetCustom> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return ClipRRect(
      borderRadius: BorderRadius.circular(Sizes.borderRadius20),
      child: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          color: CustomColors.backgroundCard,
          padding: EdgeInsets.only(
            left: screenProperties.paddingCardHorizontal,
            top: Sizes.margin16,
            right: screenProperties.paddingCardHorizontal,
            bottom: Sizes.margin32
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _createHandle(),
              const SizedBox(height: Sizes.margin16),

              TitleSection(text: widget.title),
              const SizedBox(height: Sizes.margin4),

              Flexible(child: _createContent()),
            ],
          )
        ),
      ),
    );
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the line.
  Widget _createHandle() => Align(
    alignment: Alignment.center,
    child: Container(
      width: Sizes.margin52,
      height: Sizes.margin6,
      decoration: BoxDecoration(
        color: CustomColors.backgroundLine,
        borderRadius: BorderRadius.circular(Sizes.borderRadius5)
      )
    ),
  );

  // Method that creates the content.
  Widget _createContent() => ListView(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    controller: widget.scrollController,
    children: [
      ...widget.children,
      SizedBox(height: widget.closeButtonTopMargin),

      widget.bottomButtons ?? _createCloseButton(),
    ]
  );

  // Method that creates the close button.
  Widget _createCloseButton() => ButtonColoredGhost(
    text: AppLocalizations.of(context)!.translate('close'),
    fontSize: screenProperties.fontSmall,
    mainAxisSize: MainAxisSize.max,
    onClicked: _onCloseButtonClicked,
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  // Method that is called when the user clicks the back button.
  void _onCloseButtonClicked() => Navigator.pop(context);
}
