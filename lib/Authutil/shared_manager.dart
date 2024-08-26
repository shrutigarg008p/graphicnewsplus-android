/// Created by Amit Rawat on 1/21/2022.
import 'dart:convert';

import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/database/SQLiteDbProvider.dart';
import 'package:graphics_news/network/entity/auth_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedManager {
  SharedManager._privateConstructor();

  static final SharedManager _instance = SharedManager._privateConstructor();

  static SharedManager get instance => _instance;

  static Future<SharedPreferences> get _sharedPreferenceInstance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  Future<SharedPreferences?> init() async {
    if (_prefsInstance == null) {
      _prefsInstance = await _sharedPreferenceInstance;
    }
    return _prefsInstance;
  }

  final String auth_token = "access_token";
  final String UserData = "user_data";
  final String Notification = "notification";
  final String MobileData = "mobile_data";
  final bool MobileDataValue = true;
  final String ThemeKey = "Theme";
  final bool ThemeValue = false;
  final String weburlkey = "WEB_URL";
  final String weburlvalue = "https://graphicnewsplus.com/";
  final String FontKey = "selectedSize";

  savedDataLocal(AuthDTO authDTO) {
    SQLiteDbProvider.clear();
    String token = authDTO.DATA!.tokenType! +
        BaseConstant.EMPTY_SPACE +
        authDTO.DATA!.accessToken.toString();

    setAuthToken(token);
    setUserDetail(authDTO.DATA!.user!);
    updateNotification(authDTO.DATA!.notification);
  }

//set data into shared preferences like this
  setAuthToken(String? authToken) {
    _prefsInstance!
        .setString(this.auth_token, authToken ?? BaseConstant.EMPTY);
  }

/*auth data*/
  dynamic getAuthToken() {
    String? authToken = _prefsInstance!.getString(this.auth_token);
    return authToken;
  }

  /*mobile enable data*/
  setWebUrl(String? notify) {
    _prefsInstance!.setString(this.weburlkey, notify ?? weburlvalue);
  }

  dynamic getWebUrl() {
    String? notify = _prefsInstance!.getString(this.weburlkey) ?? weburlvalue;
    return notify;
  }

/*mobile enable data*/
  updateMobileData(bool? notify) {
    _prefsInstance!.setBool(this.MobileData, notify ?? MobileDataValue);
  }

  dynamic getMobileData() {
    bool? notify = _prefsInstance!.getBool(this.MobileData) ?? MobileDataValue;
    return notify;
  }

  /*theme data */
  updateDarkTheme(bool? theme) {
    _prefsInstance!.setBool(this.ThemeKey, theme ?? ThemeValue);
  }

  dynamic getDarkTheme() {
    if (_prefsInstance == null) {
      return false;
    }
    bool? theme = _prefsInstance!.getBool(this.ThemeKey) ?? ThemeValue;
    return theme;
  }

  /*notification data */
  updateNotification(bool? notify) {
    _prefsInstance!.setBool(this.Notification, notify ?? false);
  }

  dynamic getNotification() {
    bool? notify = _prefsInstance!.getBool(this.Notification) ?? false;
    return notify;
  }

  /*user datat */
  setUserDetail(User? jsonString) {
    if (jsonString == null) {
      _prefsInstance!.setString(UserData, BaseConstant.EMPTY_SPACE);
    } else {
      Map<String, dynamic> json = jsonDecode(jsonEncode(jsonString.toJson()));
      String user = jsonEncode(json);
      _prefsInstance!.setString(UserData, user);
    }
  }

  User? getUserDetail() {
    if (RouteMap.isLogin()) {
      Map<String, dynamic>? json =
          jsonDecode(_prefsInstance!.getString(UserData).toString());
      if (json != null) {
        var user = User.fromJson(json);
        return user;
      }
    }

    return null;
  }

  Future<bool> deleteData(String key) async {
    return _prefsInstance!.remove(key);
  }

  // set font size
  int? getFontSize() {
    int? value = _prefsInstance!.getInt(FontKey);
    return value;
  }

  setFontSize(int? value) async {
    _prefsInstance!.setInt(this.FontKey, value ?? 1);
  }

  deleteToken() {
    SQLiteDbProvider.clear();

    /// delete from keystore/keychain
    setAuthToken(null);
    setUserDetail(null);
    updateNotification(null);
  }
}
