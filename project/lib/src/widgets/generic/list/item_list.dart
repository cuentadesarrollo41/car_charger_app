import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/ink_well_custom.dart';

class ItemList extends StatelessWidget {
  final int index;
  final Widget child;
  final bool isLast;
  final double width;

  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double marginBottom;

  final void Function()? onClicked;

  const ItemList({
    required this.index,
    required this.child,
    required this.isLast,
    this.width = double.infinity,
    this.marginLeft = Sizes.margin20,
    this.marginRight = Sizes.margin20,
    this.marginTop = Sizes.margin16,
    this.marginBottom = Sizes.margin8,
    this.onClicked,
    super.key
  });

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    margin: EdgeInsets.only(
      left: marginLeft,
      right: marginRight,
      top: index == 0 ? marginTop : 0,
      bottom: isLast ? Sizes.defaultBottomMargin : marginBottom,
    ),
    child: InkWellCustom(
      onTap: onClicked,
      child: child
    )
  );
}
