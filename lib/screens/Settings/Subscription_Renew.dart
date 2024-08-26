import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_button.dart';
import 'package:graphics_news/common_widget/title_header.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/subscription/subscription_data.dart';
import 'package:graphics_news/network/response/subscription_response.dart';
import 'package:graphics_news/screens/subscription/all_plans_subscription.dart';
import 'package:graphics_news/screens/subscription/payment_button.dart';

class SubscriptionRenew extends StatefulWidget {
  SubscriptionData? subscriptionData;
  int? NotificationRenewKey;

  SubscriptionRenew(
      {Key? key, this.subscriptionData, this.NotificationRenewKey})
      : super(key: key);

  @override
  _SubscriptionRenew createState() => _SubscriptionRenew();
}

class _SubscriptionRenew extends State<SubscriptionRenew> {
  String? groupValue;
  String? currency;
  double? totalAmount;
  SubscribeData? subscribeData;

  @override
  void initState() {
    getSubsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.subscriptionData == null) {
      return Container();
    }
    return Scaffold(
        appBar: HeaderWidget.appHeader("Renew Subscription", context),
        body: SafeArea(
            child: Container(
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                children: [
                  TitleHeader(
                    title: "Select Epaper Package",
                  ),
                  SizedBox(height: 10),
                  getPackageRadioTile(),
                  SizedBox(height: 5),
                  getRadioTile(),
                  SizedBox(height: 15),
                  CommonButton(
                    btnName: "Change Plan",
                    onTap: allPlans(context),
                  ),
                  SizedBox(height: 15),
                  TitleHeader(
                    title: BaseConstant.CHECKOUT,
                  ),
                  SizedBox(height: 10),
                  PaymentButton(
                      subscribeData: subscribeData,
                      totalAmount: totalAmount,
                      currency: currency,
                      singlePayMode: null,
                      NotificationRenewKey: widget.NotificationRenewKey)
                ],
              ))
            ],
          ),
        )));
  }

  void getSubsData() {
    subscribeData = new SubscribeData();
    totalAmount = double.tryParse(widget.subscriptionData!.amount.toString());
    subscribeData!.familyPackageEnable = widget.subscriptionData!.family;
    subscribeData!.periods = widget.subscriptionData!.duration!.key;
    if (subscribeData!.bundleData == null) {
      subscribeData!.bundleData = new SinglePlan();
    }
    subscribeData!.bundleData!.appleProductId =
        widget.subscriptionData!.apple_product_id;
    subscribeData!.bundleData!.appleFamilyProductId =
        widget.subscriptionData!.apple_family_product_id;
    subscribeData!.bundleData!.planKey = widget.subscriptionData!.key;
    currency = StringUtil.getValue(widget.subscriptionData!.currency);
  }

  Widget getPackageRadioTile() {
    return Container(
        child: RadioListTile<dynamic>(
      activeColor: WidgetColors.primaryColor,
      title: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                widget.subscriptionData!.type.toString(),
                style: FontUtil.style(
                  FontSizeUtil.Medium,
                  SizeWeight.SemiBold,
                  context,
                  WidgetColors.primaryColor,
                ),
              )),
            ],
          ),
        ],
      ),
      groupValue: widget.subscriptionData!.type.toString(),
      value: widget.subscriptionData!.type.toString(),
      onChanged: (val) {
        setState(() {
          groupValue = widget.subscriptionData!.type.toString();
          // saveData(element);
        });
      },
    ));
  }

  Widget getRadioTile() {
    return Container(
        margin: const EdgeInsets.only(left: 26, right: 26),
        decoration: UiUtil.borderDecorationDropDown(),
        child: RadioListTile<dynamic>(
          activeColor: WidgetColors.primaryColor,
          title: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Text(
                        widget.subscriptionData!.value.toString(),
                        style: FontUtil.style(
                          FontSizeUtil.small,
                          SizeWeight.SemiBold,
                          context,
                          WidgetColors.primaryColor,
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    widget.subscriptionData!.description.toString(),
                    style: FontUtil.style(
                      FontSizeUtil.small,
                      SizeWeight.Regular,
                      context,
                      null,
                    ),
                  )),
                ],
              ),
            ],
          ),
          groupValue: widget.subscriptionData!.value.toString(),
          value: widget.subscriptionData!.value.toString(),
          onChanged: (val) {
            setState(() {
              groupValue = widget.subscriptionData!.value.toString();
              // saveData(element);
            });
          },
        ));
  }

  VoidCallback allPlans(BuildContext context) {
    VoidCallback voidcallback = () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AllPlansSubscription()))
          // api for logout
        };
    return voidcallback;
  }
}
