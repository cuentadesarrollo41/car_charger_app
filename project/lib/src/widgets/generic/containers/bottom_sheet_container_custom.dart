import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

class BottomSheetContainerCustom extends StatelessWidget {
  final Widget child;
  final CrossAxisAlignment crossAxisAlignment;

  const BottomSheetContainerCustom({
    required this.child,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    super.key
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(
      Sizes.margin20,
      Sizes.margin24,
      Sizes.margin20,
      Sizes.margin24 + MediaQuery.of(context).padding.bottom
    ),
    decoration: BoxDecoration(
      color: CustomColors.backgroundCard,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(Sizes.borderRadius16)),
      border: Border.all(color: CustomColors.backgroundLine, width: Sizes.defaultBorderSize)
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Align(
          alignment: Alignment.center,
          child: _createHandle()
        ),
        const SizedBox(height: Sizes.margin24),

        Flexible(child: child)
      ]
    )
  );

  // Method that creates the handle.
  Widget _createHandle() => Container(
    width: Sizes.margin52,
    height: Sizes.margin5,
    decoration: BoxDecoration(
      color: CustomColors.backgroundLine,
      borderRadius: BorderRadius.circular(Sizes.borderRadius5)
    )
  );
}
