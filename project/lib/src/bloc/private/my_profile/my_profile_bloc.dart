import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/constants/tabs.dart';

class MyProfileBloc {
  final _tabController = BehaviorSubject<int>();
  final _refreshDateTimeController = BehaviorSubject<DateTime>();
  final _loadingTextController = BehaviorSubject<String>();

  // Get values from Stream.
  Stream<int> get tabStream => _tabController.stream;
  Stream<DateTime> get refreshDateTimeStream => _refreshDateTimeController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;

  // Set values to Stream.
  Function(int) get changeTab => _tabController.sink.add;
  Function(DateTime) get changeRefreshDateTime => _refreshDateTimeController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;

  // Get last values of the streams.
  int get tab => _tabController.value;
  DateTime get refreshDateTime => _refreshDateTimeController.value;
  String get loadingText => _loadingTextController.value;

  // Close Stream Controllers.
  void dispose() {
    _tabController.close();
    _refreshDateTimeController.close();
    _loadingTextController.close();
  }

  // Reset fields.
  void reset() {
    changeTab(Tabs.home);
    changeRefreshDateTime(DateTime.now());
    changeLoadingText(Strings.emptyString);
  }

  // Check if bloc is initialized.
  bool blocIsInit() => _loadingTextController.hasValue;
}
