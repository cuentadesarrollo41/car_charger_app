// Services.
import 'package:project/src/services/api_service.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/strings.dart';

abstract class AuthService {
  // Method that logs the user in.
  static Future<Map<String, dynamic>> login({ required String email, required String password, required String language }) => ApiService.requestJson(
    method: Backend.post,
    endpoint: Backend.login,
    language: language,
    body: { Fields.email: email, Fields.password: password },
    mapData: (Map<String, dynamic> data) => { Fields.token: data[Fields.token] ?? Strings.emptyString }
  );

  // Method that recovers the password of the user.
  static Future<Map<String, dynamic>> recoverPassword({ required String email, required String language }) => ApiService.requestJson(
    method: Backend.post,
    endpoint: Backend.recoverPassword,
    language: language,
    body: { Fields.email: email }
  );

  // Method that registers the user.
  static Future<Map<String, dynamic>> signUp({ required String email, required String password, required String language }) => ApiService.requestJson(
    method: Backend.post,
    endpoint: Backend.signUp,
    language: language,
    body: { Fields.email: email, Fields.password: password },
    mapData: (Map<String, dynamic> data) => { Fields.token: data[Fields.token] ?? Strings.emptyString }
  );
}
