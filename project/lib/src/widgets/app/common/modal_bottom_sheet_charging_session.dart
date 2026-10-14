import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/charging_session_model.dart';
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/colored/button_colored_ghost.dart';
import 'package:project/src/widgets/generic/modal_bottom_sheets/modal_bottom_sheet_custom.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class ModalBottomSheetChargingSession extends StatefulWidget {
  final ChargingSessionModel chargingSession;

  const ModalBottomSheetChargingSession({
    required this.chargingSession,
    super.key
  });

  @override
  State<ModalBottomSheetChargingSession> createState() => _ModalBottomSheetChargingSessionState();
}

class _ModalBottomSheetChargingSessionState extends State<ModalBottomSheetChargingSession> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return ModalBottomSheetCustom(
      title: AppLocalizations.of(context)!.translate('charging_session_detail'),
      closeButtonTopMargin: 0,
      bottomButtons: Container(),
      children: [
        _createSubtitle(),
        const SizedBox(height: Sizes.margin16),

        _createRow(label: AppLocalizations.of(context)!.translate('start_end'), value: widget.chargingSession.getTime()),
        _createRow(label: AppLocalizations.of(context)!.translate('energy'), value: widget.chargingSession.getEnergy(context: context)),
        const SizedBox(height: Sizes.margin24),

        _createCloseButton()
      ]
    );
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the subtitle.
  Widget _createSubtitle() => TextInter(
    text: widget.chargingSession.getTitle(context: context),
    fontSize: screenProperties.fontExtraSmall,
    color: CustomColors.textSecondary
  );

  // Method that creates a row with a label and a value.
  Widget _createRow({ required String label, required String value }) => Container(
    constraints: const BoxConstraints(minHeight: Sizes.inputHeight * 1.1),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: CustomColors.backgroundLine,
          width: Sizes.defaultBorderSize
        )
      )
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: Sizes.margin16,
      children: [
        TextInter(text: label, fontSize: screenProperties.fontExtraSmall, color: CustomColors.textSecondary),
        Flexible(child: TextInter(text: value, fontSize: screenProperties.fontExtraSmall, fontWeight: FontWeight.w700, textAlign: TextAlign.end))
      ]
    )
  );

  // Method that creates the close button.
  Widget _createCloseButton() => ButtonColoredGhost(
    text: AppLocalizations.of(context)!.translate('close'),
    fontSize: screenProperties.fontExtraSmall,
    mainAxisSize: MainAxisSize.max,
    onClicked: () => Navigator.pop(context)
  );
}
