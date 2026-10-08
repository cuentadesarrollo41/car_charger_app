import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/colored/button_colored_ghost.dart';
import 'package:project/src/widgets/generic/clickables/buttons/colored/button_colored_green.dart';
import 'package:project/src/widgets/generic/clickables/buttons/colored/button_colored_red.dart';
import 'package:project/src/widgets/generic/modal_bottom_sheets/modal_bottom_sheet_custom.dart';

class ModalBottomSheetConfirmation extends StatefulWidget {
  final String title;
  final List<TextSpan> texts;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final Color primaryButtonColor;
  final Color secondaryButtonColor;

  final void Function()? onPrimaryButtonClicked;
  final void Function()? onSecondaryButtonClicked;

  const ModalBottomSheetConfirmation({
    required this.title,
    required this.texts,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.primaryButtonColor = CustomColors.lime,
    this.secondaryButtonColor = CustomColors.backgroundGhost,
    required this.onPrimaryButtonClicked,
    required this.onSecondaryButtonClicked,
    super.key
  });

  @override
  State<ModalBottomSheetConfirmation> createState() => _ModalBottomSheetConfirmationState();
}

class _ModalBottomSheetConfirmationState extends State<ModalBottomSheetConfirmation> {
  late ScreenPropertiesModel screenProperties;

  late String state;

  @override
  void initState() {
    state = Strings.emptyString;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return ModalBottomSheetCustom(
      title: widget.title,
      closeButtonTopMargin: 0,
      bottomButtons: Container(),
      children: [
        _createText(),
        const SizedBox(height: Sizes.margin32),

        _createStateButtons(),
      ]
    );
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the text.
  Widget _createText() => RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: screenProperties.fontText,
        fontFamily: Strings.fontFamily,
        color: CustomColors.textSecondary
      ),
      children: widget.texts
    )
  );

  // Method that creates the state buttons.
  Widget _createStateButtons() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Sizes.margin16,
    children: [
      if (widget.onPrimaryButtonClicked != null) _createButton(widget.primaryButtonColor, widget.primaryButtonText ?? AppLocalizations.of(context)!.translate('state_ok'), widget.onPrimaryButtonClicked),
      if (widget.onSecondaryButtonClicked != null) _createButton(widget.secondaryButtonColor, widget.secondaryButtonText ?? AppLocalizations.of(context)!.translate('state_ko'), widget.onSecondaryButtonClicked),
    ],
  );

  // Method that creates a button.
  Widget _createButton(Color color, String text, void Function()? onClicked) {
    switch (color) {
      case CustomColors.lime: return _createLimeButton(text, onClicked);
      case CustomColors.backgroundGhost: return _createGhostButton(text, onClicked);
      case CustomColors.redDark: return _createRedButton(text, onClicked);
      default: return Container();
    }
  }

  // Method that creates the lime button.
  Widget _createLimeButton(String text, void Function()? onClicked) => ButtonColoredGreen(
    text: text,
    fontSize: screenProperties.fontSmall,
    mainAxisSize: MainAxisSize.max,
    onClicked: onClicked
  );

  // Method that creates the ghost button.
  Widget _createGhostButton(String text, void Function()? onClicked) => ButtonColoredGhost(
    text: text,
    fontSize: screenProperties.fontSmall,
    mainAxisSize: MainAxisSize.max,
    onClicked: onClicked
  );

  // Method that creates the red button.
  Widget _createRedButton(String text, void Function()? onClicked) => ButtonColoredRed(
    text: text,
    fontSize: screenProperties.fontSmall,
    mainAxisSize: MainAxisSize.max,
    onClicked: onClicked
  );
}
