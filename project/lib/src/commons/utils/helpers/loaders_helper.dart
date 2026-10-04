import 'package:url_launcher/url_launcher.dart';

// Commons.
import 'package:project/src/commons/constants/strings.dart';

abstract class LoadersHelper {
  // Method that loads an url.
  static void loadUrl({ required String url, LaunchMode mode = LaunchMode.platformDefault }) async {
    String newUrl = url.startsWith(Strings.http) || url.startsWith(Strings.https) || url.startsWith(Strings.mailto) ? url : '${ Strings.http }://$url';

    await launchUrl(
      Uri.parse(newUrl),
      mode: mode,
    );
  }
}