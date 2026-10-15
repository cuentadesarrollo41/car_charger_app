// Models.
import 'package:project/src/models/charging_session_model.dart';

// Services.
import 'package:project/src/services/api_service.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/numbers.dart';

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
      Fields.list: List<ChargingSessionModel>.from((data[Fields.lastCharges] as List? ?? []).map((dynamic element) => ChargingSessionModel.fromJson(element))),
      Fields.energyList: List<int>.from((data[Fields.history] as List? ?? []).map((dynamic element) => (element as num).toInt()))
    }
  );

  // Method that gets a page of the charging sessions of a charger (newest first).
  static Future<Map<String, dynamic>> getList({ required String chargerId, required int page, required int limit, required String language, required String token }) => ApiService.requestJson(
    method: Backend.post,
    endpoint: Backend.getHistoryList,
    language: language,
    token: token,
    body: { Fields.chargerId: chargerId, Fields.page: page, Fields.limit: limit },
    mapData: (Map<String, dynamic> data) => {
      Fields.count: int.tryParse('${ data[Fields.count] }') ?? Numbers.zero,
      Fields.list: List<ChargingSessionModel>.from((data[Fields.list] as List? ?? []).map((dynamic element) => ChargingSessionModel.fromJson(element)))
    }
  );
}
