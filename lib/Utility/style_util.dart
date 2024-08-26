import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';

class FontUtil {
  static TextStyle style(double fontsize, int fontWeight, BuildContext context,
      [Color? color, double? height, TextDecoration? textDeco]) {
    FontWeight fontwei = FontWeight.w400; //regular default
    double size = fontsize;
    double lineHeight = height == null ? 1.2 : height;
    TextDecoration textDecoration =
        textDeco == null ? TextDecoration.none : textDeco;
    switch (fontWeight) {
      case 0:
        fontwei = FontWeight.w300; //thin
        break;
      case 1:
        fontwei = FontWeight.w400; //regular
        break;
      case 2:
        fontwei = FontWeight.w500; //medium
        break;
      case 3:
        fontwei = FontWeight.w600; //semi bold
        break;
      case 4:
        fontwei = FontWeight.w700; //bold
        break;
    }

    if (UiRatio.isTablet()) {
      size = size + 2;
    }
    switch (SplashScreen.selectedSize) {
      case 0:
        size = size - 1.2; //S
        break;
      case 1:
        size = size; //M
        break;
      case 2:
        size = size + 1.2; //L
        break;
    }

    return GoogleFonts.poppins(
      textStyle: TextStyle(
          decoration: textDecoration,
          fontSize: size,
          fontWeight: fontwei,
          letterSpacing: 0.0,
          height: lineHeight,
          color: color),
    );
  }

  static double getFontSize(double fontsize) {
    double size = fontsize;
    if (UiRatio.isTablet()) {
      size = size + 2;
    }
    switch (SplashScreen.selectedSize) {
      case 0:
        return size = size - 1.2; //S

      case 1:
        return size = size; //M

      case 2:
        return size = size + 1.2; //L
    }
    return size;
  }
}
