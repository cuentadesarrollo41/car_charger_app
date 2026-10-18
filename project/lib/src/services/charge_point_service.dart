// Services.
import 'package:project/src/services/api_service.dart';

// Models.
import 'package:project/src/models/charger_model.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';

abstract class ChargePointService {
  // Method that registers a charger for the user.
  static Future<Map<String, dynamic>> create({ required String serialNumber, required String networkName, required String language, required String token }) => ApiService.requestJson(
    method: Backend.post,
    endpoint: Backend.createChargePoint,
    language: language,
    token: token,
    body: { Fields.serialNumber: serialNumber, Fields.networkName: networkName },
    mapData: (Map<String, dynamic> data) => { Fields.item: ChargerModel.fromJson(data[Fields.charger] ?? {}) }
  );

  // Method that gets a charger.
  static Future<Map<String, dynamic>> getOne({ required String id, required String language, required String token }) => ApiService.requestJson(
    method: Backend.get,
    endpoint: '${ Backend.getChargePointOne }/$id',
    language: language,
    token: token,
    mapData: (Map<String, dynamic> data) => { Fields.item: ChargerModel.fromJson(data[Fields.charger] ?? {}) }
  );

  // Method that updates a charger.
  static Future<Map<String, dynamic>> updateOne({ required String id, required String name, required int currentLimitAmps, required String language, required String token }) => ApiService.requestJson(
    method: Backend.patch,
    endpoint: '${ Backend.updateChargePoint }/$id',
    language: language,
    token: token,
    body: { Fields.name: name, Fields.currentLimitAmps: currentLimitAmps },
    mapData: (Map<String, dynamic> data) => { Fields.item: ChargerModel.fromJson(data[Fields.charger] ?? {}) }
  );

  // Method that unlinks a charger from the user.
  static Future<Map<String, dynamic>> unlink({ required String id, required String language, required String token }) => ApiService.requestJson(
    method: Backend.patch,
    endpoint: '${ Backend.unlinkChargePoint }/$id',
    language: language,
    token: token
  );
}
