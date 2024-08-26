import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';

/// Created by Amit Rawat on 11/19/2021.
class InternetUtil {
  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Future<bool> checkWifi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static errorMsgWifi(BuildContext context) {
    UiUtil.showAlert(context, BaseConstant.INTERNET,
        BaseConstant.WIFI_INTERNET_CONNECTION_MSG, null, true);
  }

  static errorMsg(BuildContext context) {
    UiUtil.showAlert(context, BaseConstant.INTERNET,
        BaseConstant.INTERNET_CONNECTION_MSG, null, true);
  }
}
