import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';

class ThankYouPage {
  static void thankYou(
      String imagePath, String title, String description, BuildContext context,
      {String page = ""}) {
    Timer? timer;
    if (page.isNotEmpty && page == BaseConstant.PAYMENT_METHODS) {
      Timer(Duration(milliseconds: 3000), () {
        RouteMap.getHome(context, index: 1);
      });
    } else if (page.isNotEmpty && page == BaseConstant.PAYMENT_METHOD_SINGLE) {
      Timer(Duration(milliseconds: 3000), () {
        RouteMap.onBackTimes(context, 3);
      });
    } else {
      Timer(Duration(milliseconds: 2000), () {
        Navigator.of(context).pop();
      });
    }
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.27
                  : MediaQuery.of(context).size.width * 0.27,
              width: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width * 0.75
                  : MediaQuery.of(context).size.height * 0.75,
              padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: Column(
                children: [
                  thankYouImage(imagePath),
                  SizedBox(
                    height: 12.0,
                  ),
                  thankYouTitle(title, context),
                  SizedBox(
                    height: 12.0,
                  ),
                  thankYouDescription(description, context),
                ],
              ),
              margin: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: ModeTheme.greyOrWhite(context),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    ).then((value) {
      timer?.cancel();
      timer = null;
    });
  }

  static thankYouImage(String imagePath) {
    return Image.asset(
      imagePath,
      height: 40,
      width: 40,
    );
  }

  static thankYouTitle(String title, BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Text(title,
            style: FontUtil.style(FontSizeUtil.XXLarge, SizeWeight.Bold, context,
                WidgetColors.successColor, 1.5)));
  }

  static thankYouDescription(String description, BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Text(description,
            textAlign: TextAlign.center,
            style: FontUtil.style(
                FontSizeUtil.Large, SizeWeight.Medium, context, Colors.grey, 1.5)));
  }
}
