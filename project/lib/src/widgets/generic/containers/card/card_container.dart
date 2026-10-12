import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/containers/conditional_widget.dart';
import './card_custom.dart';

class CardContainer extends StatelessWidget {
  final double verticalPadding;
  final double horizontalPadding;
  final Widget child;
  final double borderRadius;
  final double elevation;
  final Color color;
  final Color borderColor;
  final bool dashedBorder;

  final void Function()? onClicked;

  const CardContainer({
    this.verticalPadding = Sizes.margin20,
    this.horizontalPadding = Sizes.margin20,
    required this.child,
    this.borderRadius = Sizes.borderRadius16,
    this.elevation = 0,
    this.color = CustomColors.backgroundCard,
    this.borderColor = CustomColors.backgroundLine,
    this.dashedBorder = false,
    this.onClicked,
    super.key
  });

  @override
  Widget build(BuildContext context) => CardCustom(
    onClicked: onClicked,
    borderRadius: borderRadius,
    elevation: elevation,
    color: color,
    borderColor: dashedBorder ? Colors.transparent : borderColor,
    child: ConditionalWidget(
      showChild: dashedBorder,
      createChild: () => DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: Radius.circular(borderRadius),
          color: borderColor,
          strokeWidth: Sizes.defaultBorderSize,
          dashPattern: const [ Sizes.dashLength, Sizes.dashGap ],
          padding: EdgeInsets.zero
        ),
        child: _createContent()
      ),
      createFallbackChild: _createContent
    )
  );

  // Method that creates the content.
  Widget _createContent() => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(
      vertical: verticalPadding,
      horizontal: horizontalPadding
    ),
    child: child
  );
}
