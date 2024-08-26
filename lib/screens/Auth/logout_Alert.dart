import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';

import '../../Utility/commonException.dart';
import '../../Utility/route.dart';
import '../../constant/base_key.dart';

class LogOutAlert extends StatefulWidget {
  LogOutAlert({Key? key}) : super(key: key);

  @override
  _LogOutAlertState createState() => _LogOutAlertState();
}

class _LogOutAlertState extends State<LogOutAlert> {
  bool loader = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
            title: new Text(
              BaseConstant.APPNAME,
              style: FontUtil.style(
                  FontSizeUtil.Medium, SizeWeight.SemiBold, context),
            ),
            content: new Text(
              BaseConstant.ALERT_LOGOUT_DESC,
              style: FontUtil.style(
                  FontSizeUtil.small, SizeWeight.Regular, context),
            ),
            actions: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  loader ? LoadingIndicator() : getYesBtn(context),
                  SizedBox(
                    width: 5,
                  ),
                  getCancelBtn(context)
                ],
              )
            ]));
  }

  Widget getCancelBtn(BuildContext context) {
    return TextButton(
      child: Text(BaseConstant.CANCEL,
          style: FontUtil.style(
            FontSizeUtil.Medium,
            SizeWeight.SemiBold,
            context,
            Colors.blueAccent,
          )),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget getYesBtn(BuildContext context) {
    return TextButton(
      child: new Text(
        BaseConstant.YES,
        style: FontUtil.style(
          FontSizeUtil.Medium,
          SizeWeight.SemiBold,
          context,
          Colors.blueAccent,
        ),
      ),
      onPressed: () {
        InternetUtil.check().then((value) => {
              if (value)
                {callLogout(context)}
              else
                {InternetUtil.errorMsg(context)}
            });
      },
    );
  }

  loaderValue(bool load) {
    if (mounted) {
      setState(() {
        loader = load;
      });
    }
  }

  void callLogout(BuildContext context) {
    loaderValue(true);

    HttpObj.instance.getClient().getLogout().then((it) {
      loaderValue(false);
      if (it.sTATUS == BaseKey.SUCCESS) {
        RouteMap.onBack(context);
        RouteMap().logOut(context);
      }
    }).catchError((Object obj) {
      UiUtil.toastPrint(BaseConstant.SERVER_ERROR);
      loaderValue(false);
      CommonException().exception(context, obj);
    });
  }
}
