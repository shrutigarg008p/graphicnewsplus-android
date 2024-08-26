import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/edges.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/payment/paystack_init.dart';
import 'package:graphics_news/network/entity/single_paymode.dart';
import 'package:graphics_news/network/entity/subscription/subscription_data.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/payment/in_app_purchase.dart';
import 'package:graphics_news/screens/payment/payment_methods.dart';
import 'package:graphics_news/screens/payment/paystack_webview.dart';
import 'package:graphics_news/screens/subscription/payment_button.dart';

class PaymentScreen extends StatefulWidget {
  SubscribeData? subscribeData;
  SinglePayMode? singlePayMode;
  double? totalAmount;
  String? currency;
  int? NotificationRenewKey;
  String? pageStack;

  PaymentScreen(
      {Key? key,
      this.subscribeData,
      this.totalAmount,
      this.currency,
      this.singlePayMode,
      this.NotificationRenewKey,
      this.pageStack})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String imagePath = 'images/success.png';

  List<PaymentMethods>? paymentMethods;

  //dynamic mediaQueryData;
  PaymentMethods? selectedPayment;
  PayStackOptions? _dropDownValue;
  bool optionVisible = false;
  String? totalAmount;
  String? packageKey;
  String? durationKey;
  String? isFamily;
  String? currency;
  bool buttonLoading = false;
  bool darkTheme = false;
  List<int> packageKeyList = [];
  String? appleProductId;

  @override
  void initState() {
    super.initState();
    paymentMethods = PaymentMethods.getPaymentMethods();
    if (isSinglemagAndNewsPayMode()) {
      currency = widget.currency;
      totalAmount = widget.totalAmount!.toStringAsFixed(2);
      appleProductId = widget.singlePayMode!.appleProductId;
    } else {
      SetPacakgeKey();
      if (getIsFamilyPlan()) {
        if (widget.subscribeData!.bundleData != null) {
          appleProductId =
              widget.subscribeData!.bundleData!.appleFamilyProductId;
        }

        isFamily = widget.subscribeData!.members.toString();
      } else {
        if (widget.subscribeData!.bundleData != null) {
          appleProductId = widget.subscribeData!.bundleData!.appleProductId;
        }
        isFamily = "0";
      }
      durationKey = widget.subscribeData!.periods;
      currency = widget.currency;
      totalAmount = widget.totalAmount!.toStringAsFixed(2);
    }
  }

  bool getIsFamilyPlan() {
    if (widget.subscribeData!.familyPackageEnable == true) {
      return true;
    }
    return false;
  }

  SetPacakgeKey() {
    if (widget.subscribeData!.bundleData != null) {
      packageKeyList.add(widget.subscribeData!.bundleData!.planKey!);
    } else if (widget.subscribeData!.multiplePlan != null) {
      for (int key in widget.subscribeData!.multiplePlan!.keys) {
        packageKeyList.add(key);
      }
    }
  }

  bool isSinglemagAndNewsPayMode() {
    if (widget.singlePayMode != null) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget.appHeader(BaseConstant.PAYMENT_METHODS, context),
      body: myLayoutWidget(),
    );
  }

  myLayoutWidget() {
    if (paymentMethods == null) {
      return Container();
    }
    return Container(
        child: Column(
      children: [
        Expanded(child: paymentMethodsList(paymentMethods)),
        paymentButton(),
        SizedBox(
          height: 30,
        )
      ],
    ));
  }

  paymentMethodsList(List<PaymentMethods>? pay) {
    return ListView.builder(
        itemCount: pay!.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: UiUtil.borderDecorationLightGrey(),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.only(right: 10),
                  horizontalTitleGap: 0,
                  title: Text(
                    pay[index].paymentName,
                    style: FontUtil.style(
                        FontSizeUtil.Medium,
                        SizeWeight.Regular,
                        context,
                        ModeTheme.getDefault(context)),
                  ),
                  trailing: Image.asset(
                    pay[index].paymentImage,
                    fit: BoxFit.contain,
                    height: 35,
                    width: 70,
                  ),
                  leading: Radio<PaymentMethods>(
                    value: pay[index],
                    groupValue: selectedPayment,
                    onChanged: (PaymentMethods? value) {
                      print("----------Testing-------");
                      print(value);
                      print(pay[index].paymentName);
                      setState(() {
                        setSelectedPayment(pay[index]);
                      });
                    },
                    activeColor: WidgetColors.primaryColor,
                  ),
                ),
                if (pay[index].payStackOptions != null)
                  Visibility(
                      visible: false,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: getPayStackOptions(pay[index].payStackOptions),
                      ))
              ],
            ),
          );
        });
  }

  paymentButton() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: buttonLoading
            ? Container(
                child: SpinKitCircle(
                  color: WidgetColors.primaryColor,
                  size: 50.0,
                ),
                margin: EdgeInsets.only(bottom: 10),
              )
            : Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(horizontal: Edges.mar_subs_horizontal),
                margin: EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    InternetUtil.check().then((value) => {
                          if (value)
                            {checkout()}
                          else
                            {InternetUtil.errorMsg(context)}
                        });
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(14.0),
                      primary: WidgetColors.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  child: Text(
                    "PAY " +
                        currency! +
                        BaseConstant.EMPTY_SPACE +
                        totalAmount!,
                    style: FontUtil.style(FontSizeUtil.Medium,
                        SizeWeight.Medium, context, Colors.white),
                  ),
                ),
              ));
  }

  setSelectedPayment(PaymentMethods payMethod) {
    setState(() {
      selectedPayment = payMethod;
      print("_dropDownValue " + selectedPayment!.paymentName);
      optionVisible = payMethod.paymentId == 1 ? true : false;
      _dropDownValue = null;
    });
  }

  getPayStackOptions(List<PayStackOptions>? payStackOptions) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: Edges.mar_subs_horizontal),
      padding: EdgeInsets.symmetric(horizontal: Edges.pad_subs_horizontal),
      decoration: UiUtil.borderDecorationLightGrey(),
      child: DropdownButtonHideUnderline(
          child: DropdownButton(
        icon: Icon(Icons.arrow_drop_down_outlined),
        hint: _dropDownValue == null
            ? Text(BaseConstant.PLEASE_SELECT,
                style: FontUtil.style(
                  FontSizeUtil.small,
                  SizeWeight.Regular,
                  context,
                ))
            : Text(_dropDownValue!.optionName,
                style: FontUtil.style(
                  FontSizeUtil.small,
                  SizeWeight.Regular,
                  context,
                )),
        isExpanded: true,
        items: payStackOptions!.map((PayStackOptions payStackOptions) {
          return new DropdownMenuItem<PayStackOptions>(
            value: payStackOptions,
            child: new Text(payStackOptions.optionName,
                style: FontUtil.style(
                  FontSizeUtil.small,
                  SizeWeight.Regular,
                  context,
                )),
          );
        }).toList(),
        onChanged: (PayStackOptions? payStackOptions) {
          setSelectedPayStackOption(payStackOptions);
        },
      )),
    );
  }

  void setSelectedPayStackOption(PayStackOptions? payStackOptions) {
    setState(() {
      _dropDownValue = payStackOptions;
      print("_dropDownValue " + payStackOptions!.optionName);
    });
  }

  checkout() {
    if (selectedPayment == null) {
      UiUtil.toastPrint(BaseConstant.PLEASE_SELECT_PAYMENT_METHOD);
    } else {
      if (selectedPayment!.paymentId == 1 || selectedPayment!.paymentId == 4) {
        getPayStackInit(selectedPayment!.paymentId);
      } else if (selectedPayment!.paymentId == 5) {
        if (appleProductId != null) {
          if (isSinglemagAndNewsPayMode()) {
            RouteMap.pushNav(
                context,
                AppPurchase(
                  appleProductId: appleProductId,
                  pageStack: widget.pageStack,
                  isSinglemagAndNewsPayMode: true,
                  singlekey: widget.singlePayMode!.id.toString(),
                  singleType: widget.singlePayMode!.PageType,
                  coupon: PaymentButton.couponCode,
                  totalAmount: totalAmount,
                  isfamily: isFamily.toString(),
                ));
          } else {
            RouteMap.pushNav(
                context,
                AppPurchase(
                    appleProductId: appleProductId,
                    pageStack: widget.pageStack,
                    isSinglemagAndNewsPayMode: false,
                    totalAmount: totalAmount,
                    isfamily: isFamily.toString()));
          }
        } else {
          UiUtil.toastPrint(BaseConstant.ERROR_PRODUCT_ID_NOT_FOUND);
        }
      }
    }
  }

  void update() {
    setState(() {});
  }

  getPayStackInit(int paymentid) {
    buttonloadingstate(true);
    if (isSinglemagAndNewsPayMode()) {
      var paymentstr = paymentid == 1 ? 'paystack' : 'express';

      payStackInitSingleMagAndNews(
          widget.singlePayMode!.id.toString(),
          widget.singlePayMode!.PageType,
          null,
          PaymentButton.couponCode,
          paymentstr);
    } else {
      var paymentstr = paymentid == 1 ? 'paystack' : 'express';
      PayStackInitAllPlans(packageKeyList, durationKey!, isFamily!,
          PaymentButton.couponCode, paymentstr);
    }
  }

  payStackInitSingleMagAndNews(String? key, String? type, String? reference,
      String? coupon, String? paymentMethod) {
    HttpObj.instance
        .getClient()
        .getSinglePayStackInit(key!, type!, reference ?? BaseConstant.EMPTY,
            coupon ?? BaseConstant.EMPTY, paymentMethod!)
        .then((it) {
      buttonloadingstate(false);
      if (reference == null) {
        initResponse(it,
            paymentMethod); //this code should be commented to not proceed  on webview
      }
    }).catchError((Object obj) {
      buttonloadingstate(false);
      CommonException().showException(context, obj);
    });
  }

  PayStackInitAllPlans(List<int> packageKeyList, String duration,
      String isfamily, String? coupon, String paymentMethod) {
    HttpObj.instance
        .getClient()
        .getPayStackInit(
            packageKeyList,
            duration,
            isfamily,
            coupon ?? BaseConstant.EMPTY,
            widget.NotificationRenewKey ?? 0,
            paymentMethod)
        .then((it) {
      buttonloadingstate(false);
      initResponse(it, paymentMethod);
    }).catchError((Object obj) {
      buttonloadingstate(false);
      CommonException().showException(context, obj);
    });
  }

  initResponse(PayStackInit it, String? paymentMethod) {
    if (it.sTATUS == BaseKey.SUCCESS && it.DATA != null) {
      // String? accessCode = it.DATA!.paystack!.access_code;
      //String? reference = it.DATA!.paystack!.reference;
      String? authUrl = it.DATA!.paystack!.authorization_url;
      String refernce = it.DATA!.paystack!.reference.toString();
      //int amount = int.parse(it.DATA!.amount!);
      //String? Currency = it.DATA!.currency;
      //  int amount = (widget.totalAmount! * 100).toInt();

      print(paymentMethod);
      //  String? Currency = currency;
      if (isSinglemagAndNewsPayMode()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaystackWebview(
                      authUrl: authUrl,
                      refernce: refernce,
                      isSinglemagAndNewsPayMode: true,
                      singlePayModeId: widget.singlePayMode!.id.toString(),
                      singlePayModePageType: widget.singlePayMode!.PageType,
                      packageKeyList: packageKeyList,
                      pageStack: widget.pageStack,
                      paymentId: paymentMethod,
                      currency: currency,
                      totalamount: totalAmount,
                    )));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaystackWebview(
                      authUrl: authUrl,
                      refernce: refernce,
                      isSinglemagAndNewsPayMode: false,
                      packageKeyList: packageKeyList,
                      pageStack: widget.pageStack,
                      paymentId: paymentMethod,
                      currency: currency,
                      totalamount: totalAmount,
                    )));
      }
    }
  }

  void buttonloadingstate(bool stateload) {
    setState(() {
      buttonLoading = stateload;
    });
  }
}
