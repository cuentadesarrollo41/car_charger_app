import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/urls.dart';

abstract class AppVersionService {
  // Method that gets the latest published version from the App Store.
  static Future<Map<String, dynamic>> getLatestVersion() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return await _getLatestVersionIOS(packageInfo.packageName);
    } catch (e) {
      return {
        Fields.statusCode: Backend.code500,
        Fields.version: null,
        Fields.url: null,
      };
    }
  }

  // Method that gets the latest version from the App Store via iTunes Lookup.
  static Future<Map<String, dynamic>> _getLatestVersionIOS(String bundleId) async {
    final String url = '${ Urls.appleStoreLink }=$bundleId&${ Fields.country }=es';

    final http.Response response = await http.get(Uri.parse(url));
    final Map<String, dynamic> decodedBody = json.decode(response.body);

    final List results = decodedBody[Fields.results] ?? [];

    return results.isEmpty
      ? {
        Fields.statusCode: Backend.code500,
        Fields.version: null,
        Fields.url: null,
      }
      : {
        Fields.statusCode: Backend.code200,
        Fields.version: results[0][Fields.version],
        Fields.url: results[0][Fields.trackViewUrl],
      };
  }
}
