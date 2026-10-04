import 'package:rxdart/rxdart.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';

class ForgotPasswordBloc {
  final _emailController = BehaviorSubject<String>();
  final _loadingTextController = BehaviorSubject<String>();

  // Get values from Stream.
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get loadingTextStream => _loadingTextController.stream;

  // Set values to Stream.
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeLoadingText => _loadingTextController.sink.add;

  // Get last values of the streams.
  String get email => _emailController.value;
  String get loadingText => _loadingTextController.value;

  // Close Stream Controllers.
  void dispose() {
    _emailController.close();
    _loadingTextController.close();
  }

  // Reset fields.
  void reset() {
    changeEmail(Strings.emptyString);
    changeLoadingText(Strings.emptyString);
  }

  // Check if bloc is initialized.
  bool blocIsInit() => _loadingTextController.hasValue;
}
