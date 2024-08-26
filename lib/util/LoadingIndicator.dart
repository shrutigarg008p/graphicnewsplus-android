import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';

/// Created by Amit Rawat on 11/8/2021.

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: SpinKitCircle(
          color: WidgetColors.primaryColor,
          size: UiRatio.circularLoaderSize(50),
        ),
      );
}
