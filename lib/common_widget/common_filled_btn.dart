import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/constant/size_weight.dart';

class CommonFilledBtn extends StatelessWidget {
  final String? btnName;
  final VoidCallback? onTap;

  CommonFilledBtn({Key? key, this.btnName, this.onTap}) : super(key: key);
  dynamic mediaQueryData;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            padding: UiRatio.buttonPadding(12),
            primary: WidgetColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0))),
        child: Text(
          btnName!,
          style: FontUtil.style(14, SizeWeight.Medium, context, Colors.white),
        ),
      ),
    );
  }
}
