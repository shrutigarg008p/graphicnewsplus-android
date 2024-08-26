import 'package:flutter/material.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';

/// Created by Amit Rawat on 12/13/2021.
class SettingMobileData extends StatefulWidget {
  bool? mobileData;

  SettingMobileData({Key? key, this.mobileData}) : super(key: key);

  @override
  _SettingMobileDataState createState() => _SettingMobileDataState();
}

class _SettingMobileDataState extends State<SettingMobileData> {
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        isSwitched = widget.mobileData!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return getNotifyTile(isSwitched);
  }

  Widget getNotifyTile(bool? mobileData) {
    if (mobileData == null) {
      return Container();
    }
    return Container(
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
                "Allow Downloads on Mobile Data?",
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
                    savedMobilePref(switchValue);
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

  void savedMobilePref(bool switchValue) {
    buttonChanged(switchValue);
    SharedManager.instance.updateMobileData(switchValue);
  }
}
