import 'package:flutter/material.dart';
import 'package:graphics_news/Assets/menu_icon_icons.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';

class CommonAppBar {
  static getAppBar(BuildContext context, VoidCallback onTap) {
    return AppBar(
      leadingWidth: 35.0,
      centerTitle: false,
      toolbarHeight: 50.0,
      title: Text(
        BaseConstant.APPNAME,
        style: FontUtil.style(
          FontSizeUtil.XXXLarge,
          SizeWeight.Bold,
          context,
          Colors.white,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          MenuIcon.hamburger_menu,
          color: Colors.white,
        ),
        onPressed: onTap,
      ),
      backgroundColor: WidgetColors.primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            RouteMap.search(context);
          },
          icon: Icon(
            Icons.search,
            size: 32,
            color: Colors.white,
          ),
        ),
        // IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //           context, MaterialPageRoute(builder: (context) => Login()));
        //     },
        //     icon: Icon(
        //       Icons.person_outline,
        //       color: Colors.white,
        //     ))
      ],
    );
  }

  static getAppBarwithNext(
    BuildContext context,
    VoidCallback onTap,
    VoidCallback ontap,
    isPrevious,
  ) {
    return AppBar(
      leadingWidth: 30.0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,

      title: Text(
        BaseConstant.APPNAME,
        style: FontUtil.style(
          FontSizeUtil.Medium,
          SizeWeight.SemiBold,
          context,
        ),
      ),
      leading: IconButton(
        icon: Icon(

          Icons.arrow_back,
          size: 35,
          color: WidgetColors.primaryColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      // backgroundColor: WidgetColors.primaryColor,
      actions: [
        if (isPrevious)
          TextButton(
            onPressed: ontap,
            child: Text(
              'Previous',
              style: FontUtil.style(FontSizeUtil.Large, SizeWeight.SemiBold,
                  context, WidgetColors.primaryColor),
            ),
          ),
        TextButton(
          onPressed: onTap,
          child: Text('Next',
              style: FontUtil.style(FontSizeUtil.Large, SizeWeight.SemiBold,
                  context, WidgetColors.primaryColor)),
        ),
      ],
    );
  }
}
