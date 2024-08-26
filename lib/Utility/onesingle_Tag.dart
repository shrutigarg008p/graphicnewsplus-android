import 'package:onesignal_flutter/onesignal_flutter.dart';

/// Created by Amit Rawat on 12/30/2021.

class OneSingleTag {
  static addIncrement(String key) {
    OneSignal.shared.getTags().then((tags) {
      if (tags[key] == null) {
        addInt(key, 1);
      } else {
        var total = int.parse(tags[key]) + 1;
        addInt(key, total);
      }
    }).catchError((error) {
      print("Encountered an error sending tags: $error");
    });
  }

  static addInt(String key, var value) {

    OneSignal.shared.sendTag(key, value).then((response) {
      print(response);
    }).catchError((error) {
      print("Encountered an error sending tags: $error");
    });
  }
}
