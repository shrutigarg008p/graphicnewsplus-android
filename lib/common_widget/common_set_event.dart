// ignore_for_file: avoid_init_to_null

import 'package:graphics_news/network/services/http_client.dart';

class CommonSetEvent {
  static setEvent(String type, String clickType, {id: null}) {
    HttpObj.instance.getClient().setEvent(type, clickType, id).then((it) {
      print(it.MESSAGE);
    }).catchError((Object obj) {
      print("error " + obj.toString());
    });
  }
}
