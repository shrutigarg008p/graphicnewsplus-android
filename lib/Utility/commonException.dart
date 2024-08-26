import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/network/services/dio_exception.dart';

class CommonException {
  /*user for alert msg */
  showException(BuildContext context, Object obj) {
    DioException().getDioException(context, obj);
    final res = (obj as DioError).response;
    if (obj is DioError) {
      final res = (obj).response;
      if (res != null) {
        if (res.statusCode != 401) {
          var jsonResponse = json.decode(res.toString());
          String message = jsonResponse['MESSAGE'];
          print("Message" + message);
          serverError(context, message);
        }
      } else {
        serverError(context, null);
      }
    } else {
      serverError(context, null);
    }

    print(res);
  }

  /*use for non alert msg*/
  exception(BuildContext context, Object obj) {
    DioException().getDioException(context, obj);
    final res = (obj as DioError).response;
    print(res);
  }

  serverError(BuildContext context, String? msg) {
    if (msg == null) {
      msg = BaseConstant.SOMETHING_WENT_WRONG;
    }
    UiUtil.showAlert(context, BaseConstant.Server_error, msg, null, true);
  }

  showAuthException(BuildContext context, Object obj) {
    final res = (obj as DioError).response;
    if (obj is DioError) {
      final res = (obj).response;
      if (res != null) {
        var jsonResponse = json.decode(res.toString());
        String message = jsonResponse['MESSAGE'];
        print("Message" + message);
        serverError(context, message);
      } else {
        serverError(context, null);
      }
    }
    print(res);
  }
}
