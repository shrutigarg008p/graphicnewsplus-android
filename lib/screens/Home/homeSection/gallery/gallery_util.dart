import 'package:flutter/cupertino.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';

/// Created by Amit Rawat on 1/31/2022.
class GalleryUtil {
  static double getDesiredHeigth(BuildContext context) {
    return UiRatio.getHeightGrid(
        context: context,
        height: 130,
        landscapePhone: 20,
        landscapeTablet: 70,
        PotraitTablet: 70);
  }

  static dynamic getImageHeight(BuildContext context) {
    return UiRatio.isPotrait(context)
        ? UiRatio.getHeight(220, 70)
        : UiRatio.getHeight(240, 70);
  }
}
