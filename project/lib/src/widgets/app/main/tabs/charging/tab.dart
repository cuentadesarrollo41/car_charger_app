import 'package:flutter/material.dart';

// Widgets.
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';

class TabCharging extends RefreshableWidget {
  const TabCharging({
    required super.refreshDateTime,
    super.key
  });

  @override
  State<TabCharging> createState() => _TabChargingState();
}

class _TabChargingState extends State<TabCharging> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
