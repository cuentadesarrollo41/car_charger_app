import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// Commons.
import 'package:project/src/commons/constants/backend.dart';
import 'package:project/src/commons/constants/fields.dart';
import 'package:project/src/commons/constants/strings.dart';
import 'package:project/src/commons/utils/file_extensions.dart';

abstract class DownloadService {
  // Method that downloads a file.
  static Future<Map<String, dynamic>> downloadFile({ required String token, required String url, required String name, required String language }) async {
    try {
      http.Response response = await http.get(Uri.parse(url), headers: Backend.getHeaders(token: token, language: language));

      if (response.statusCode != Backend.code200) {
        return {
          Fields.statusCode: Backend.code500,
          Fields.title: null,
          Fields.text: null,
        };
      }

      final Uint8List bytes = response.bodyBytes;
      final String contentType = response.headers[Backend.contentType] ?? Strings.emptyString;
      final extension = FileExtensions.inferExtension(contentType.isEmpty ? name : contentType);

      // Get folder.
      final Directory directory = await getTemporaryDirectory();
      final String filename = getFilenameFromContentDisposition(response.headers[Backend.contentDisposition]) ?? '${ name }_${ DateTime.now().millisecondsSinceEpoch }.$extension';
      final File file = File('${ directory.path }/$filename');

      // Write file.
      await file.writeAsBytes(bytes);

      return {
        Fields.statusCode: response.statusCode,
        Fields.file: file,
      };
    } catch(e) {
      return {
        Fields.statusCode: Backend.code500,
        Fields.title: null,
        Fields.text: null,
      };
    }
  }

  // Method that gets the filename.
  static String? getFilenameFromContentDisposition(String? header) {
    if (header == null) return null;

    // Get filename* (UTF-8 y encoded)
    final filenameStarMatch = RegExp(r"filename\*\s*=\s*UTF-8''([^;\n]+)", caseSensitive: false).firstMatch(header);

    if (filenameStarMatch != null) {
      return Uri.decodeFull(filenameStarMatch.group(1)!);
    }

    // If filename* does not exist get filename="...":
    final filenameMatch = RegExp(r'filename\s*=\s*"([^"]+)"', caseSensitive: false).firstMatch(header);

    if (filenameMatch != null) {
      return filenameMatch.group(1);
    }

    return null;
  }
}