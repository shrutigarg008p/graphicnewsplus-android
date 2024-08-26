import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/title_header.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/single_paymode.dart';
import 'package:graphics_news/network/entity/subscription/subscription_data.dart';
import 'package:graphics_news/screens/subscription/payment_button.dart';

class SinglePageSubscription extends StatefulWidget {
  SubscribeData? subscribeData;
  SinglePayMode? singlePayMode;
  double? totalAmount;
  String? currency;
  String? weburl;
  SinglePageSubscription(
      {Key? key,
      this.subscribeData,
      this.totalAmount,
      this.currency,
      this.weburl,
      this.singlePayMode})
      : super(key: key);

  @override
  _SinglePageSubscriptionState createState() => _SinglePageSubscriptionState();
}

class _SinglePageSubscriptionState extends State<SinglePageSubscription> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic mediaQueryData;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: HeaderWidget.appHeader(BaseConstant.SINGLE_PURCHASE, context),
      body: buildSinglePageLayout(context),
    );
  }

  buildSinglePageLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            singlePageDetail(),
            SizedBox(height: 15),
            TitleHeader(
              title: BaseConstant.CHECKOUT,
            ),
            SizedBox(height: 10),
            PaymentButton(
              subscribeData: null,
              totalAmount: widget.totalAmount,
              currency: widget.currency,
              singlePayMode: widget.singlePayMode,
            )
          ],
        ),
      ),
    );
  }

  singlePageDetail() {
    var height = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.height * 0.35
        : MediaQuery.of(context).size.width * 0.35;
    var width = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width * 0.50
        : MediaQuery.of(context).size.height * 0.50;
    return Container(
      child: Column(
        children: [
          UiUtil.setImageNetwork2(
              widget.singlePayMode!.coverImage!, width, height,
              border: true),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.singlePayMode!.title!,
            style: FontUtil.style(
              FontSizeUtil.XLarge,
              SizeWeight.SemiBold,
              context,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            widget.singlePayMode!.publication!,
            style: FontUtil.style(
              FontSizeUtil.Medium,
              SizeWeight.Regular,
              context,
            ),
          )
        ],
      ),
    );
  }
}
