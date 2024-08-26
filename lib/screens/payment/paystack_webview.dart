/// Created by Amit Rawat on 1/12/2022.
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaystackWebview extends StatefulWidget {
  String? authUrl;
  String? refernce;
  bool? isSinglemagAndNewsPayMode;
  String? singlePayModeId;
  String? singlePayModePageType;
  List<int>? packageKeyList;
  String? pageStack;
  String? paymentId;
  String? currency;
  String? totalamount;

  PaystackWebview(
      {Key? key,
      this.authUrl,
      this.refernce,
      this.isSinglemagAndNewsPayMode,
      this.singlePayModeId,
      this.singlePayModePageType,
      this.packageKeyList,
      this.pageStack,
      this.paymentId,
      this.currency,
      this.totalamount})
      : super(key: key);

  @override
  _PaystackWebviewState createState() => _PaystackWebviewState();
}

class _PaystackWebviewState extends State<PaystackWebview> {
  bool isLoading = true;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
    print("refernce is" + widget.refernce.toString());
    lockScreen();
  }

  @override
  dispose() {
    super.dispose();
    unlockScreen();
  }

  lockScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget.appHeader(
          widget.paymentId! == 'paystack'
              ? BaseConstant.PAYSTACK
              : 'expressPay',
          context),
      body: Stack(
        children: <Widget>[
          WebView(
            debuggingEnabled: true,
            gestureNavigationEnabled: true,
            initialUrl: widget.authUrl,
            javascriptMode: JavascriptMode.unrestricted,

            //userAgent: 'Android',
            //userAgent: 'Flutter;Webview',
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
            navigationDelegate: (navigation) {
              print("Navigation value-->>" + navigation.toString());
              print("Print url navigation in android  " + navigation.url);
              print("hello");
              print(navigation.url);

              final a = Uri.parse(navigation.url);
              print(a.pathSegments);

              print(a.path);

              if (navigation.url == 'https://standard.paystack.co/close') {
                var uri = Uri.parse(navigation.url);
                var newUri = Uri(
                    query: uri
                        .toString()
                        .substring(uri.toString().indexOf('&') + 1));
                print(newUri.queryParameters['reference']);
                print(newUri.queryParameters['token']);

                print(widget.paymentId);

                if (widget.paymentId == 'paystack') {
                  _updateStatus(widget.refernce, "Success", 'paystack');
                } else {
                  _updateStatus(
                      newUri.queryParameters['token'], "Success", 'express');
                }
                /* Navigator.of(context).pop(); //close webview

                Fluttertoast.showToast(
                    msg:
                        "Something went Wrong with your Payment,Please try again",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    fontSize: 16.0);*/
              }
              //   https: //gcgl.dci.in/public/paystack_callback_wv?trxref=dh06kpfpfi&reference=dh06kpfpfi
              if (a.path == '/paystack_callback_wv' ||
                  a.path ==
                      '/public/paystack_callback_wv') /*/public/paystack_callback_wv */ {
                var uri = Uri.parse(navigation.url);
                var newUri = Uri(
                    query: uri
                        .toString()
                        .substring(uri.toString().indexOf('&') + 1));
                print(newUri.queryParameters['reference']);
                print(newUri.queryParameters['token']);

                print(widget.paymentId);

                if (widget.paymentId == 'paystack') {
                  _updateStatus(newUri.queryParameters['reference'], "Success",
                      'paystack');
                } else {
                  _updateStatus(
                      newUri.queryParameters['token'], "Success", 'express');
                }
              }

              return NavigationDecision.navigate;
            },
          ),
          isLoading ? LoadingIndicator() : Stack(),
        ],
      ),
    );
  }

  unlockScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _updateStatus(String? reference, String message, String paymentMethod) {
    print("message " + message);
    if (widget.isSinglemagAndNewsPayMode!) {
      payStackUpateSingle(widget.singlePayModeId!.toString(),
          widget.singlePayModePageType!, reference, paymentMethod);
      firePurchaseevent(widget.currency, widget.totalamount, "Single purchase",
          widget.paymentId, widget.refernce);
    } else {
      payStackUpdateAllPlans(reference);
      firePurchaseevent(widget.currency, widget.totalamount, "Subscription",
          widget.paymentId, widget.refernce);
    }
  }

  payStackUpateSingle(
      String? key, String? type, String? reference, String? paymentMethod) {
    payStackInitSingleMagAndNews(key, type, reference, null, paymentMethod);
  }

  payStackInitSingleMagAndNews(String? key, String? type, String? reference,
      String? coupon, String? paymentMethod) {
    HttpObj.instance
        .getClient()
        .getSinglePayStackInit(
            key!,
            type!,
            reference ?? BaseConstant.EMPTY,
            coupon ?? BaseConstant.EMPTY,
            widget.paymentId == 'paystack' ? 'paystack' : 'express')
        .then((it) {
      payStackUpdateResponse(it.sTATUS, it.MESSAGE);
    }).catchError((Object obj) {
      CommonException().showException(context, obj);
    });
  }

  payStackUpdateAllPlans(String? reference) {
    HttpObj.instance
        .getClient()
        .PayStackVerify(
            reference!,
            widget.paymentId == 'paystack' ? 'paystack' : 'express',
            null,
            " ",
            " ")
        .then((it) {
      payStackUpdateResponse(it.sTATUS, it.MESSAGE);
    }).catchError((Object obj) {
      CommonException().showException(context, obj);
    });
  }

  payStackUpdateResponse(int? status, String? msg) {
    String errorMsg = BaseConstant.SERVER_ERROR;
    if (msg != null && msg.isNotEmpty) {
      errorMsg = msg;
    }
    if (status == BaseKey.SUCCESS) {
      try {
        oneSignalTags();
      } catch (error) {
        print(error);
      }

      navigatePage();
      return;
    }
    UiUtil.showAlert(context, BaseConstant.SERVER_ERROR, errorMsg, null, true);
  }

  void oneSignalTags() {
    var key;
    if (!widget.isSinglemagAndNewsPayMode!) {
      key = widget.packageKeyList!.toString();
    }
    OneSignal.shared.sendTags({"plan_$key": true}).then((response) {
      print("Successfully sent tags with response: $response");
    }).catchError((error) {
      print("Encountered an error sending tags: $error");
    });
  }

  /*step 1 and 2 coming from mag and news detail page and
  step3 all pans*/
  void navigatePage() {
    if (widget.pageStack != null) {
      if (widget.pageStack == BaseKey.PAGE_STACK_BLOG_Detail_Page) {
        RouteMap.onBackTimes(context, 3);
      } else {
        RouteMap.onBackTimes(context, 3);
      }
    } else if (widget.isSinglemagAndNewsPayMode!) {
      RouteMap.onBackTimes(context, 3);
    } else {
      RouteMap.getHome(context, index: 1);
    }
  }

  firePurchaseevent(String? currency, String? totalamount, String? paymentId,
      String? paymentmethod, String? refernce) async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
    print("currency is " +
        " " +
        currency.toString() +
        "amount is" +
        totalamount.toString());
    await FirebaseAnalytics.instance.logEvent(
      name: "purchase",
      parameters: {
        "currency": currency,
        "price": double.parse(totalamount!),
        "issingleorsubscription": paymentId,
        "paymentmethod": paymentmethod,
        "refernce_Id": refernce
      },
    );
  }
}
