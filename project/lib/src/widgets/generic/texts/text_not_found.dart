import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/utils/app_localizations.dart';

// Widgets.
import 'package:project/src/widgets/generic/texts/text_neue_haas.dart';

class TextNotFound extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final double topMargin;
  final double horizontalPadding;

  const TextNotFound({
    this.text,
    this.fontSize,
    this.topMargin = 0,
    this.horizontalPadding = Sizes.margin20,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final ScreenPropertiesModel screenProperties = ScreenPropertiesModel(context: context);

    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      margin: EdgeInsets.only(top: topMargin),
      child: TextNeueHaas(
        text: text ?? AppLocalizations.of(context)!.translate('results_not_found'),
        fontSize: fontSize ?? screenProperties.fontText,
        color: CustomColors.grayHomeItem,
        fontStyle: FontStyle.italic,
        textAlign: TextAlign.center,
      ),
    );
  }
}
