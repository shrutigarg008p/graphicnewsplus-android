import 'package:flutter/material.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/services/http_client.dart';

/// Created by Amit Rawat on 12/13/2021.
class SettingNotification extends StatefulWidget {
  bool? notification;

  SettingNotification({Key? key, this.notification}) : super(key: key);

  @override
  _SettingNotificationState createState() => _SettingNotificationState();
}

class _SettingNotificationState extends State<SettingNotification> {
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        isSwitched = widget.notification!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return getNotifyTile(isSwitched);
  }

  Widget getNotifyTile(bool? notification) {
    if (notification == null) {
      return Container();
    }
    return Container(
        decoration: UiUtil.bottomBorder(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 16.0,
                    bottom: 16.0,
                  ),
                  child: Text(
                    "Allow Notifications",
                    style: FontUtil.style(
                        FontSizeUtil.Medium, SizeWeight.Regular, context),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      right: 20.0,
                    ),
                    child: Switch(
                      value: isSwitched,
                      activeColor: Colors.black,
                      activeTrackColor: Colors.grey[300],
                      inactiveTrackColor: Colors.grey[300],
                      inactiveThumbColor: WidgetColors.primaryColor,
                      onChanged: (switchValue) {
                        InternetUtil.check().then((value) => {
                              if (value)
                                {
                                  if (switchValue)
                                    {savedNotiy(BaseKey.enable, switchValue)}
                                  else
                                    {savedNotiy(BaseKey.disable, switchValue)}
                                }
                              else
                                {InternetUtil.errorMsg(context)}
                            });
                      },
                    ))
              ],
            ),
          ],
        ));
  }

  buttonChanged(bool value) {
    if (mounted) {
      setState(() {
        isSwitched = value;
      });
    }
  }

  void savedNotiy(String notify, bool switchValue) {
    buttonChanged(switchValue);

    HttpObj.instance.getClient().savedNotification(notify).then((it) {
      String msg = StringUtil.getErrorMsg(it.MESSAGE);
      if (it.sTATUS == BaseKey.SUCCESS) {
        SharedManager.instance.updateNotification(switchValue);
        UiUtil.toastPrint(msg);
      } else {
        buttonChanged(false);
        UiUtil.toastPrint(msg);
      }
    }).catchError((Object obj) {
      buttonChanged(false);
      CommonException().showException(context, obj);
    });
  }
}
