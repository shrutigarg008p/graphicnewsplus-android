import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';

class FullImageView extends StatefulWidget {
  FullImageView(this.imageUrl);
  final String imageUrl;

  @override
  State<FullImageView> createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget.appHeader(BaseConstant.APPNAME, context),
      body: buildImage(context),
    );
  }

  buildImage(BuildContext context) {
    var height = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.height * 0.40
        : MediaQuery.of(context).size.width * 0.40;
    return Center(
      child: InteractiveViewer(
        panEnabled: false, // Set it to false

        minScale: 1,
        maxScale: 5,
        child: UiUtil.setImageNetwork(widget.imageUrl, double.infinity, height,
            border: true),
      ),
    );
  }
}
