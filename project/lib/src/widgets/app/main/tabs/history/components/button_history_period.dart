import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Bloc.
import 'package:project/src/bloc/bloc_provider.dart';

// Helpers.
import '../helpers/index.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/ink_well_custom.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class ButtonHistoryPeriod extends StatelessWidget {
  final void Function() onClicked;

  const ButtonHistoryPeriod({
    required this.onClicked,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final HistoryBloc historyBloc = BlocProvider.historyBloc(context);
    final ScreenPropertiesModel screenProperties = ScreenPropertiesModel(context: context);

    return InkWellCustom(
      onTap: onClicked,
      child: Container(
        height: Sizes.margin32,
        padding: EdgeInsets.symmetric(horizontal: Sizes.margin16),
        decoration: BoxDecoration(
          color: CustomColors.backgroundGhost,
          borderRadius: BorderRadius.circular(Sizes.borderRadius30)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Sizes.margin8,
          children: [
            StreamBuilder<String>(
              stream: historyBloc.historyPeriodStream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) => TextInter(
                text: AppLocalizations.of(context)!.translate(HelperHistoryPeriod.getPeriodKey(historyBloc.historyPeriod)),
                fontSize: screenProperties.fontExtraSmall,
                fontWeight: FontWeight.w600
              )
            ),

            const FaIcon(
              FontAwesomeIcons.chevronDown,
              color: Colors.white,
              size: Sizes.font9
            )
          ]
        )
      )
    );
  }
}
