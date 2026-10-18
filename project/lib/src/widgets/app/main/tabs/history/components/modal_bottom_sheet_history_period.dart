import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/src/widgets/generic/containers/card/card_container.dart';

// Helpers.
import '../helpers/index.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/history_periods.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/buttons/colored/button_colored_ghost.dart';
import 'package:project/src/widgets/generic/modal_bottom_sheets/modal_bottom_sheet_custom.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class ModalBottomSheetHistoryPeriod extends StatefulWidget {
  final String selectedPeriod;
  final void Function(String period) onPeriodSelected;

  const ModalBottomSheetHistoryPeriod({
    required this.selectedPeriod,
    required this.onPeriodSelected,
    super.key
  });

  @override
  State<ModalBottomSheetHistoryPeriod> createState() => _ModalBottomSheetHistoryPeriodState();
}

class _ModalBottomSheetHistoryPeriodState extends State<ModalBottomSheetHistoryPeriod> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return ModalBottomSheetCustom(
      title: AppLocalizations.of(context)!.translate('history_period'),
      closeButtonTopMargin: 0,
      bottomButtons: Container(),
      children: [
        _createTitle(),
        const SizedBox(height: Sizes.margin20),

        _createOptions(context: context, screenProperties: screenProperties),
        const SizedBox(height: Sizes.margin20),

        _createCancelButton()
      ]
    );
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }

  // Method that creates the title.
  Widget _createTitle() => TextInter(
    text: AppLocalizations.of(context)!.translate('history_period_text'),
    fontSize: screenProperties.fontExtraSmall,
    color: CustomColors.textSecondary
  );

  // Method that creates the period options.
  Widget _createOptions({ required BuildContext context, required ScreenPropertiesModel screenProperties }) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Sizes.margin10,
    children: HistoryPeriods.defaultList.map((String period) => _createOption(context: context, screenProperties: screenProperties, period: period)).toList()
  );

  // Method that creates a period option.
  Widget _createOption({ required BuildContext context, required ScreenPropertiesModel screenProperties, required String period }) => CardContainer(
    onClicked: () => widget.onPeriodSelected(period),
    color: Colors.white.withValues(alpha: 0.06),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextInter(
          text: AppLocalizations.of(context)!.translate(HelperHistoryPeriod.getPeriodKey(period)),
          fontSize: screenProperties.fontSmall
        ),

        if (period == widget.selectedPeriod) const FaIcon(
          FontAwesomeIcons.solidCircleCheck,
          color: CustomColors.lime,
          size: Sizes.font18
        )
      ]
    )
  );

  // Method that creates the cancel button.
  Widget _createCancelButton() => ButtonColoredGhost(
    text: AppLocalizations.of(context)!.translate('cancel'),
    fontSize: screenProperties.fontExtraSmall,
    mainAxisSize: MainAxisSize.max,
    onClicked: () => Navigator.pop(context)
  );
}
