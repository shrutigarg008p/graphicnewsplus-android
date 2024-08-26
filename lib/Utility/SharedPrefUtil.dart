import 'package:graphics_news/constant/base_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  // set String values
  static setSharedPreferencesString(String key, String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value ?? BaseConstant.EMPTY);
  }

  // get String value
  static Future<String?> getSharedPreferencesString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(key);
    return stringValue;
  }

  // set Boolean values
  static setSharedPreferencesBool(String key, bool? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value ?? false);
  }

  // get Boolean value
  static Future<bool?> getSharedPreferencesBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool(key) != null ? prefs.getBool(key) : false;
    return boolValue;
  }

  // set list
  static setSharedPreferencesStringList(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  // get Boolean value
  static Future<List<String>?> getSharedPreferencesStringList(
      String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList(key);
    return list;
  }
}
