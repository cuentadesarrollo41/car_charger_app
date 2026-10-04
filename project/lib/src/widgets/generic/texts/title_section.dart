import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Widgets.
import 'package:project/src/widgets/generic/texts/text_neue_haas.dart';

class TitleSection extends StatelessWidget {
  final String text;
  final Color color;

  const TitleSection({
    required this.text,
    this.color = Colors.black,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final ScreenPropertiesModel screenProperties = ScreenPropertiesModel(context: context);

    return TextNeueHaas(
      text: text,
      fontSize: screenProperties.fontBigTitle,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }
}
