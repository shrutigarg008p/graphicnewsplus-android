import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';

class CommonWidget {
  late BuildContext context;

  CommonWidget(BuildContext context) {
    this.context = context;
  }

  Widget getObjWidget(
      object, exception, Widget widget, VoidCallback? voidCallback) {
    if (object == null && exception == null) {
      return Center(
        child: SpinKitCircle(
          color: WidgetColors.primaryColor,
          size: UiRatio.circularLoaderSize(50),
        ),
      );
    } else if (object != null && (exception != null && !exception)) {
      if (object!.sTATUS == BaseKey.SUCCESS) {
        return SafeArea(child: widget);
      }
      return retry(BaseConstant.DATA_NOT_FOUND, voidCallback!);
    } else {
      if (object != null) {
        if (object!.sTATUS == BaseKey.FAILURE) {
          return retry(BaseConstant.DATA_NOT_FOUND, voidCallback!);
        }
      }
      if (RouteMap.isLogin()) {
        return retry(
            BaseConstant.SOMETHING_WENT_CONNECTION_WRONG, voidCallback!);
      } else {
        return retry(BaseConstant.PLEASE_LOGIN_TO_CONTINUE, voidCallback!);
      }
    }
  }

  Widget retry(String msg, VoidCallback voidCallback) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Container(
            margin: EdgeInsets.all(10),
            child: Text(
              msg,
              textAlign: TextAlign.center,
              style: FontUtil.style(
                  FontSizeUtil.Large, SizeWeight.SemiBold, context),
            ),
          )),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () => {
              voidCallback(),
            },
            child: Text(
              BaseConstant.RETRY,
              style: FontUtil.style(FontSizeUtil.Medium, SizeWeight.SemiBold,
                  context, Colors.white),
            ),
            style: ElevatedButton.styleFrom(
                primary: WidgetColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
          ),
        ],
      ),
    );
  }
}
