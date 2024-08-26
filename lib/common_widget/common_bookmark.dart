import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_overlay_loader.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/network/services/http_client.dart';

class CommonBookMark {
  static void bookmark(
      int? id, String? type, BuildContext context, VoidCallback update) {
    CommonOverlayLoader.showLoader(context);

    HttpObj.instance.getClient().setBookMark(id!, type!).then((it) {
      CommonOverlayLoader.hideLoader(context);
      String msg = BaseConstant.SERVER_ERROR;
      if (it.sTATUS == BaseKey.SUCCESS) {
        print(it.MESSAGE);
        UiUtil.toastPrint(it.MESSAGE!);
        update();
      } else {
        UiUtil.toastPrint(BaseConstant.SOMETHING_WENT_WRONG);
      }
      // return it;
    }).catchError((Object obj) {
      CommonOverlayLoader.hideLoader(context);
      print(obj);
      print('data fetched successfullyerror ');
      CommonException().showException(context, obj);
    });
  }
}
