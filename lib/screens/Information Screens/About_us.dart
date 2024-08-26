import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/network/response/aboutus_response.dart';
import 'package:graphics_news/network/services/http_client.dart';

class Aboutus extends StatefulWidget {
  final String type;

  const Aboutus({Key? key, required this.type}) : super(key: key);

  @override
  _AboutusState createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  dynamic mediaQueryData;
  bool? exception;

  AboutUsResponse? responseData;

  @override
  void initState() {
    super.initState();
    switch (widget.type) {
      case BaseKey.ABOUT_US_KEY:
        callAboutUs();
        break;
      case BaseKey.PRIVACY_POLICY_KEY:
        callPrivacy();
        break;
      case BaseKey.POLICIES_LICENSE_KEY:
        callPoliciesandlicences();
        break;
      case BaseKey.COURTESIES_KEY:
        callCourtesies();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
        key: scaffoldKey,
        appBar: HeaderWidget.appHeader(widget.type, context),
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
    VoidCallback voidcallback = () => {setException(null), callAboutUs()};
    return voidcallback;
  }

  void callAboutUs() {
    HttpObj.instance.getClient().aboutUs().then((it) {
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

  void callPrivacy() {
    HttpObj.instance.getClient().privacy().then((it) {
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

  void callPoliciesandlicences() {
    HttpObj.instance.getClient().policiesandlicences().then((it) {
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

  void callCourtesies() {
    HttpObj.instance.getClient().courtesies().then((it) {
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
