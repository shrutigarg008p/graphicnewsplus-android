import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:graphics_news/Utility/ui_util.dart';

class PaperUtility {
  static Widget setDetailPageImage(String? coverImageLink) {
    return Align(
        child: ClipRRect(
      child: Container(
        margin: EdgeInsets.all(5),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: Card(
          elevation: 2,
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: AspectRatio(
                aspectRatio: 0.70,
                child: UiUtil.setImageNetwork(coverImageLink, null, null,
                    border: true),
              )),
        ),
      ),
    ));
  }
}
