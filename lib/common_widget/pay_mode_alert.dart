// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/subtitle_header.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/single_paymode.dart';
import 'package:graphics_news/screens/subscription/all_plans_subscription.dart';
import 'package:graphics_news/screens/subscription/single_page_subscription.dart';

import '../Utility/commonException.dart';
import '../network/services/http_client.dart';
import '../screens/Home/paper/newPaper/news_details.dart';

class PayMode {
  String? name;
  int? index;

  PayMode({this.name, this.index});
}

class PayModeAlert extends StatefulWidget {
  SinglePayMode? singlePayMode;
  VoidCallback? refreshApiData;

  PayModeAlert({
    Key? key,
    this.singlePayMode,
    this.refreshApiData,
  }) : super(key: key);

  @override
  _PayModeAlertState createState() => _PayModeAlertState();
}

class _PayModeAlertState extends State<PayModeAlert> {
// Group Value for Radio Button.
  int? id = 1;
  String? radioItem;
  String? paymenttext = BaseConstant.Next;
  bool? isfreeplanenable = true;
  List<int> packageKeyList = [];
  /*List<PayMode> fList = [
    PayMode(
      index: 1,
      name: BaseConstant.single_purchase,
    ),
    PayMode(
      index: 2,
      name: BaseConstant.with_plans,
    ),
  ];
  List<PayMode> fList1 = [
    PayMode(
      index: 1,
      name: BaseConstant.single_purchase,
    ),
    PayMode(
      index: 2,
      name: BaseConstant.with_plans,
    ),
    PayMode(
      index: 3,
      name: BaseConstant.free_subscription,
    ),
  ];*/
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    isfreeplanenable = widget.singlePayMode!.isfreeplanenablel;
    print("isfreeplanenable  " + isfreeplanenable.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    SubTitleHeader(
                      title: widget.singlePayMode!.title,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                TextValue(BaseConstant.select_plan_desc, context),
                Container(
                  child: Column(
                    children: getLisData(context)
                        .map((data) => ListTileTheme(
                            horizontalTitleGap: -2,
                            minVerticalPadding: 0,
                            contentPadding: EdgeInsets.all(0),
                            child: SizedBox(
                              height: 35.0,
                              child: RadioListTile<dynamic>(
                                dense: true,
                                contentPadding: EdgeInsets.all(0),
                                activeColor: WidgetColors.primaryColor,
                                title: TextValue("${data.name}", context),
                                groupValue: id,
                                value: data.index,
                                onChanged: (val) {
                                  setState(() {
                                    radioItem = data.name;

                                    id = data.index;
                                    if (id == 3) {
                                      paymenttext = "Activate";
                                    } else {
                                      paymenttext = BaseConstant.Next;
                                    }
                                  });
                                },
                              ),
                            )))
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                alertButtons(context)
              ],
            ),
            actions: <Widget>[]));
  }

  alertButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              RouteMap.onBack(context);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: UiUtil.borderDecorationBlackBorder(context),
              child: Align(
                alignment: Alignment.center,
                child: Text(BaseConstant.CANCEL,
                    style: FontUtil.style(
                      FontSizeUtil.Medium,
                      SizeWeight.Medium,
                      context,
                      ModeTheme.lightGreyOrDarkGrey(context),
                    )),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              if (id == 1) {
                singlePayment(context);
              } else if (id == 2) {
                allPayment(context);
              } else if (id == 3) {
                payStackInitWeeklyPlans();
                //RouteMap.onBackTimes(context, 2);

              }
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: UiUtil.borderDecorationFillRed(),
              child: Align(
                alignment: Alignment.center,
                child: Text(paymenttext! /*BaseConstant.Next*/,
                    style: FontUtil.style(FontSizeUtil.Medium,
                        SizeWeight.Medium, context, Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextValue(String value, BuildContext context) {
    return Text(
      value,
      style: FontUtil.style(FontSizeUtil.small, SizeWeight.Regular, context),
    );
  }

  FutureOr apiReload(dynamic value) {
    print("hello");
    widget.refreshApiData!();
  }

  List<PayMode> getLisData(BuildContext context) {
    List<PayMode> fList = [
      PayMode(
        index: 1,
        name: BaseConstant.single_purchase,
      ),
      PayMode(
        index: 2,
        name: BaseConstant.with_plans,
      ),
    ];
    List<PayMode> fList1 = [
      PayMode(
        index: 1,
        name: BaseConstant.single_purchase,
      ),
      PayMode(
        index: 2,
        name: BaseConstant.with_plans,
      ),
      /*PayMode(
        index: 3,
        name: BaseConstant.free_subscription,
      ),*/
    ];

    if (isfreeplanenable != null && isfreeplanenable == false) {
      return fList1;
    } else {
      return fList;
    }
  }

  payStackInitWeeklyPlans() {
    packageKeyList.add(29);
    HttpObj.instance
        .getClient()
        .getPayStackInit(
            packageKeyList, "W", "0", BaseConstant.EMPTY, 0, 'paystack')
        .then((it) {
      UiUtil.toastPrint(it.MESSAGE.toString());
      RouteMap.onBackTimes(context, 2);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewsDetails(
                    newsId: widget.singlePayMode!.id,
                    title: widget.singlePayMode!.title,
                  )));
    }).catchError((Object obj) {
      CommonException().showException(context, obj);
    });
  }

  allPayment(BuildContext context) {
    RouteMap.onBack(context);
    Route route = MaterialPageRoute(
        builder: (context) => AllPlansSubscription(
              PageStack: BaseKey.PAGE_STACK_Detail_Page,
            ));
    Navigator.push(context, route).then(apiReload);
  }

  singlePayment(BuildContext context) {
    double? totalAmount =
        double.tryParse(widget.singlePayMode!.amount.toString());
    if (totalAmount != null && totalAmount > 0) {
      RouteMap.onBack(context);
      Route route = MaterialPageRoute(
          builder: (context) => SinglePageSubscription(
                subscribeData: null,
                totalAmount: totalAmount,
                currency: widget.singlePayMode!.currency,
                singlePayMode: widget.singlePayMode,
              ));
      Navigator.push(context, route).then(apiReload);
      /*     Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SinglePageSubscription(
                    subscribeData: null,
                    totalAmount: totalAmount,
                    currency: widget.singlePayMode!.currency,
                    singlePayMode: widget.singlePayMode,
                  )));*/
    } else {
      UiUtil.showAlert(context, BaseConstant.APPNAME,
          BaseConstant.error_check_plans, null, true);
    }
  }
}
