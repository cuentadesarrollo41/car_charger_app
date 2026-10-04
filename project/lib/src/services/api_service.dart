import 'dart:convert';
import 'package:http/http.dart' as http;

// Models.
import 'package:project/src/models/generic/file_model.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/strings.dart';

typedef ResponseDataMapper = Map<String, dynamic> Function(Map<String, dynamic> data);

abstract class ApiService {
  // Method that performs a JSON request to the backend.
  static Future<Map<String, dynamic>> requestJson({
    required String method,
    required String endpoint,
    required String language,
    String token = Strings.emptyString,
    Map<String, dynamic>? body,
    ResponseDataMapper? mapData
  }) => _send(
    mapData: mapData,
    buildRequest: () {
      final http.Request request = http.Request(method, _getUri(endpoint));
      request.headers.addAll(Backend.getHeaders(language: language, token: token));

      if (body != null) {
        request.body = json.encode(body);
      }

      return request;
    }
  );

  // Method that performs a multipart request (files + fields) to the backend.
  static Future<Map<String, dynamic>> requestMultipart({
    required String method,
    required String endpoint,
    required String language,
    String token = Strings.emptyString,
    Map<String, dynamic> fields = const {},
    Map<String, List<FileModel>> files = const {},
    ResponseDataMapper? mapData
  }) => _send(
    mapData: mapData,
    buildRequest: () {
      final http.MultipartRequest request = http.MultipartRequest(method, _getUri(endpoint));

      // The multipart request sets its own Content-Type (with the boundary).
      request.headers.addAll(Backend.getHeaders(language: language, token: token)..remove(Backend.contentType));

      fields.forEach((String key, dynamic value) {
        if (value != null) {
          request.fields[key] = value is String ? value : json.encode(value);
        }
      });

      files.forEach((String key, List<FileModel> fileList) {
        for (final FileModel file in fileList.where((FileModel file) => file.bytes != null)) {
          request.files.add(http.MultipartFile.fromBytes(key, file.bytes!, filename: file.name));
        }
      });

      return request;
    }
  );

  // Method that builds the full URI of an endpoint.
  static Uri _getUri(String endpoint) => Uri.parse('${ Backend.baseUrl }/$endpoint');

  // Method that sends a request and returns a normalised response.
  static Future<Map<String, dynamic>> _send({ required http.BaseRequest Function() buildRequest, ResponseDataMapper? mapData }) async {
    try {
      final http.Response response = await http.Response.fromStream(await buildRequest().send());
      final Map<String, dynamic> decodedBody = response.body.isEmpty ? {} : json.decode(response.body);
      final Map<String, dynamic> data = decodedBody[Fields.data] is Map ? decodedBody[Fields.data] : {};

      return {
        Fields.statusCode: response.statusCode,
        Fields.title: decodedBody[Fields.title],
        Fields.text: decodedBody[Fields.message],
        Fields.data: decodedBody[Fields.data],
        ...?mapData?.call(data)
      };
    } catch (e) {
      return {
        Fields.statusCode: Backend.code500,
        Fields.title: null,
        Fields.text: null,
        Fields.data: null
      };
    }
  }
}