import 'package:flutter/material.dart';

// Models.
import 'package:project/src/models/generic/screen_properties_model.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

class DialogCustom extends StatelessWidget {
  final Widget child;

  const DialogCustom({
    required this.child,
    super.key
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: Center(
      child: Container(
        margin: const EdgeInsets.all(Sizes.margin24),
        padding: const EdgeInsets.all(Sizes.margin24),
        decoration: BoxDecoration(
          color: CustomColors.backgroundCard,
          border: BoxBorder.all(
            width: Sizes.defaultBorderSize,
            color: CustomColors.backgroundLine
          ),
          borderRadius: BorderRadius.circular(Sizes.borderRadius20),
        ),
        width: ScreenPropertiesModel(context: context).isPhone ? double.infinity : Sizes.maxWidthScreenPhone - 2 * Sizes.margin20,
        child: child
      ),
    ),
  );
}
