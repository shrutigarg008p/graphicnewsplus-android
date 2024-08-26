import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/screens/Settings/setting_preference_page.dart';

/// Created by Amit Rawat on 1/10/2022.
class SettingPreferenceHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    "Preferences",
                    style: FontUtil.style(
                        FontSizeUtil.Medium, SizeWeight.Regular, context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 20.0,
                  ),
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingPreferencePage()));
                      },
                      icon: Icon(Icons.arrow_forward_ios)),
                ),
              ],
            ),
          ],
        ));
  }
}
