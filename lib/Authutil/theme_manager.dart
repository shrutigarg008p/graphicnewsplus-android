import 'package:flutter/material.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
      primaryColor: Colors.black,
      //  brightness: Brightness.dark,
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.grey),
        subtitle1: TextStyle(color: Colors.grey),
      ),
      backgroundColor: const Color(0xFF282929),
      splashColor: Colors.white,
      dividerColor: Colors.black12,
      cardColor: Color(0xFF3E4042),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
          .copyWith(secondary: Colors.black, brightness: Brightness.dark));

  final lightTheme = ThemeData(
    primaryColor: Colors.grey,
    brightness: Brightness.light,
    primaryTextTheme: TextTheme(bodyText1: TextStyle(color: Colors.grey)),
    backgroundColor: const Color(0xFFFFFFFF),
    splashColor: Colors.black,
    dividerColor: Colors.white54,
    cardColor: Color(0xFFECECEC),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
        .copyWith(secondary: Colors.black),
  );

  ThemeData _themeData = ThemeData.light();

  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    SharedManager.instance.init();
    dynamic darkMode = SharedManager.instance.getDarkTheme();

    if (darkMode) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
    notifyListeners();
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    SharedManager.instance.updateDarkTheme(true);

    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    SharedManager.instance.updateDarkTheme(false);
    notifyListeners();
  }
}
