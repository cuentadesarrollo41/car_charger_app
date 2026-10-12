import 'package:flutter/material.dart';
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';

class TabUpdatePassword extends RefreshableWidget {
  const TabUpdatePassword({
    required super.refreshDateTime,
    super.key
  });

  @override
  State<TabUpdatePassword> createState() => _TabUpdatePasswordState();
}

class _TabUpdatePasswordState extends State<TabUpdatePassword> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
