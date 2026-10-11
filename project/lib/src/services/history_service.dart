// Models.
import 'package:project/src/models/charging_session_model.dart';

// Services.
import 'package:project/src/services/api_service.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';

abstract class HistoryService {
  // Method that gets the history data.
  static Future<Map<String, dynamic>> getData({ required String chargerId, required String historyPeriod, required String language, required String token }) => ApiService.requestJson(
    method: Backend.post,
    endpoint: Backend.getHistoryData,
    language: language,
    token: token,
    body: {
      Fields.chargerId: chargerId,
      Fields.period: historyPeriod
    },
    mapData: (Map<String, dynamic> data) => {
      Fields.list: (data[Fields.list] ?? []).map((dynamic element) => ChargingSessionModel.fromJson(element)).toList(),
      Fields.energyList: (data[Fields.energyList] ?? []).map((dynamic element) => element as int).toList()
    }
  );
}
