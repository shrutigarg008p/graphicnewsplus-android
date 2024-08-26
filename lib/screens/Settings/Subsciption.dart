import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_app_bar.dart';
import 'package:graphics_news/common_widget/common_button.dart';
import 'package:graphics_news/common_widget/common_drawer.dart';
import 'package:graphics_news/common_widget/common_unfilled_btn.dart';
import 'package:graphics_news/common_widget/title_header.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/subscription_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/subscription/all_plans_subscription.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';

import 'Subscription_Renew.dart';

class Subscription extends StatefulWidget {
  final String? page;

  Subscription({Key? key, this.page}) : super(key: key);

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  SubscriptionResponse? subscriptionResponse;
  var referalCodeText = TextEditingController();
  bool? exception;
  bool buttonLoading = false;

  @override
  void initState() {
    super.initState();
    getMySubscriptionList();
  }

  void getMySubscriptionList() {
    HttpObj.instance.getClient().getMySubscriptions().then((it) {
      if (mounted) {
        setState(() {
          subscriptionResponse = it;
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

  VoidCallback retryCallback() {
    VoidCallback voidcallback =
        () => {setException(null), getMySubscriptionList()};
    return voidcallback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.page != null && widget.page == "drawer"
          ? HeaderWidget.appHeader(BaseConstant.MY_ACCOUNT, context)
          : CommonAppBar.getAppBar(
              context, () => scaffoldKey.currentState!.openDrawer()),
      key: scaffoldKey,
      drawer: CommonDrawer(),
      body: buildHome(context),
    );
  }

  buildHome(BuildContext context) {
    return CommonWidget(context).getObjWidget(subscriptionResponse, exception,
        myLayoutWidget(context, subscriptionResponse), retryCallback());
  }

  Widget myLayoutWidget(
      BuildContext context, SubscriptionResponse? subscriptionResponse) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Visibility(
                    visible: widget.page != null && widget.page == "drawer"
                        ? false
                        : true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "My Account",
                        textAlign: TextAlign.center,
                        style: FontUtil.style(
                            FontSizeUtil.Large, SizeWeight.SemiBold, context),
                      ),
                    ),
                  ),
                  joinFree(),
                  TitleHeader(
                    title: "My Subscription",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CommonButton(
                    btnName: "ALL PLANS",
                    onTap: allPlans(context),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  if (subscriptionResponse != null) subscriptionList(),
                  if (subscriptionResponse != null)
                    SizedBox(
                      height: 32.0,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  VoidCallback allPlans(BuildContext context) {
    VoidCallback voidcallback = () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AllPlansSubscription()))
          // api for logout
        };
    return voidcallback;
  }

  VoidCallback renewSubscription(
      BuildContext context, SubscriptionData subscriptionData) {
    VoidCallback voidcallback = () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SubscriptionRenew(
                      subscriptionData: subscriptionData,
                      NotificationRenewKey: 1)))
          // api for logout
        };
    return voidcallback;
  }

  Widget subscriptionList() {
    return Container(
        child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: subscriptionResponse!.DATA!.length,
      itemBuilder: (context, index) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subscriptionResponse!.DATA![index].value!,
                  style: FontUtil.style(
                    FontSizeUtil.Medium,
                    SizeWeight.SemiBold,
                    context,
                  ),
                ),
                heightPlans(),
                DividerPlans(),
                heightPlans(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Subscription Date",
                      style: FontUtil.style(
                        FontSizeUtil.Medium,
                        SizeWeight.Regular,
                        context,
                      ),
                    ),
                    Text(
                      subscriptionResponse!.DATA![index].subscribed!,
                      style: FontUtil.style(
                        FontSizeUtil.Medium,
                        SizeWeight.Regular,
                        context,
                        Colors.grey,
                      ),
                    ),
                  ],
                ),
                heightPlans(),
                DividerPlans(),
                heightPlans(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expiry Date",
                      style: FontUtil.style(
                        FontSizeUtil.Medium,
                        SizeWeight.Regular,
                        context,
                      ),
                    ),
                    Text(
                      subscriptionResponse!.DATA![index].expired!,
                      style: FontUtil.style(
                        FontSizeUtil.Medium,
                        SizeWeight.Regular,
                        context,
                        Colors.grey,
                      ),
                    ),
                  ],
                ),
                heightPlans(),
                DividerPlans(),
                heightPlans(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Days Left",
                      style: FontUtil.style(
                        FontSizeUtil.Medium,
                        SizeWeight.Regular,
                        context,
                      ),
                    ),
                    /*before two days the red color show in days*/
                    if (getDays(index) <= 2) ...[
                      //red color show in 2 days
                      getDaysWidget(
                          getDays(index), WidgetColors.primaryColor, context),
                    ] else ...[
                      getDaysWidget(getDays(index), Colors.grey, context),
                    ],
                  ],
                ),
                heightPlans(),
                DividerPlans(),
                if (getReferBy(subscriptionResponse!.DATA![index])) ...[
                  heightPlans(),
                  cancelSubscription("Via Referral",
                      subscriptionResponse!.DATA![index].via_referral_code),
                  heightPlans(),
                  DividerPlans(),
                ] else ...[
                  if (subscriptionResponse!.DATA![index].cancel_status !=
                          null &&
                      subscriptionResponse!.DATA![index].cancel_status!) ...[
                    heightPlans(),
                    cancelSubscription("Refund",
                        subscriptionResponse!.DATA![index].cancel_description),
                    heightPlans(),
                    DividerPlans(),
                  ],
                  heightPlans(),
                  if (subscriptionResponse!.DATA![index].referral_code != null)
                    referalCodeContainer(
                        subscriptionResponse!.DATA![index].referral_code),
                  if (subscriptionResponse!.DATA![index].members != null)
                    membersContainer(
                        subscriptionResponse!.DATA![index].members!)
                ],
              ],
            ),
          ),

          /*renew subscription show only for 2 days before expire after 2 days=4days*/
          if (!getReferBy(subscriptionResponse!.DATA![index])) ...[
            if (getDays(index) <= 2 &&
                subscriptionResponse!.DATA![index].renew == 1) ...[
              CommonButton(
                btnName: BaseConstant.renew_subscription,
                onTap: renewSubscription(
                    context, subscriptionResponse!.DATA![index]),
              ),
            ],
          ],
          if (subscriptionResponse!.DATA![index].cancel_status != null &&
              !subscriptionResponse!.DATA![index].cancel_status! &&
              subscriptionResponse!.DATA![index].duration!.key!.toLowerCase() !=
                  BaseKey.Weekly &&
              !getReferBy(subscriptionResponse!.DATA![index])) ...[
            if (getCancelDays(index) > 0 && getCancelDays(index) <= 2) ...[
              CommonUnFilledBtn(
                btnName: BaseConstant.cancel_subscription,
                onTap: () {
                  RouteMap.refundModeAlert(
                    mcontext: context,
                    subscriptionData: subscriptionResponse!.DATA![index],
                    refreshRefundData: refreshRefundData,
                    index: index,
                  );
                },
              )
            ],
          ],
          SizedBox(
            height: 25,
          ),
        ],
      ),
    ));
  }

  getReferBy(SubscriptionData subscriptionData) {
    if (subscriptionData.via_referral != null &&
        subscriptionData.via_referral!) {
      return true;
    }
    return false;
  }

  heightPlans() {
    return SizedBox(
      height: 4,
    );
  }

  DividerPlans() {
    return Divider(
      thickness: 1,
      color: Colors.grey[400],
    );
  }

  cancelSubscription(String text, String? des) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            text,
            style: FontUtil.style(
              FontSizeUtil.Medium,
              SizeWeight.Regular,
              context,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: new Align(
            alignment: Alignment.topRight,
            child: Text(
              des ?? BaseConstant.EMPTY,
              style: FontUtil.style(
                FontSizeUtil.Medium,
                SizeWeight.Regular,
                context,
                WidgetColors.primaryColor,
              ),
            ),
          ),
        )
      ],
    );
  }

  getCancelDays(int index) {
    return StringUtil.get2Days(subscriptionResponse!.DATA![index].subscribed!);
  }

  getDays(int index) {
    return StringUtil.getDays(subscriptionResponse!.DATA![index].subscribed!,
        subscriptionResponse!.DATA![index].expired!);
  }

  getDaysWidget(int days, Color colors, BuildContext context) {
    return Text(
      days <= -1 ? "Expired" : days.toString(),
      style: FontUtil.style(
        FontSizeUtil.Medium,
        SizeWeight.Regular,
        context,
        colors,
      ),
    );
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    /*scaffoldKey.currentState!*/ ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      backgroundColor: WidgetColors.primaryColor,
      content: Text('Copied to clipboard',
          style: FontUtil.style(
            FontSizeUtil.Medium,
            SizeWeight.Regular,
            context,
          )),
    ));
  }

  Widget joinFree() {
    return Column(
      children: [
        TitleHeader(
          title: "Join for Free",
        ),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Material(
            borderRadius: BorderRadius.circular(5.0),
            elevation: 1.0,
            child: TextFormField(
              controller: referalCodeText,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(30),
                FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9-]')),
              ],
              keyboardType: TextInputType.text,
              cursorColor: WidgetColors.primaryColor,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                hintText: "Referral Code",
                hintStyle: FontUtil.style(
                  FontSizeUtil.Medium,
                  SizeWeight.Regular,
                  context,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        buttonLoading
            ? LoadingIndicator()
            : CommonButton(
                btnName: "APPLY",
                onTap: () => joinPlan(),
              ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            "Enter the code shared by your family or friends here.",
            style: FontUtil.style(
              FontSizeUtil.Medium,
              SizeWeight.Regular,
              context,
              Colors.grey,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _membersDialog(
    BuildContext context,
    Members members,
  ) {
    return new AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleHeader(
            title: "My Subscription",
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Total - " +
                  members.total.toString() +
                  BaseConstant.EMPTY_SPACE +
                  "Members",
              style: FontUtil.style(
                  FontSizeUtil.Medium, SizeWeight.Regular, context),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: members.emails!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          members.emails![index],
                          style: FontUtil.style(
                            FontSizeUtil.Medium,
                            SizeWeight.Regular,
                            context,
                            Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  referalCodeContainer(String? refferalCode) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Referral Code",
                    style: FontUtil.style(
                      FontSizeUtil.Medium,
                      SizeWeight.Regular,
                      context,
                    ),
                  ),
                )),
            Expanded(
                flex: 2,
                child: Container(
                    child: GestureDetector(
                  onTap: () {
                    _copyToClipboard(refferalCode!);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              refferalCode!,
                              style: FontUtil.style(
                                FontSizeUtil.Medium,
                                SizeWeight.Regular,
                                context,
                                Colors.grey,
                              ),
                            )),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.copy,
                        size: 20,
                        color: WidgetColors.primaryColor,
                      ),
                    ],
                  ),
                ))),
          ],
        ),
        heightPlans(),
        DividerPlans(),
        heightPlans(),
      ],
    );
  }

  membersContainer(Members members) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Text(
                "Members",
                style: FontUtil.style(
                  FontSizeUtil.Medium,
                  SizeWeight.Regular,
                  context,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _membersDialog(context, members),
                  );
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
        heightPlans(),
        DividerPlans(),
        heightPlans(),
      ],
    );
  }

  joinPlan() {
    if (referalCodeText.text.isNotEmpty) {
      join();
    } else {
      UiUtil.toastPrint(BaseConstant.ENTER_REFERRAL_CODE);
    }
  }

  void join() {
    buttonloadingstate(true);
    HttpObj.instance
        .getClient()
        .getReferralPlan(referalCodeText.text.toUpperCase())
        .then((it) {
      String msg = BaseConstant.SERVER_ERROR;
      if (it.sTATUS == BaseKey.SUCCESS) {
        print(it.MESSAGE);
        UiUtil.toastPrint(it.MESSAGE!);
        referalCodeText.text = "";
        getMySubscriptionList();
      } else {
        UiUtil.toastPrint(it.MESSAGE!);
      }
      buttonloadingstate(false);
    }).catchError((Object obj) {
      buttonloadingstate(false);
      CommonException().showException(context, obj);
    });
  }

  void buttonloadingstate(bool value) {
    setState(() {
      buttonLoading = value;
    });
  }

  void refreshRefundData(int index, bool? status, String msg) {
    if (mounted) {
      setState(() {
        if (subscriptionResponse != null &&
            subscriptionResponse!.DATA != null) {
          subscriptionResponse!.DATA![index].cancel_description = msg;
          subscriptionResponse!.DATA![index].cancel_status = status;
        }
      });
    }
  }
}
