import 'package:rxdart/rxdart.dart';

// Models.
import 'package:project/src/models/charger_model.dart';
import 'package:project/src/models/link_charger/bluetooth_charger_model.dart';
import 'package:project/src/models/link_charger/charger_provisioning_model.dart';
import 'package:project/src/models/link_charger/wifi_network_model.dart';

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
  final _isLoadingNetworksController = BehaviorSubject<bool>();
  final _networksController = BehaviorSubject<List<WifiNetworkModel>>();
  final _currentNetworkNameController = BehaviorSubject<String>();
  final _selectedNetworkSsidController = BehaviorSubject<String>();
  final _isOtherNetworkController = BehaviorSubject<bool>();
  final _otherNetworkNameController = BehaviorSubject<String>();
  final _networkPasswordController = BehaviorSubject<String>();
  final _linkedChargerController = BehaviorSubject<ChargerModel>();
  final _chargerProvisioningController = BehaviorSubject<ChargerProvisioningModel>();

  // Get values from Stream.
  Stream<int> get tabStream => _tabController.stream;
  Stream<DateTime> get refreshDateTimeStream => _refreshDateTimeController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;
  Stream<bool> get isSearchingStream => _isSearchingController.stream;
  Stream<List<BluetoothChargerModel>> get chargersStream => _chargersController.stream;
  Stream<String> get selectedChargerIdStream => _selectedChargerIdController.stream;
  Stream<bool> get isLoadingNetworksStream => _isLoadingNetworksController.stream;
  Stream<List<WifiNetworkModel>> get networksStream => _networksController.stream;
  Stream<String> get currentNetworkNameStream => _currentNetworkNameController.stream;
  Stream<String> get selectedNetworkSsidStream => _selectedNetworkSsidController.stream;
  Stream<bool> get isOtherNetworkStream => _isOtherNetworkController.stream;
  Stream<String> get otherNetworkNameStream => _otherNetworkNameController.stream;
  Stream<String> get networkPasswordStream => _networkPasswordController.stream;
  Stream<ChargerModel> get linkedChargerStream => _linkedChargerController.stream;
  Stream<ChargerProvisioningModel> get chargerProvisioningStream => _chargerProvisioningController.stream;

  // Merged streams: they emit whenever any of their values changes, so a single StreamBuilder can rebuild a widget that depends on several values. They are broadcast, so several StreamBuilders (or the same one recreated) can listen to them.
  late final Stream<void> pageChangesStream = Rx.merge<void>([ tabStream, isSearchingStream ]).asBroadcastStream();
  late final Stream<void> selectChargerChangesStream = Rx.merge<void>([ isSearchingStream, chargersStream, selectedChargerIdStream ]).asBroadcastStream();
  late final Stream<void> selectNetworkChangesStream = Rx.merge<void>([
    isLoadingNetworksStream,
    networksStream,
    currentNetworkNameStream,
    selectedNetworkSsidStream,
    isOtherNetworkStream
  ]).asBroadcastStream();

  // Set values to Stream.
  Function(int) get changeTab => _tabController.sink.add;
  Function(DateTime) get changeRefreshDateTime => _refreshDateTimeController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;
  Function(bool) get changeIsSearching => _isSearchingController.sink.add;
  Function(List<BluetoothChargerModel>) get changeChargers => _chargersController.sink.add;
  Function(String) get changeSelectedChargerId => _selectedChargerIdController.sink.add;
  Function(bool) get changeIsLoadingNetworks => _isLoadingNetworksController.sink.add;
  Function(List<WifiNetworkModel>) get changeNetworks => _networksController.sink.add;
  Function(String) get changeCurrentNetworkName => _currentNetworkNameController.sink.add;
  Function(String) get changeSelectedNetworkSsid => _selectedNetworkSsidController.sink.add;
  Function(bool) get changeIsOtherNetwork => _isOtherNetworkController.sink.add;
  Function(String) get changeOtherNetworkName => _otherNetworkNameController.sink.add;
  Function(String) get changeNetworkPassword => _networkPasswordController.sink.add;
  Function(ChargerModel) get changeLinkedCharger => _linkedChargerController.sink.add;
  Function(ChargerProvisioningModel) get changeChargerProvisioning => _chargerProvisioningController.sink.add;

  // Get last values of the streams.
  int get tab => _tabController.value;
  DateTime get refreshDateTime => _refreshDateTimeController.value;
  String get loadingText => _loadingTextController.value;
  bool get isSearching => _isSearchingController.value;
  List<BluetoothChargerModel> get chargers => _chargersController.value;
  String get selectedChargerId => _selectedChargerIdController.value;
  bool get isLoadingNetworks => _isLoadingNetworksController.value;
  List<WifiNetworkModel> get networks => _networksController.value;
  String get currentNetworkName => _currentNetworkNameController.value;
  String get selectedNetworkSsid => _selectedNetworkSsidController.value;
  bool get isOtherNetwork => _isOtherNetworkController.value;
  String get otherNetworkName => _otherNetworkNameController.value;
  String get networkPassword => _networkPasswordController.value;
  ChargerModel get linkedCharger => _linkedChargerController.value;
  ChargerProvisioningModel get chargerProvisioning => _chargerProvisioningController.value;

  // Get the ssid of the network chosen in the select network tab.
  String get networkSsid => isOtherNetwork ? otherNetworkName.trim() : selectedNetworkSsid;

  // Get the name of the linked charger: the one registered by the backend or, if it is empty, the Bluetooth name of the selected charger.
  String get linkedChargerName => linkedCharger.name.isNotEmpty ? linkedCharger.name : (selectedCharger?.name ?? Strings.emptyString);

  // Stream that tells whether the connect button can be used: a network and a password are set. It is broadcast, so several StreamBuilders (or the same one recreated) can listen to it.
  late final Stream<bool> canConnectStream = Rx.combineLatest4(
    selectedNetworkSsidStream,
    isOtherNetworkStream,
    otherNetworkNameStream,
    networkPasswordStream,
    (String selectedNetworkSsid, bool isOtherNetwork, String otherNetworkName, String networkPassword) => _canConnect(selectedNetworkSsid, isOtherNetwork, otherNetworkName, networkPassword)
  ).asBroadcastStream();

  // Getter that tells whether the connect button can be used with the current values.
  bool get canConnect => _canConnect(selectedNetworkSsid, isOtherNetwork, otherNetworkName, networkPassword);

  // Method that checks that a network and a password are set.
  bool _canConnect(String selectedNetworkSsid, bool isOtherNetwork, String otherNetworkName, String networkPassword)
    => (isOtherNetwork ? otherNetworkName.trim() : selectedNetworkSsid).isNotEmpty && networkPassword.isNotEmpty;

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
    _isLoadingNetworksController.close();
    _networksController.close();
    _currentNetworkNameController.close();
    _selectedNetworkSsidController.close();
    _isOtherNetworkController.close();
    _otherNetworkNameController.close();
    _networkPasswordController.close();
    _linkedChargerController.close();
    _chargerProvisioningController.close();
  }

  // Reset fields.
  void reset() {
    changeTab(Tabs.linkStart);
    changeRefreshDateTime(DateTime.now());
    changeLoadingText(Strings.emptyString);
    changeIsSearching(false);
    changeChargers([]);
    changeSelectedChargerId(Strings.emptyString);
    changeIsLoadingNetworks(false);
    changeNetworks([]);
    changeCurrentNetworkName(Strings.emptyString);
    changeSelectedNetworkSsid(Strings.emptyString);
    changeIsOtherNetwork(false);
    changeOtherNetworkName(Strings.emptyString);
    changeNetworkPassword(Strings.emptyString);
    changeLinkedCharger(ChargerModel());
    changeChargerProvisioning(ChargerProvisioningModel());
  }

  // Check if bloc is initialized.
  bool blocIsInit() => _loadingTextController.hasValue;
}
