import 'package:rxdart/rxdart.dart';

mixin FieldErrorsMixin {
  final _fieldErrorsController = BehaviorSubject<Map<String, String>>();

  // Get values from Stream.
  Stream<Map<String, String>> get fieldErrorsStream => _fieldErrorsController.stream;

  // Set values to Stream.
  Function(Map<String, String>) get changeFieldErrors => _fieldErrorsController.sink.add;

  // Get last values of the streams.
  Map<String, String> get fieldErrors => _fieldErrorsController.valueOrNull ?? {};

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
  void resetFieldErrors() => changeFieldErrors({});

  // Method that changes the value of a field and clears its error.
  void changeFieldValue<T>(String field, Function(T) change, T value) {
    change(value);
    clearFieldError(field);
  }

  // Method that closes the field errors stream.
  void disposeFieldErrors() => _fieldErrorsController.close();
}
