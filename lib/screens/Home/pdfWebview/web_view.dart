import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/screens/Home/blog/promoted/promoted_content_details.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;

  WebViewContainer(this.url);

  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  _WebViewContainerState(this._url);

  @override
  void initState() {
    super.initState;
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: WidgetColors.primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: GestureDetector(
              onHorizontalDragUpdate: (updateDetails) {},
              child: Platform.isAndroid
                  ? WebView(
                      initialUrl: Uri.encodeFull(_url),
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.complete(webViewController);
                      },
                      gestureRecognizers: {
                        Factory(() => EagerGestureRecognizer())
                      },
                      navigationDelegate: (NavigationRequest request) {
                        var id = request.url.split("=").last;

                        print("url is " + request.url.toString());

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PromotedContentDetails(
                                      promotedId: int.parse(id),
                                    )));
                        return NavigationDecision.prevent;
                      },
                      gestureNavigationEnabled: true,
                    )
                  : WebView(
                      initialUrl: Uri.encodeFull(_url),
                      javascriptMode: JavascriptMode.unrestricted,
                      navigationDelegate: (navigation) {
                        final host = Uri.parse(navigation.url).host;

                        var id = navigation.url.toString().split('=').last;

                        if (host.contains('magazine.test')) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PromotedContentDetails(
                                        promotedId: int.parse(id),
                                      )));
                          return NavigationDecision.prevent;
                        }
                        return NavigationDecision.navigate;
                      },
                    ),
            ))
          ],
        ));
  }
}
