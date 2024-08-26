



import 'package:url_launcher/url_launcher.dart';


class CommonSocialRedirection {
  static void socialRedirection(
      String urlString) async {
    try {
      bool launched = await launch(urlString, forceSafariVC: false);

      if (!launched) {
        await launch('', forceSafariVC: false);
      }
    } catch (e) {
      await launch('', forceSafariVC: false);
    }
  
  }
}
