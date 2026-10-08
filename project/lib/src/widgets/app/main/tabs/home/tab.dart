import 'package:flutter/material.dart';

// Widgets.
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';

class TabHome extends RefreshableWidget {
  const TabHome({
    required super.refreshDateTime,
    super.key
  });

  @override
  State<TabHome> createState() => _TabChargingState();
}

class _TabChargingState extends State<TabHome> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
