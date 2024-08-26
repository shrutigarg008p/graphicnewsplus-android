import 'package:flutter/cupertino.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';

/// Created by Amit Rawat on 1/28/2022.

class DownloadUtil {
  static height(BuildContext context) {
    return UiRatio.isPotrait(context)
        ? UiRatio.getHeight(120, 80)
        : UiRatio.getHeight(120, 80);
  }

  static width(BuildContext context) {
    return UiRatio.isPotrait(context)
        ? UiRatio.getHeight(120, 80)
        : UiRatio.getHeight(120, 80);
  }
}
