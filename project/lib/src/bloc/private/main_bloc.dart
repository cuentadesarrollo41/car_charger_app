import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/constants/tabs.dart';

class MainBloc {
  final _tabController = BehaviorSubject<String>();
  final _titleController = BehaviorSubject<String>();
  final _tabsExtraContentController = BehaviorSubject<Widget?>();
  final _loadingTextController = BehaviorSubject<String>();

  // Get values from Stream.
  Stream<String> get tabStream => _tabController.stream;
  Stream<String> get titleStream => _titleController.stream;
  Stream<Widget?> get tabsExtraContentStream => _tabsExtraContentController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;

  // Set values to Stream.
  Function(String) get changeTab => _tabController.sink.add;
  Function(String) get changeTitle => _titleController.sink.add;
  Function(Widget?) get changeTabsExtraContent => _tabsExtraContentController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;

  // Get last values of the streams.
  String get tab => _tabController.value;
  String get title => _titleController.value;
  Widget? get tabsExtraContent => _tabsExtraContentController.value;
  String get loadingText => _loadingTextController.value;

  // Close Stream Controllers.
  void dispose() {
    _tabController.close();
    _titleController.close();
    _tabsExtraContentController.close();
    _loadingTextController.close();
  }

  // Reset fields.
  void reset(String title) {
    changeTab(Tabs.home);
    changeTitle(title);
    changeTabsExtraContent(null);
    changeLoadingText(Strings.emptyString);
  }

  // Check if bloc is initialized.
  bool blocIsInit() => _loadingTextController.hasValue;
}
