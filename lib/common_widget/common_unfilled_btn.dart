import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';

class CommonUnFilledBtn extends StatelessWidget {
  final String? btnName;
  final VoidCallback? onTap;

  CommonUnFilledBtn({Key? key, this.btnName, this.onTap}) : super(key: key);
  dynamic mediaQueryData;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 35.0),
        child: OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              padding: UiRatio.buttonPadding(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              side: BorderSide(
                width: 1.0,
                color: ModeTheme.getDefault(context),
              ),
            ),
            child: Text(
              btnName!,
              style: FontUtil.style(
                FontSizeUtil.Medium,
                SizeWeight.Medium,
                context,
                ModeTheme.getDefault(context),
              ),
            )));
  }
}
