// Services.
import 'package:project/src/services/api_service.dart';

// Models.
import 'package:project/src/models/charger_model.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';

abstract class ChargerService {
  // Method that gets a charger.
  static Future<Map<String, dynamic>> getOne({ required String id, required String language, required String token }) => ApiService.requestJson(
    method: Backend.get,
    endpoint: '${ Backend.getChargerOne }/$id',
    language: language,
    token: token,
    mapData: (Map<String, dynamic> data) => {
      Fields.item: ChargerModel.fromJson(data[Fields.charger] ?? {}),
    }
  );
}
