import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/colored/button_colored_black.dart';
import 'package:project/src/widgets/generic/clickables/ink_well_custom.dart';
import 'package:project/src/widgets/generic/texts/title_page.dart';

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
          color: Colors.white,
          padding: const EdgeInsets.only(top: Sizes.margin20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _createLine(),
              const SizedBox(height: Sizes.margin16),

              _createTitle(),

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
  Widget _createLine() => Align(
    alignment: Alignment.center,
    child: Container(
      height: 6,
      width: 70,
      decoration: BoxDecoration(
        color: CustomColors.backgroundLine,
        borderRadius: BorderRadius.circular(Sizes.borderRadius20),
      ),
    ),
  );

  // Method that creates the title.
  Widget _createTitle() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Sizes.margin20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: Sizes.margin20,
      children: [
        Expanded(child: TitlePage(text: widget.title)),
        _createCloseIcon()
      ],
    ),
  );

  // Method that creates the close icon.
  Widget _createCloseIcon() => InkWellCustom(
    onTap: _onCloseButtonClicked,
    child: Container(
      padding: const EdgeInsets.all(Sizes.margin10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CustomColors.backgroundLine
      ),
      child: FaIcon(
        FontAwesomeIcons.xmark,
        size: Sizes.font14,
        color: Colors.black,
      )
    ),
  );

  // Method that creates the content.
  Widget _createContent() => Container(
    padding: const EdgeInsets.all(Sizes.margin20),
    child: ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      controller: widget.scrollController,
      children: [
        ...widget.children,
        SizedBox(height: widget.closeButtonTopMargin),

        widget.bottomButtons ?? _createCloseButton(),
      ]
    )
  );

  // Method that creates the close button.
  Widget _createCloseButton() => ButtonColoredBlack(
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
