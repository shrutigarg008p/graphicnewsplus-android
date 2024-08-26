import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/route.dart';

class SplashScreen extends StatefulWidget {
  static List<String> fullAdsScreenList = [];
  static List<String> bannerAdsScreenList = [];
  static var bannerAdsUrl;
  static var fullAdsUrl;
  static List<int> bookMarkNewsPaper = [];
  static List<int> bookMarkMagazines = [];
  static List<int> bookMarkTopStories = [];
  static List<int> bookMarkPromotedContent = [];
  static var selectedSize;
  static var deeplinkingType;
  static int? deeplinkingId;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  // late var selectedSize;
  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    dynamic auth = SharedManager.instance.getAuthToken();
    if (auth != null && auth.isNotEmpty) {
      RouteMap.getHome(context);
    } else {
      RouteMap.getHome(context);
     // RouteMap().getLogin(context);
    }
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefValues();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  void getSharedPrefValues() async {
    SplashScreen.selectedSize = SharedManager.instance.getFontSize();
    if (SplashScreen.selectedSize == null) {
      print("selected size is NULL");
      SplashScreen.selectedSize = 1;
      SharedManager.instance.setFontSize(1);
    } else {
      print(
          "selected size is not NULL " + SplashScreen.selectedSize.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: WidgetColors.primaryColor),
          child: Image.asset(
            orientation == Orientation.portrait
                ? "images/splashscreen.png"
                : "images/splash_land.png",
          ),
        );
      }),
    );
  }
}
