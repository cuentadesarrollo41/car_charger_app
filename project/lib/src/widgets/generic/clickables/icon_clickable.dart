import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Widgets.
import 'package:project/src/widgets/generic/clickables/ink_well_custom.dart';

class IconClickable extends StatelessWidget {
  final FaIconData iconData;
  final double iconSize;
  final Color color;

  final void Function() onClicked;

  const IconClickable({
    required this.iconData,
    required this.iconSize,
    required this.onClicked,
    this.color = Colors.black,
    super.key
  });

  @override
  Widget build(BuildContext context) => InkWellCustom(
    onTap: onClicked,
    child: FaIcon(
      iconData,
      size: iconSize,
      color: color,
    )
  );
}
