import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/containers/bottom_sheet_container_custom.dart';
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
    child: BottomSheetContainerCustom(
      crossAxisAlignment: CrossAxisAlignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
