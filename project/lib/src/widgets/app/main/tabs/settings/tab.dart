import 'package:flutter/material.dart';

// Widgets.
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';

class TabSettings extends RefreshableWidget {
  const TabSettings({
    required super.refreshDateTime,
    super.key
  });

  @override
  State<TabSettings> createState() => _TabChargingState();
}

class _TabChargingState extends State<TabSettings> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
