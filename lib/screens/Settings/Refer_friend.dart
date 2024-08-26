import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_filled_btn.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/auth_dto.dart';
import 'package:share_plus/share_plus.dart';

class Refer_friend extends StatefulWidget {
  @override
  _Refer_friendState createState() => _Refer_friendState();
}

class _Refer_friendState extends State<Refer_friend> {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  User? user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() {
    if (mounted) {
      setState(() {
        user = SharedManager.instance.getUserDetail();
      });
    }
  }

  Widget build(BuildContext context) {
    if (user == null) {
      return Container();
    }
    return Scaffold(
      appBar:
          HeaderWidget.appHeader(BaseConstant.REFER_A_FRIEND_HEADER, context),
      key: scaffoldKey,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    referFriendContainer(),
                    SizedBox(
                      height: 25.0,
                    ),
                    CommonFilledBtn(
                        btnName: "REFER NOW",
                        onTap: () {
                          if (Platform.isAndroid) {
                            referNow(
                                context, StringUtil.getValue(user!.referCode));
                          } else {
                            referNowforios(
                                context, StringUtil.getValue(user!.referCode));
                          }
                        }),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget friendNameTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          keyboardType: TextInputType.phone,
          cursorColor: WidgetColors.primaryColor,
          validator: (input) => input!.isEmpty
              ? 'Enter Username'
              : (input.length < 3 && input.isNotEmpty)
                  ? 'Username too short'
                  : (input.length < 10 && input.isNotEmpty)
                      ? 'Invalid Username'
                      : null,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            hintText: "Friend Name",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          //inputFormatters: [new LengthLimitingTextInputFormatter(10)],
          keyboardType: TextInputType.phone,
          cursorColor: WidgetColors.primaryColor,
          validator: (input) => input!.isEmpty
              ? 'Enter Username'
              : (input.length < 3 && input.isNotEmpty)
                  ? 'Username too short'
                  : (input.length < 10 && input.isNotEmpty)
                      ? 'Invalid Username'
                      : null,
          // if (input == null || input.length < ) {
          //   return 'Enter Phone';
          // }

          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            //errorStyle: TextAlignVertical.center,
            //prefixIcon: Icon(Icons.phone, color: Colors.blue, size: 20),
            hintText: "Email",
            //  hintStyle: TextStyle(color: Colors.black),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          // onSaved: (input) => userName = input,
        ),
      ),
    );
  }

  Widget phoneTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        elevation: 1.0,
        child: TextFormField(
          //inputFormatters: [new LengthLimitingTextInputFormatter(10)],
          keyboardType: TextInputType.phone,
          cursorColor: WidgetColors.primaryColor,
          validator: (input) => input!.isEmpty
              ? 'Enter Username'
              : (input.length < 3 && input.isNotEmpty)
                  ? 'Username too short'
                  : (input.length < 10 && input.isNotEmpty)
                      ? 'Invalid Username'
                      : null,
          // if (input == null || input.length < ) {
          //   return 'Enter Phone';
          // }

          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            //errorStyle: TextAlignVertical.center,
            //prefixIcon: Icon(Icons.phone, color: Colors.blue, size: 20),
            hintText: "Phone",
            //   hintStyle: TextStyle(color: Colors.black),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          // onSaved: (input) => userName = input,
        ),
      ),
    );
  }

  referFriendContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 35.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          referFriendImage(),
          SizedBox(
            height: 25.0,
          ),
          referralCodeTitle(),
          SizedBox(
            height: 10.0,
          ),
          referralCode(),
          SizedBox(
            height: 10.0,
          ),
          referFriendDescription(),
        ],
      ),
    );
  }

  referFriendImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      width: double.infinity,
      height: data.size.shortestSide < 600 ? 180.0 : 400.0,
      child: Image(
        image: AssetImage('images/refer.png'),
        fit: BoxFit.fill,
      ),
    );
  }

  referralCodeTitle() {
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('Refferal Code',
            style: FontUtil.style(16, SizeWeight.SemiBold, context)),
      ),
    );
  }

  referralCode() {
    return Container(
      decoration: UiUtil.borderDecorationLightGrey(),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              child: Text(
                StringUtil.getValue(user!.referCode),
                style: FontUtil.style(
                    FontSizeUtil.Large, SizeWeight.Regular, context),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: () {
                _copyToClipboard(StringUtil.getValue(user!.referCode));
              },
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Icon(
                  Icons.copy,
                  size: 20,
                  color: WidgetColors.primaryColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  referFriendDescription() {
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
            'Please copy this code and share this with your family and friends.',
            style: FontUtil.style(FontSizeUtil.Large, SizeWeight.Medium,
                context, Colors.grey, 1.5)),
      ),
    );
  }

  void _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    /*  scaffoldKey.currentState!*/ ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      backgroundColor: WidgetColors.primaryColor,
      content: Text('Copied to clipboard',
          style: FontUtil.style(
            FontSizeUtil.Medium,
            SizeWeight.Regular,
            context,
          )),
    ));
  }

  referNow(BuildContext context, String referCode) async {
    final box = context.findRenderObject() as RenderBox?;
    final Size size = MediaQuery.of(context).size;

    await Share.share(
        "I'm inviting you to use Graphic NewsPlus, an amazing collection of Newspaper and Magazines. Your referral code for registration is '$referCode'.Please use the link: https://play.google.com/store/apps/details?id=com.graphicnewsplus to download the app",
        sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2));

    //sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  referNowforios(BuildContext context, String referCode) async {
    final box = context.findRenderObject() as RenderBox?;
    final Size size = MediaQuery.of(context).size;

    await Share.share(
        "I'm inviting you to use Graphic NewsPlus, an amazing collection of Newspaper and Magazines. Your referral code for registration is '$referCode'.Please use the link: https://apps.apple.com/ph/app/graphic-newsplus/id1602213036?platform=iphone to download the app",
        sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2));

    //sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }
}
