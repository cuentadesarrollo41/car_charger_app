import 'package:flutter/material.dart';

class ConditionalWidget extends StatelessWidget {
  final bool showChild;
  final Widget Function() createChild;
  final Widget Function()? createFallbackChild;

  const ConditionalWidget({
    required this.showChild,
    required this.createChild,
    this.createFallbackChild,
    super.key
  });

  @override
  Widget build(BuildContext context) => showChild
    ? createChild()
    : createFallbackChild == null
      ? Container()
      : createFallbackChild!()
    ;
}
