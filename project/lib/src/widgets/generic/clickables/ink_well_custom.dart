import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';

class InkWellCustom extends StatelessWidget {
  final Widget child;
  final Color? hoverColor;

  final void Function()? onTap;
  final void Function(bool isHovering)? onHover;
  final void Function(bool isPressed)? onPressedChanged;

  const InkWellCustom({
    required this.onTap,
    required this.child,
    this.hoverColor,
    this.onHover,
    this.onPressedChanged,
    super.key
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    onTapDown: (TapDownDetails details) => onPressedChanged?.call(true),
    onTapUp: (TapUpDetails details) => onPressedChanged?.call(false),
    onTapCancel: () => onPressedChanged?.call(false),
    onHover: onHover,
    overlayColor: null,
    highlightColor: Colors.transparent,
    hoverColor: onHover == null
      ? Colors.transparent
      : hoverColor == null
        ? CustomColors.redSecondary80
        : hoverColor!,
    focusColor: Colors.transparent,
    splashColor: Colors.transparent,
    child: child,
  );
}
