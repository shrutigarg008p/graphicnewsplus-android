import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';

class SubHeader extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final bool? isPadding;

  const SubHeader({Key? key, this.title, this.onTap, this.isPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isPadding == null
          ? EdgeInsets.symmetric(horizontal: 18.0)
          : EdgeInsets.zero,
      padding:
          isPadding != null ? EdgeInsets.only(right: 18.0) : EdgeInsets.zero,
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
                    style: FontUtil.style(
                        FontSizeUtil.Large, SizeWeight.SemiBold, context),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
