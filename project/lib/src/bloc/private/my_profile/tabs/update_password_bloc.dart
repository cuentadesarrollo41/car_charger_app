import 'package:rxdart/rxdart.dart';

// Bloc.
import 'package:project/src/bloc/mixins/field_errors_mixin.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';

class UpdatePasswordBloc with FieldErrorsMixin {
  final _oldPasswordController = BehaviorSubject<String>();
  final _newPasswordController = BehaviorSubject<String>();
  final _loadingTextController = BehaviorSubject<String>();

  // Get values from Stream.
  Stream<String> get oldPasswordStream => _oldPasswordController.stream;
  Stream<String> get newPasswordStream => _newPasswordController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;

  // Set values to Stream.
  Function(String) get changeOldPassword => _oldPasswordController.sink.add;
  Function(String) get changeNewPassword => _newPasswordController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;

  // Get last values of the streams.
  String get oldPassword => _oldPasswordController.value;
  String get newPassword => _newPasswordController.value;
  String get loadingText => _loadingTextController.value;

  // Close Stream Controllers.
  void dispose() {
    _oldPasswordController.close();
    _newPasswordController.close();
    _loadingTextController.close();
    disposeFieldErrors();
  }

  // Reset fields.
  void reset() {
    changeOldPassword(Strings.emptyString);
    changeNewPassword(Strings.emptyString);
    changeLoadingText(Strings.emptyString);
    resetFieldErrors();
  }

  // Check if bloc is initialized.
  bool blocIsInit() => _loadingTextController.hasValue;
}
