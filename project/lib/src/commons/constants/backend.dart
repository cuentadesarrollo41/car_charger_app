// Commons.
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/strings.dart';

class Backend {
  static const String baseUrl = 'https://graco.api.blimburtechnologies.dev'; // TODO: set API base URL (dev)
  //static const String baseUrl = ''; // TODO: set API base URL (prod)
  static const String get = 'GET';
  static const String post = 'POST';
  static const String put = 'PUT';
  static const String patch = 'PATCH';
  static const String delete = 'DELETE';

  // Headers.
  static const String applicationJson = 'application/json';
  static const String applicationUrlEncoded = 'application/x-www-form-urlencoded';
  static const String formData = 'multipart/form-data';
  static const String contentType = 'Content-Type';
  static const String contentDisposition = 'content-disposition';

  // Status codes.
  static const int code200 = 200;
  static const int code201 = 201;
  static const int code401 = 401;
  static const int code403 = 403;
  static const int code500 = 500;
  static const int codeError = 0;
  static const int codeUnauthorized = 2;
  static const int codeNoConnection = -1;

  // Get headers.
  static Map<String, String> getHeaders({ String contentType = Backend.applicationJson, required String language, String token = Strings.emptyString }) {
    final Map<String, String> headers = {
      Backend.contentType: contentType,
      Fields.language: language,
    };

    if (token.isNotEmpty) {
      headers[Fields.token] = token;
    }

    return headers;
  }

  // Auth.
  static const String login = 'api/v1/public/users/login';
  static const String logout = 'api/v1/public/users/logout';
  static const String recoverPassword = 'api/v1/public/users/password/recover';
  static const String signUp = 'api/v1/public/users/register';

  // Chargers.
  static const String createChargePoint = 'api/v1/private/chargepoints';
  static const String getChargePointOne = 'api/v1/private/chargepoints';
  static const String unlinkChargePoint = 'api/v1/private/chargepoints/unlink';
  static const String updateChargePoint = 'api/v1/private/chargepoints';

  // History.
  static const String getHistoryData = 'api/v1/private/history/data';
  static const String getHistoryList = 'api/v1/private/history/all';

  // Users.
  static const String deleteOwnUser = 'api/v1/private/users';
  static const String getOwnUser = 'api/v1/private/users/own';
  static const String updateOwnUser = 'api/v1/private/users';
  static const String updatePassword = 'api/v1/private/users/password/update';
}
