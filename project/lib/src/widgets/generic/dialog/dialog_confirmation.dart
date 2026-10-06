import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/button_custom.dart';
import 'package:project/src/widgets/generic/clickables/buttons/colored/button_colored_ghost.dart';
import 'package:project/src/widgets/generic/dialog/dialog_custom.dart';
import 'package:project/src/widgets/generic/inputs/input_text_field.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';
import 'package:project/src/widgets/generic/texts/title_page.dart';

class DialogConfirmation extends StatefulWidget {
  final String title;
  final List<TextSpan> texts;
  final String inputTitle;
  final bool hasInput;
  final String inputHint;
  final String? cancelText;
  final String? confirmText;
  final bool showCancelButton;

  final void Function(String value) onConfirmButtonClicked;
  final void Function()? onCancelButtonClicked;

  const DialogConfirmation({
    required this.title,
    required this.texts,
    this.inputTitle = Strings.emptyString,
    this.hasInput = false,
    this.inputHint = Strings.emptyString,
    this.cancelText,
    this.confirmText,
    this.showCancelButton = true,
    required this.onConfirmButtonClicked,
    this.onCancelButtonClicked,
    super.key
  });

  @override
  State<DialogConfirmation> createState() => _DialogConfirmationState();
}

class _DialogConfirmationState extends State<DialogConfirmation> {
  late ScreenPropertiesModel screenProperties;

  late String observations;

  @override
  void initState() {
    observations = Strings.emptyString;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return PopScope(
      canPop: false,
      child: DialogCustom(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TitlePage(text: widget.title),

            if (widget.texts.isNotEmpty) const SizedBox(height: Sizes.margin4),
            if (widget.texts.isNotEmpty) _createText(),

            if (widget.hasInput) const SizedBox(height: Sizes.margin20),
            if (widget.hasInput) _createInput(),

            const SizedBox(height: Sizes.margin20),
            _createButtons()
          ],
        )
      ),
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
        fontSize: screenProperties.fontSmall,
        fontFamily: Strings.fontFamily,
        color: CustomColors.textSecondary
      ),
      children: widget.texts
    )
  );

  // Method that creates the input.
  Widget _createInput() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Sizes.margin8,
    children: [
      TextInter(
        text: widget.inputTitle,
        fontSize: screenProperties.fontText,
        fontWeight: FontWeight.w600,
      ),

      InputTextField(
        hint: widget.inputHint,
        textInputType: TextInputType.multiline,
        height: 3 * Sizes.inputHeight,
        minLines: 8,
        maxLines: 8,
        fontSize: screenProperties.fontText,
        borderColor: CustomColors.backgroundLine,
        onValueChanged: _onObservationsChanged
      ),
    ],
  );

  // Method that creates the buttons.
  Widget _createButtons() => Padding(
    padding: const EdgeInsets.only(top: Sizes.margin8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Sizes.margin16,
      children: [
        if (widget.showCancelButton) ButtonColoredGhost(
          text: widget.cancelText ?? AppLocalizations.of(context)!.translate('cancel'),
          fontSize: screenProperties.fontExtraSmall,
          height: Sizes.buttonHeightDialog,
          onClicked: _onCancelButtonClicked
        ),

        ButtonCustom(
          text: widget.confirmText ?? AppLocalizations.of(context)!.translate('confirm'),
          fontSize: screenProperties.fontExtraSmall,
          mainAxisSize: MainAxisSize.min,
          height: Sizes.buttonHeightDialog,
          onClicked: () => widget.onConfirmButtonClicked(observations)
        ),
      ],
    ),
  );

  // ***************************************************************************
  // On clicked.
  // ***************************************************************************
  void _onCancelButtonClicked() => widget.onCancelButtonClicked == null
    ? Navigator.pop(context)
    : widget.onCancelButtonClicked!();

  // ***************************************************************************
  // On change listeners.
  // ***************************************************************************
  void _onObservationsChanged(String value) => observations = value;
}
