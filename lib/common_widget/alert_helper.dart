// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';

class AlertHelper extends StatelessWidget {
  String title;
  String content;
  bool singleButton;


  //BuildContext context;
  VoidCallback continueCallBack;

  AlertHelper(
      this.title, this.content, this.singleButton, this.continueCallBack);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
            title: new Text(
              title,
              style:
                  FontUtil.style(FontSizeUtil.Medium, SizeWeight.SemiBold, context),
            ),
            content: new Text(
              content,
              style:
                  FontUtil.style(FontSizeUtil.small, SizeWeight.Regular, context),
            ),
            actions: <Widget>[
              singleButton
                  ? getokBtn(context)
                  : new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        getYesBtn(context, this.continueCallBack),
                        getCancelBtn(context)
                      ],
                    )
            ]));
  }

  Widget getokBtn(BuildContext context) {
    return TextButton(
      child: Text(BaseConstant.OK,
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

  Widget getYesBtn(BuildContext context, VoidCallback callback) {
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
        callback();
      },
    );
  }
}
