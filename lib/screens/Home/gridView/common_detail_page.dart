import 'package:flutter/material.dart';
//import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/screens/Home/gridView/full_image_view.dart';

class CommonDetailPage extends StatefulWidget {
  CommonDetailPage(this.title, this.imageUrl, this.description);
  final String title;
  final String imageUrl;
  final String description;

  @override
  _CommonDetailPageState createState() => _CommonDetailPageState();
}

class _CommonDetailPageState extends State<CommonDetailPage> {
  String? type;
  double textSize = FontSizeUtil.Medium;
  double titletextSize = FontSizeUtil.XLarge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget.appHeaderWithActions(BaseConstant.APPNAME, context,
          onPressedMinus: () {
        onPressedMinus();
      }, onPressedPlus: () {
        onPressedPlus();
      }),
      body: buildDetail(context),
    );
  }

  buildDetail(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SelectableText(
                widget.title,
                style: FontUtil.style(titletextSize, SizeWeight.SemiBold,
                    context, ModeTheme.getDefault(context), 1.5),
              ),
              const SizedBox(
                height: 15,
              ),
              if (widget.imageUrl != null) imageContainer(),
              SelectableText(
                widget.description,
                style: FontUtil.style(
                    textSize,
                    SizeWeight.Regular,
                    context,
                    Theme.of(context).brightness == Brightness.light
                        ? WidgetColors.greyColor
                        : WidgetColors.renewButtonColor,
                    1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double setTextSize(double size) {
    if (type == "add") {
      return size + 1;
    } else if (type == "remove") {
      return size - 1;
    } else
      return size;
  }

  onPressedPlus() {
    setState(() {
      if (textSize < 25) {
        textSize = textSize + 1;
        titletextSize = titletextSize + 1;
      }
    });
  }

  onPressedMinus() {
    setState(() {
      if (textSize > 9) {
        textSize = textSize - 1;
        titletextSize = titletextSize - 1;
      }
    });
  }

  imageContainer() {
    var height = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.height * 0.30
        : MediaQuery.of(context).size.width * 0.30;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            openImage();
          },
          child: Stack(
            children: [
              UiUtil.setImageNetwork(widget.imageUrl, double.infinity, height,
                  border: true),
              Positioned(
                  bottom: 5,
                  right: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Container(
                      height: 50.0,
                      width: 50,
                      /*child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                          child: const Icon(Icons.zoom_in,
                              size: 30, color: WidgetColors.greyColor)),*/
                    ),
                  ))
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  void openImage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FullImageView(widget.imageUrl)),
    );
  }
}
