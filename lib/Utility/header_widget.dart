import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';

class HeaderWidget {
  static Widget header(String headerName, BuildContext context) {
    return Card(
        child: Container(
      height: 42.0,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Container(
                width: 3.0,
                height: 20.0,
                child: VerticalDivider(
                  thickness: 2.0,
                  color: WidgetColors.primaryColor,
                )),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    headerName,
                    style: FontUtil.style(
                      FontSizeUtil.Large,
                      SizeWeight.SemiBold,
                      context,
                    ),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    ));
  }

  static appHeader(String headerTxt, BuildContext context, {bool? border}) {
    return AppBar(
      leadingWidth: 30.0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: GestureDetector(
        onTap: () {
          if (SplashScreen.deeplinkingType != null) {
            print(
                "SplashScreen.deeplinkingType " + SplashScreen.deeplinkingType);
            SplashScreen.deeplinkingType = null;
            SplashScreen.deeplinkingId = null;
          }
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back,
          size: 35,
          color: WidgetColors.primaryColor,
        ),
      ),
      title: Text(
        headerTxt,
        textAlign: TextAlign.center,
        style:
            FontUtil.style(FontSizeUtil.XLarge, SizeWeight.SemiBold, context),
      ),
      shape: border == null
          ? Border(
              bottom: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? WidgetColors.darkGreyColor
                      : WidgetColors.renewButtonColor,
                  width: 1.30))
          : Border(),
    );
  }

  static appHeaderWithActions(
    String headerTxt,
    BuildContext context, {
    bool? border,
    Function()? onPressedMinus,
    Function()? onPressedPlus,
  }) {
    return AppBar(
      leadingWidth: 30.0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 30,
          color: WidgetColors.primaryColor,
        ),
        onPressed: () {
          if (SplashScreen.deeplinkingType != null) {
            print(
                "SplashScreen.deeplinkingType " + SplashScreen.deeplinkingType);
            SplashScreen.deeplinkingType = null;
            SplashScreen.deeplinkingId = null;
          }
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        headerTxt,
        textAlign: TextAlign.center,
        style: FontUtil.style(FontSizeUtil.Large, SizeWeight.SemiBold, context),
      ),
      shape: border == null
          ? Border(
              bottom: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? WidgetColors.darkGreyColor
                      : WidgetColors.renewButtonColor,
                  width: 1.30))
          : Border(),
      actions: [
        GestureDetector(
          onTap: onPressedMinus,
          child: Image(
            image: AssetImage(Theme.of(context).brightness == Brightness.dark
                ? 'images/text_size_small_dark.png'
                : 'images/text_size_small.png'),
            height: 30,
            width: 30,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: onPressedPlus,
          child: Image(
            image: AssetImage(Theme.of(context).brightness == Brightness.dark
                ? 'images/text_size_big_dark.png'
                : 'images/text_size_big.png'),
            height: 30,
            width: 30,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  static subHeader(String headerTxt, BuildContext context,
      {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 25.0,
        padding: const EdgeInsets.only(right: 18.0),
        child: Row(
          children: [
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 3.0,
                          child: VerticalDivider(
                              thickness: 2.0,
                              color: WidgetColors.primaryColor)),
                      Container(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          headerTxt,
                          style: FontUtil.style(FontSizeUtil.XXLarge,
                              SizeWeight.SemiBold, context),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.east,
                          size: 25,
                          color: WidgetColors.primaryColor,
                        )),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
