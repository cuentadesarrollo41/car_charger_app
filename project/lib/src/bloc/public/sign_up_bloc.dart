import 'package:rxdart/rxdart.dart';

// Bloc.
import 'package:project/src/bloc/mixins/field_errors_mixin.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';

class SignUpBloc with FieldErrorsMixin {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _loadingTextController = BehaviorSubject<String>();

  // Get values from Stream.
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;

  // Set values to Stream.
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;

  // Get last values of the streams.
  String get email => _emailController.value;
  String get password => _passwordController.value;
  String get loadingText => _loadingTextController.value;

  // Close Stream Controllers.
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _loadingTextController.close();
    disposeFieldErrors();
  }

  // Reset fields.
  void reset() {
    changeEmail(Strings.emptyString);
    changePassword(Strings.emptyString);
    changeLoadingText(Strings.emptyString);
    resetFieldErrors();
  }

  // Check if bloc is initialized.
  bool blocIsInit() => _loadingTextController.hasValue;
}
