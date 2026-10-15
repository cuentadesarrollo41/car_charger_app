import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonCustom extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const SkeletonCustom({
    required this.child,
    this.enabled = true,
    super.key
  });

  @override
  Widget build(BuildContext context) => Skeletonizer(
    enabled: enabled,
    child: child
  );

  // Method that checks if the widget is being drawn inside an enabled skeleton.
  static bool isEnabled(BuildContext context) => Skeletonizer.maybeOf(context)?.enabled ?? false;

  // Method that returns the items to draw: the real ones or, while drawn as skeleton with no items, placeholder ones.
  static List<T> getItems<T>({ required BuildContext context, required List<T> items, required int length, required T Function() createPlaceholder }) => items.isNotEmpty || !isEnabled(context)
    ? items
    : List<T>.generate(length, (int index) => createPlaceholder());

  // Method that draws the whole child as a single skeleton piece (background included) while drawn as skeleton.
  static Widget leaf({ required Widget child }) => Skeleton.leaf(child: child);
}