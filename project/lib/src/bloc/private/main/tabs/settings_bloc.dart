import 'package:rxdart/rxdart.dart';

// Bloc.
import 'package:project/src/bloc/mixins/field_errors_mixin.dart';

// Models.
import 'package:project/src/models/charger_model.dart';

// Commons.
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/strings.dart';

class SettingsBloc with FieldErrorsMixin {
  final _chargerNameController = BehaviorSubject<String>();
  final _currentLimitAmpsController = BehaviorSubject<int>();
  final _loadingTextController = BehaviorSubject<String>();

  // Get values from Stream.
  Stream<String> get chargerNameStream => _chargerNameController.stream;
  Stream<int> get currentLimitAmpsStream => _currentLimitAmpsController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;

  // Set values to Stream.
  Function(String) get changeChargerName => _chargerNameController.sink.add;
  Function(int) get changeCurrentLimitAmps => _currentLimitAmpsController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;

  // Get last values of the streams.
  String get chargerName => _chargerNameController.value;
  int get currentLimitAmps => _currentLimitAmpsController.value;
  String get loadingText => _loadingTextController.value;

  // Close Stream Controllers.
  void dispose() {
    _chargerNameController.close();
    _currentLimitAmpsController.close();
    _loadingTextController.close();
    disposeFieldErrors();
  }

  // Reset fields.
  void reset() {
    changeChargerName(Strings.emptyString);
    changeCurrentLimitAmps(Numbers.currentLimitAmpsMin);
    changeLoadingText(Strings.emptyString);
    resetFieldErrors();
  }

  // Method that fills the fields with the values of a charger.
  void fillFromCharger(ChargerModel charger) {
    changeChargerName(charger.name);
    changeCurrentLimitAmps(charger.currentLimitAmps.clamp(Numbers.currentLimitAmpsMin, Numbers.currentLimitAmpsMax));
  }

  // Check if bloc is initialized.
  bool blocIsInit() => _loadingTextController.hasValue;
}
