import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/common_widget/common_app_bar.dart';
import 'package:graphics_news/common_widget/common_drawer.dart';
import 'package:graphics_news/network/response/aboutus_response.dart';
import 'package:graphics_news/network/services/http_client.dart';

class Faq extends StatefulWidget {
  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  dynamic mediaQueryData;
  bool? exception;

  AboutUsResponse? responseData;

  @override
  void initState() {
    super.initState();

    callFaq();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
        key: scaffoldKey,
        appBar: CommonAppBar.getAppBar(
            context, () => scaffoldKey.currentState!.openDrawer()),
        drawer: CommonDrawer(),
        body: buildHome(context));
  }

  buildHome(BuildContext context) {
    return CommonWidget(context).getObjWidget(responseData, exception,
        _buildAboutusPage(context, responseData), retryCallback());
  }

  _buildAboutusPage(BuildContext context, AboutUsResponse? homeResponse) {
    return SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 25.0,
          left: 15.0,
          right: 15.0,
        ),
        child: SafeArea(
            child: Html(
          data: responseData == null
              ? "Loading"
              : responseData!.dATA, // Your Html code over here
        )));
  }

  VoidCallback retryCallback() {
    VoidCallback voidcallback = () => {
          setException(null),
          callFaq()
          // api for logout
        };
    return voidcallback;
  }

  void callFaq() {
    HttpObj.instance.getClient().faq().then((it) {
      if (mounted) {
        setState(() {
          responseData = it;
          setException(false);
        });
      }
    }).catchError((Object obj) {
      if (mounted) {
        setException(true);
      }
      CommonException().exception(context, obj);
    });
  }

  setException(bool? value) {
    if (mounted) {
      setState(() {
        exception = value;
      });
    }
  }
}
