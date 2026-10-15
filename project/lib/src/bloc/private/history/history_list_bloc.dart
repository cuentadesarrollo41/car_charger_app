import 'package:rxdart/rxdart.dart';

// Models.
import 'package:project/src/models/charging_session_model.dart';

// Commons.
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/strings.dart';

class HistoryListBloc {
  final _listController = BehaviorSubject<List<ChargingSessionModel>>();
  final _countController = BehaviorSubject<int>();
  final _pageController = BehaviorSubject<int>();
  final _refreshDateTimeController = BehaviorSubject<DateTime>();
  final _loadingTextController = BehaviorSubject<String>();

  // Get values from Stream.
  Stream<List<ChargingSessionModel>> get listStream => _listController.stream;
  Stream<int> get countStream => _countController.stream;
  Stream<int> get pageStream => _pageController.stream;
  Stream<DateTime> get refreshDateTimeStream => _refreshDateTimeController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;

  // Set values to Stream.
  Function(List<ChargingSessionModel>) get changeList => _listController.sink.add;
  Function(int) get changeCount => _countController.sink.add;
  Function(int) get changePage => _pageController.sink.add;
  Function(DateTime) get changeRefreshDateTime => _refreshDateTimeController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;

  // Get last values of the streams.
  List<ChargingSessionModel> get list => _listController.value;
  int get count => _countController.value;
  int get page => _pageController.value;
  DateTime get refreshDateTime => _refreshDateTimeController.value;
  String get loadingText => _loadingTextController.value;

  // Close Stream Controllers.
  void dispose() {
    _listController.close();
    _countController.close();
    _pageController.close();
    _refreshDateTimeController.close();
    _loadingTextController.close();
  }

  // Reset fields.
  void reset() {
    changeList([]);
    changeCount(Numbers.zero);
    changePage(Numbers.firstPage);
    changeRefreshDateTime(DateTime.now());
    changeLoadingText(Strings.emptyString);
  }

  // Check if bloc is initialized.
  bool blocIsInit() => _loadingTextController.hasValue;
}
