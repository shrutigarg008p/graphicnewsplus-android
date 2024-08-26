import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Graphics_services extends StatefulWidget {
  @override
  _Graphics_servicesState createState() => _Graphics_servicesState();
}

class _Graphics_servicesState extends State<Graphics_services> {
  bool isLoading = true;
  bool darkTheme = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget.appHeader(
          BaseConstant.GRAPHICS_SERVICES_HEADER, context),
      body: Container(
        child: Stack(
          children: <Widget>[
            WebView(
              initialUrl: "https://www.graphic.com.gh/eservices",
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: WidgetColors.primaryColor,
                    ),
                  )
                : Stack(),
          ],
        ),
      ),
    );
  }
}

//
