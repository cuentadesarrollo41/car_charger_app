import 'package:rxdart/rxdart.dart';

// Models.
import 'package:project/src/models/link_charger/bluetooth_charger_model.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/constants/tabs.dart';

class LinkChargerBloc {
  final _tabController = BehaviorSubject<int>();
  final _refreshDateTimeController = BehaviorSubject<DateTime>();
  final _loadingTextController = BehaviorSubject<String>();
  final _isSearchingController = BehaviorSubject<bool>();
  final _chargersController = BehaviorSubject<List<BluetoothChargerModel>>();
  final _selectedChargerIdController = BehaviorSubject<String>();

  // Get values from Stream.
  Stream<int> get tabStream => _tabController.stream;
  Stream<DateTime> get refreshDateTimeStream => _refreshDateTimeController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;
  Stream<bool> get isSearchingStream => _isSearchingController.stream;
  Stream<List<BluetoothChargerModel>> get chargersStream => _chargersController.stream;
  Stream<String> get selectedChargerIdStream => _selectedChargerIdController.stream;

  // Set values to Stream.
  Function(int) get changeTab => _tabController.sink.add;
  Function(DateTime) get changeRefreshDateTime => _refreshDateTimeController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;
  Function(bool) get changeIsSearching => _isSearchingController.sink.add;
  Function(List<BluetoothChargerModel>) get changeChargers => _chargersController.sink.add;
  Function(String) get changeSelectedChargerId => _selectedChargerIdController.sink.add;

  // Get last values of the streams.
  int get tab => _tabController.value;
  DateTime get refreshDateTime => _refreshDateTimeController.value;
  String get loadingText => _loadingTextController.value;
  bool get isSearching => _isSearchingController.value;
  List<BluetoothChargerModel> get chargers => _chargersController.value;
  String get selectedChargerId => _selectedChargerIdController.value;

  // Get the charger selected in the list.
  BluetoothChargerModel? get selectedCharger {
    for (BluetoothChargerModel charger in chargers) {
      if (charger.id == selectedChargerId) {
        return charger;
      }
    }

    return null;
  }

  // Close Stream Controllers.
  void dispose() {
    _tabController.close();
    _refreshDateTimeController.close();
    _loadingTextController.close();
    _isSearchingController.close();
    _chargersController.close();
    _selectedChargerIdController.close();
  }

  // Reset fields.
  void reset() {
    changeTab(Tabs.linkStart);
    changeRefreshDateTime(DateTime.now());
    changeLoadingText(Strings.emptyString);
    changeIsSearching(false);
    changeChargers([]);
    changeSelectedChargerId(Strings.emptyString);
  }

  // Check if bloc is initialized.
  bool blocIsInit() => _loadingTextController.hasValue;
}
