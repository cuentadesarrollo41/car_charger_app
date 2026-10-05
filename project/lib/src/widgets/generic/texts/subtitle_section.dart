import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';

// Widgets.
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class SubtitleSection extends StatelessWidget {
  final String text;
  final Color color;

  const SubtitleSection({
    required this.text,
    this.color = CustomColors.textSecondary,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final ScreenPropertiesModel screenProperties = ScreenPropertiesModel(context: context);

    return TextInter(
      text: text,
      fontSize: screenProperties.fontSmall,
      fontWeight: FontWeight.normal,
      color: color,
    );
  }
}
