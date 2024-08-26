import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';

class SubTitleHeader extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;

  const SubTitleHeader({Key? key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
              width: 3.0,
              height: 20.0,
              child: VerticalDivider(
                thickness: 2.0,
                color: WidgetColors.primaryColor,
              )),
          SizedBox(width: 5,),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text(
                    title!,
                    style: FontUtil.style(
                        FontSizeUtil.XLarge, SizeWeight.Bold, context),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 8.0),
              //   child: IconButton(
              //     icon: Icon(
              //       Icons.east_sharp,
              //       color: WidgetColors.primaryColor,
              //     ),
              //     onPressed: () {
              //       onTap!();
              //     },
              //   ),
              // )
            ],
          ))
        ],
      ),
    );
  }
}
