// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';

class NoDataContainer extends StatelessWidget {
  NoDataContainer(
      this.noDataImagePath, this.noDataTitle, this.noDataDescription);

  final String noDataImagePath;
  final String noDataTitle;
  final String noDataDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(60, 0, 60, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            width: 34,
            height: 44,
            image: AssetImage(
              noDataImagePath,
            ),
          ),
          SizedBox(
            height: 6.0,
          ),
          Text(
            noDataTitle,
            textAlign: TextAlign.center,
            style: FontUtil.style(FontSizeUtil.Large, SizeWeight.SemiBold, context,
                ModeTheme.getDefault(context), 1.1),
          ),
          SizedBox(
            height: 6.0,
          ),
          Text(
            noDataDescription,
            textAlign: TextAlign.center,
            style: FontUtil.style(
                FontSizeUtil.Medium, SizeWeight.Regular, context, Colors.grey, 1.2),
          )
        ],
      ),
    );
  }
}
