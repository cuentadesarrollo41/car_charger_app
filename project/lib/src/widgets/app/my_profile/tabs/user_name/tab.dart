import 'package:flutter/material.dart';
import 'package:project/src/widgets/generic/mixins/initial_load_handler.dart';

class TabUserName extends RefreshableWidget {
  const TabUserName({
    required super.refreshDateTime,
    super.key
  });

  @override
  State<TabUserName> createState() => _TabUserNameState();
}

class _TabUserNameState extends State<TabUserName> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
