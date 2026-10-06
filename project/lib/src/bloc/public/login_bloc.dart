import 'package:rxdart/rxdart.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';

class LoginBloc {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _loadingTextController = BehaviorSubject<String>();
  final _fieldErrorsController = BehaviorSubject<Map<String, String>>();

  // Get values from Stream.
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;
  Stream<Map<String, String>> get fieldErrorsStream => _fieldErrorsController.stream;

  // Set values to Stream.
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;
  Function(Map<String, String>) get changeFieldErrors => _fieldErrorsController.sink.add;

  // Get last values of the streams.
  String get email => _emailController.value;
  String get password => _passwordController.value;
  String get loadingText => _loadingTextController.value;
  Map<String, String> get fieldErrors => _fieldErrorsController.value;

  // Close Stream Controllers.
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _loadingTextController.close();
    _fieldErrorsController.close();
  }

  // Reset fields.
  void reset() {
    changeEmail(Strings.emptyString);
    changePassword(Strings.emptyString);
    changeLoadingText(Strings.emptyString);
    changeFieldErrors({});
  }

  // Method that sets the error of a field (only one error is shown at a time).
  void setFieldError(String field, String error) => changeFieldErrors({ field: error });

  // Method that clears the error of a field.
  void clearFieldError(String field) {
    if (!fieldErrors.containsKey(field)) {
      return;
    }

    changeFieldErrors(Map.of(fieldErrors)..remove(field));
  }

  // Method that resets the field errors.
  void resetFieldError() => changeFieldErrors({});

  // Check if bloc is initialized.
  bool blocIsInit() => _loadingTextController.hasValue;
}
