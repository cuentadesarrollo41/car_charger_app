import 'package:rxdart/rxdart.dart';

// Bloc.
import 'package:project/src/bloc/mixins/field_errors_mixin.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';

class UserNameBloc with FieldErrorsMixin {
  final _nameController = BehaviorSubject<String>();
  final _loadingTextController = BehaviorSubject<String>();

  // Get values from Stream.
  Stream<String> get nameStream => _nameController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;

  // Set values to Stream.
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;

  // Get last values of the streams.
  String get name => _nameController.value;
  String get loadingText => _loadingTextController.value;

  // Close Stream Controllers.
  void dispose() {
    _nameController.close();
    _loadingTextController.close();
    disposeFieldErrors();
  }

  // Reset fields.
  void reset(String name) {
    changeName(name);
    changeLoadingText(Strings.emptyString);
    resetFieldErrors();
  }

  // Check if bloc is initialized.
  bool blocIsInit() => _loadingTextController.hasValue;
}
