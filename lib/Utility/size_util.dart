import 'package:flutter/cupertino.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';

class SizeUtil {
  static double getadsHeight(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? UiRatio.isTablet()
            ? MediaQuery.of(context).size.height * 0.27
            : MediaQuery.of(context).size.height * 0.27
        : UiRatio.isTablet()
            ? MediaQuery.of(context).size.width * 0.27
            : MediaQuery.of(context).size.width * 0.27;
  }

  static double getSliderHeight(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? UiRatio.isTablet()
            ? MediaQuery.of(context).size.height * 0.30
            : MediaQuery.of(context).size.height * 0.30
        : UiRatio.isTablet()
            ? MediaQuery.of(context).size.width * 0.35
            : MediaQuery.of(context).size.width * 0.30;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? UiRatio.isTablet()
            ? MediaQuery.of(context).size.height * 0.75
            : MediaQuery.of(context).size.height * 0.60
        : UiRatio.isTablet()
            ? MediaQuery.of(context).size.width * 0.50
            : MediaQuery.of(context).size.width * 0.35;
  }

  static double getWidhtInfinity() {
    return double.infinity;
  }

  static double getHeightInfinity() {
    return double.infinity;
  }

  static double getSize(double size, BuildContext context) {
    if (SplashScreen.selectedSize == 0) {
      print("S " + (size - 1.2).toString());
      return (size - 1.2);
    } else if (SplashScreen.selectedSize == 2) {
      print("L " + (size + 1.2).toString());
      return (size + 1.2);
    }
    print("M " + (size).toString());
    return size;
  }
}
