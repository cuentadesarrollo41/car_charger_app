// Models.
import 'package:project/src/models/user_model.dart';

// Services.
import 'package:project/src/services/api_service.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';

abstract class UserService {
  // Method that gets one user by id.
  static Future<Map<String, dynamic>> getOne({ required String id, required String language, required String token }) => ApiService.requestJson(
    method: Backend.get,
    endpoint: '${ Backend.getUser }/$id',
    language: language,
    token: token,
    mapData: (Map<String, dynamic> data) => {
      Fields.item: UserModel.fromJson(data[Fields.user] ?? {}),
      Fields.updateUserLastDate: DateTime.now()
    }
  );

  // Method that updates the password.
  static Future<Map<String, dynamic>> updatePassword({ required String token, required String id, required String oldPassword, required String newPassword, required String language }) => ApiService.requestJson(
    method: Backend.patch,
    endpoint: '${ Backend.updatePassword }/$id',
    language: language,
    token: token,
    body: { Fields.oldPassword: oldPassword, Fields.newPassword: newPassword }
  );
}
