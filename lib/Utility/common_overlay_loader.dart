import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graphics_news/Colors/colors.dart';

class CommonOverlayLoader {
  static showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Platform.isAndroid
            ? Center(
                child: SizedBox(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: SpinKitCircle(
                        color: WidgetColors.primaryColor,
                        size: 50.0,
                      ),
                    )))
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitCircle(
                      color: WidgetColors.primaryColor,
                      size: 50.0,
                    ),
                  ],
                ),
              );
      },
    );
  }

  static hideLoader(BuildContext context) {
    Navigator.pop(context);
  }
}
