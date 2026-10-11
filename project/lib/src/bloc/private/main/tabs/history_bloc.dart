import 'package:rxdart/rxdart.dart';

// Models.
import 'package:project/src/models/charging_session_model.dart';

// Commons.
import 'package:project/src/commons/constants/history_periods.dart';
import 'package:project/src/commons/constants/strings.dart';

class HistoryBloc {
  final _historyPeriodController = BehaviorSubject<String>();
  final _energyListController = BehaviorSubject<List<int>>();
  final _listController = BehaviorSubject<List<ChargingSessionModel>>();
  final _refreshDateTimeController = BehaviorSubject<DateTime>();
  final _loadingTextController = BehaviorSubject<String>();

  // Get values from Stream.
  Stream<String> get historyPeriodStream => _historyPeriodController.stream;
  Stream<List<int>> get energyListStream => _energyListController.stream;
  Stream<List<ChargingSessionModel>> get listStream => _listController.stream;
  Stream<DateTime> get refreshDateTimeStream => _refreshDateTimeController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;

  // Set values to Stream.
  Function(String) get changeHistoryPeriod => _historyPeriodController.sink.add;
  Function(List<int>) get changeEnergyList => _energyListController.sink.add;
  Function(List<ChargingSessionModel>) get changeList => _listController.sink.add;
  Function(DateTime) get changeRefreshDateTime => _refreshDateTimeController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;

  // Get last values of the streams.
  String get historyPeriod => _historyPeriodController.value;
  List<int> get energyList => _energyListController.value;
  List<ChargingSessionModel> get list => _listController.value;
  DateTime get refreshDateTime => _refreshDateTimeController.value;
  String get loadingText => _loadingTextController.value;

  // Close Stream Controllers.
  void dispose() {
    _historyPeriodController.close();
    _energyListController.close();
    _listController.close();
    _refreshDateTimeController.close();
    _loadingTextController.close();
  }

  // Reset fields.
  void reset() {
    changeHistoryPeriod(HistoryPeriods.week);
    changeEnergyList([]);
    changeList([]);
    changeRefreshDateTime(DateTime.now());
    changeLoadingText(Strings.emptyString);
  }

  // Check if bloc is initialized.
  bool blocIsInit() => _loadingTextController.hasValue;
}
