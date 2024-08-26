import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';

class TitleHeader extends StatelessWidget {
  final String? title;

  const TitleHeader({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return  Card(  margin: EdgeInsets.zero,
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
                            title!,
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


   /* return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
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
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    title!,
                    style:
                        FontUtil.style(17, SizeWeight.SemiBold, context),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );*/

  }
}
