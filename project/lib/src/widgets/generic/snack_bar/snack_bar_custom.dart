import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.only(
        left: Sizes.margin16,
        top: Sizes.margin16,
        right: Sizes.margin16,
        bottom: Sizes.margin32
      ),
      decoration: BoxDecoration(
        color: CustomColors.backgroundCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Sizes.borderRadius20)),
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
    width: Sizes.margin52,
    height: Sizes.margin6,
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
