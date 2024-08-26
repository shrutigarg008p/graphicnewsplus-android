import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';

class CouponRemovalWarning extends StatefulWidget {
  @override
  _CouponRemovalWarningState createState() => _CouponRemovalWarningState();
}

class _CouponRemovalWarningState extends State<CouponRemovalWarning> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  void initState() {
    super.initState();
  }

  contentBox(context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.27
              : MediaQuery.of(context).size.width * 0.27,
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * 0.75
              : MediaQuery.of(context).size.height * 0.75,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ModeTheme.greyOrWhite(context),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              alertHeader(context),
              SizedBox(
                height: 12.0,
              ),
              alertDescription(context),
              SizedBox(
                height: 20.0,
              ),
              alertButtons(context)
            ],
          ),
        ),
      ),
    );
  }
}

alertHeader(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          Container(
              width: 3.0,
              height: 20.0,
              child: VerticalDivider(
                thickness: 2.0,
                color: WidgetColors.primaryColor,
              )),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    BaseConstant.CHANGE_PACKAGE,
                    style: FontUtil.style(FontSizeUtil.Large, SizeWeight.SemiBold,
                        context, ModeTheme.getDefault(context)),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
      SizedBox(
        height: 12.0,
      ),
      Container(
        height: 1,
        color: Theme.of(context).brightness == Brightness.dark
            ? WidgetColors.greyColorLight
            : WidgetColors.renewButtonColor,
      ),
    ],
  );
}

alertDescription(BuildContext context) {
  return Align(
      alignment: Alignment.center,
      child: Text(
          "Are you sure you want to change the plan? You will lose your applied coupon on changing it.",
          style: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular, context,
              ModeTheme.lightGreyOrDarkGrey(context), 1.3)));
}

alertButtons(BuildContext context) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: UiUtil.borderDecorationBlackBorder(context),
            child: Align(
              alignment: Alignment.center,
              child: Text(BaseConstant.NO,
                  style: FontUtil.style(
                    FontSizeUtil.Large,
                    SizeWeight.Medium,
                    context,
                    Theme.of(context).brightness == Brightness.dark
                        ? WidgetColors.greyColorLight
                        : WidgetColors.greyColor,
                  )),
            ),
          ),
        ),
      ),
      SizedBox(
        width: 20,
      ),
      Expanded(
        flex: 1,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context, "removed");
          },
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: UiUtil.borderDecorationFillRed(),
            child: Align(
              alignment: Alignment.center,
              child: Text(BaseConstant.YES.toUpperCase(),
                  style: FontUtil.style(FontSizeUtil.Large, SizeWeight.Medium,
                      context, Colors.white)),
            ),
          ),
        ),
      ),
    ],
  );
}
