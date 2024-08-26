import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';

/// Created by Amit Rawat on 1/3/2022.
class ModeTheme {
  static isDarkTheme(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return true;
    }
    return false;
  }

  /*night and light
  * white and black */
  static getDefault(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  /*night and light
  * black and white */
  static blackOrWhite(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF3E4042)
        : Colors.white;
  }

  /* */ /*night and light
  * black and white */ /*
  static blackOrGrey(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF3E4042) : Color(0xFFCBCBCB);
  }*/

  /*night and light
  * white and grey */
  static whiteGrey(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : WidgetColors.greyColor;
  }

  /*night and light
  * light grey and dark grey */
  static lightGreyOrDarkGrey(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? WidgetColors.renewButtonColor
        : WidgetColors.greyColor;
  }

  /*night and light
  * black and light grey */
  static blackOrGrey(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? WidgetColors.iconBackgroundDark
        : WidgetColors.renewButtonColor;
  }

  /*night and light
  * dark grey and white */
  static greyOrWhite(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? WidgetColors.darkGreyColor
        : Colors.white;
  }
}
