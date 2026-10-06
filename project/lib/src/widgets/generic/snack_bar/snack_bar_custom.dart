import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/texts/text_inter.dart';

class SnackBarCustom extends StatelessWidget {
  final String text;

  const SnackBarCustom({
    required this.text,
    super.key
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(Sizes.margin7, 0, Sizes.margin7, Sizes.margin20),
      padding: const EdgeInsets.fromLTRB(Sizes.margin16, Sizes.margin16, Sizes.margin16, Sizes.margin32),
      decoration: BoxDecoration(
        color: CustomColors.backgroundCard,
        borderRadius: BorderRadius.circular(Sizes.borderRadius20),
        border: Border.all(color: CustomColors.backgroundLine, width: Sizes.inputBorderSize)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _createHandle(),
          const SizedBox(height: Sizes.margin32),

          _createIcon(),
          const SizedBox(height: Sizes.margin12),

          TextInter(
            text: text,
            fontSize: Sizes.font14,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center
          )
        ]
      )
    )
  );

  // Method that creates the handle of the card.
  Widget _createHandle() => Container(
    width: Sizes.margin40,
    height: Sizes.margin4,
    decoration: BoxDecoration(
      color: CustomColors.backgroundLine,
      borderRadius: BorderRadius.circular(Sizes.borderRadius5)
    )
  );

  // Method that creates the success icon of the card.
  Widget _createIcon() => Container(
    width: Sizes.margin52,
    height: Sizes.margin52,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      color: CustomColors.lime12,
      shape: BoxShape.circle
    ),
    child: const Icon(
      Icons.check,
      color: CustomColors.lime,
      size: Sizes.font26
    )
  );
}
