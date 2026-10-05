import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/colored/button_colored_green.dart';
import 'package:project/src/widgets/generic/clickables/buttons/colored/button_colored_red.dart';
import 'package:project/src/widgets/generic/modal_bottom_sheets/modal_bottom_sheet_custom.dart';

class ModalBottomSheetConfirmation extends StatefulWidget {
  final String title;
  final List<TextSpan> texts;
  final String? confirmationButtonText;
  final String? cancelButtonText;

  final void Function()? onConfirmButtonClicked;
  final void Function()? onCancelButtonClicked;

  const ModalBottomSheetConfirmation({
    required this.title,
    required this.texts,
    this.confirmationButtonText,
    this.cancelButtonText,
    required this.onConfirmButtonClicked,
    required this.onCancelButtonClicked,
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
    textAlign: TextAlign.center,
    text: TextSpan(
      style: TextStyle(
        fontSize: screenProperties.fontText,
        fontFamily: Strings.fontFamily,
        color: Colors.black
      ),
      children: widget.texts
    )
  );

  // Method that creates the state buttons.
  Widget _createStateButtons() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Sizes.margin8,
    children: [
      if (widget.onConfirmButtonClicked != null) _createConfirmationButton(),
      if (widget.onCancelButtonClicked != null) _createCancelButton(),
    ],
  );

  // Method that creates the confirmation button.
  Widget _createConfirmationButton() => ButtonColoredGreen(
    text: widget.confirmationButtonText ?? AppLocalizations.of(context)!.translate('state_ok'),
    fontSize: screenProperties.fontSmall,
    onClicked: widget.onConfirmButtonClicked
  );

  // Method that creates the cancel button.
  Widget _createCancelButton() => ButtonColoredRed(
    text: widget.cancelButtonText ?? AppLocalizations.of(context)!.translate('state_ko'),
    fontSize: screenProperties.fontSmall,
    onClicked: widget.onCancelButtonClicked
  );
}
