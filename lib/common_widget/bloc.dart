import 'dart:async';

import 'package:flutter/services.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';

abstract class Bloc {
  void dispose();
}

class DeepLinkBloc extends Bloc {
  //Event Channel creation
  static const stream =
      const EventChannel('https://graphicnewsplus.com/events');

  //Method channel creation
  static const platform =
      const MethodChannel('https://graphicnewsplus.com/channel');

  StreamController<String> _stateController = StreamController();

  Stream<String> get state => _stateController.stream;

  Sink<String> get stateSink => _stateController.sink;

  //Adding the listener into contructor
  DeepLinkBloc() {
    //Checking application start by deep link
    startUri().then(_onRedirected);
    //Checking broadcast stream, if deep link was clicked in opened appication
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
  }

  _onRedirected(dynamic uri) {
    // Here can be any uri analysis, checking tokens etc, if it’s necessary
    // Throw deep link URI into the BloC's stream

    print("blockfile" + uri);
    if (uri != null && uri.contains("?")) {
      if (uri != null && uri.contains("modal-post")) {
        SplashScreen.deeplinkingId = int.parse(uri.toString().split('=').last);
        SplashScreen.deeplinkingType = "popular_content";
        print("deeplinktype " + SplashScreen.deeplinkingType);
        print("deeplinkId" + SplashScreen.deeplinkingId.toString());
      } else {
        stateSink.add(uri);
        print("DeepLinkBloc $uri");
        List<String> firstSplit = uri.split("?");
        List<String> secondSplit = firstSplit[1].split("&");
        SplashScreen.deeplinkingType = secondSplit[0].split("=")[1];
        SplashScreen.deeplinkingId = int.parse(secondSplit[1].split("=")[1]);
        print("deeplinktype " + SplashScreen.deeplinkingType);
        print("deeplinkId" + SplashScreen.deeplinkingId.toString());
      }
    } else {
      print("from else loop " + uri);
      List<String> firstSplit = uri.split("/");
      SplashScreen.deeplinkingType = firstSplit[3];
      SplashScreen.deeplinkingId = int.parse(firstSplit[4]);
      /* stateSink.add(RestPath.BASE_URL2 +
          "getstory?t=" +
          SplashScreen.deeplinkingType +
          "&tid=" +
          firstSplit[4]);*/
      print("deeplinktype " + firstSplit[3]);
      print("deeplinkId" + firstSplit[4]);
    }
  }

  @override
  void dispose() {
    _stateController.close();
  }

  Future<dynamic> startUri() async {
    try {
      return platform.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }
}
