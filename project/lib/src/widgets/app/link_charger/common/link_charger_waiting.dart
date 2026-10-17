import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/loaders/radar_custom.dart';
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class LinkChargerWaiting extends StatefulWidget {
  final String title;
  final String text;

  const LinkChargerWaiting({
    required this.title,
    required this.text,
    super.key
  });

  @override
  State<LinkChargerWaiting> createState() => _LinkChargerWaitingState();
}

class _LinkChargerWaitingState extends State<LinkChargerWaiting> {
  late ScreenPropertiesModel screenProperties;

  @override
  Widget build(BuildContext context) {
    _init();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenProperties.paddingCardHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadarCustom(size: screenProperties.size.width * Numbers.radarScreenWidthFactor),
          const SizedBox(height: Sizes.margin40),

          TextInter(
            text: widget.title,
            fontSize: screenProperties.fontSubtitle,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center
          ),
          const SizedBox(height: Sizes.margin12),

          TextInter(
            text: widget.text,
            fontSize: screenProperties.fontSmall,
            color: CustomColors.textSecondary,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center
          )
        ]
      )
    );
  }

  // Method that initializes the variables.
  void _init() {
    screenProperties = ScreenPropertiesModel(context: context);
  }
}
