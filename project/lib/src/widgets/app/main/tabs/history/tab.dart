import 'package:flutter/material.dart';

// Widgets.
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';

class TabHistory extends RefreshableWidget {
  const TabHistory({
    required super.refreshDateTime,
    super.key
  });

  @override
  State<TabHistory> createState() => _TabChargingState();
}

class _TabChargingState extends State<TabHistory> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
