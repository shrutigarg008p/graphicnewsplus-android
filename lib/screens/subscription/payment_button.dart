import 'dart:io';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphics_news/constant/rest_path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_overlay_loader.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_filled_btn.dart';
import 'package:graphics_news/common_widget/thank_you_page.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/single_paymode.dart';
import 'package:graphics_news/network/entity/subscription/subscription_data.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Coupons/apply_coupon.dart';
import 'package:graphics_news/screens/payment/payment_screen.dart';
import 'package:graphics_news/network/entity/payment/paystack_init.dart';

import '../../Utility/route.dart';
import '../Home/paper/newPaper/news_details.dart';

class PaymentButton extends StatefulWidget {
  SubscribeData? subscribeData;
  double? totalAmount;
  String? currency;
  String? weburl;
  static String fallbackUrl = RestPath.BASE_URL2;
  static String? discountedAmount;
  static String? couponCode;
  SinglePayMode? singlePayMode;
  int? NotificationRenewKey;
  String? pageStack;

  String? packageKey;
  String? durationKey;
  String? isFamily;

  bool buttonLoading = false;
  bool darkTheme = false;

  String? appleProductId;

  PaymentButton(
      {Key? key,
      this.subscribeData,
      this.totalAmount,
      this.currency,
      this.singlePayMode,
      this.NotificationRenewKey,
      this.pageStack})
      : super(key: key);

  @override
  _PaymentButtonState createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<PaymentButton> {
  SubscribeData? subscribeData;
  var couponCodeText = TextEditingController();
  double? totalAmount;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController code = TextEditingController();
  String imagePath = 'images/success.png';
  List<int> packageKeyList = [];
  String? durationKey;
  String? isFamily;
  String? appleProductId;
  @override
  void initState() {
    PaymentButton.discountedAmount = null;
    PaymentButton.couponCode = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return checkoutWidget();
  }

  Widget checkoutWidget() {
    return Column(
      children: [
        if (Platform.isAndroid) ...[
          SizedBox(
            height: 10,
          ),
          PaymentButton.couponCode == null
              ? applyCouponContainer2()
              : removeCouponContainer(),
        ],
        SizedBox(
          height: 30,
        ),
        Text("Payment Due",
            style: FontUtil.style(
                FontSizeUtil.XLarge, SizeWeight.SemiBold, context)),
        SizedBox(
          height: 20,
        ),
        if (PaymentButton.discountedAmount != null) oldAmountContainer(),
        Text(
            widget.currency! +
                BaseConstant.EMPTY_SPACE +
                (PaymentButton.discountedAmount != null
                    ? PaymentButton.discountedAmount.toString()
                    : widget.totalAmount!.toStringAsFixed(2)),
            style: FontUtil.style(FontSizeUtil.XXXXLarge, SizeWeight.SemiBold,
                context, WidgetColors.primaryColor)),
        SizedBox(
          height: 10,
        ),
        CommonFilledBtn(btnName: "PAY NOW", onTap: payment(context))
      ],
    );
  }

  oldAmountContainer() {
    return Column(
      children: [
        Text(
            widget.currency! +
                BaseConstant.EMPTY_SPACE +
                widget.totalAmount!.toStringAsFixed(2),
            style: FontUtil.style(
                FontSizeUtil.XXXLarge,
                SizeWeight.SemiBold,
                context,
                ModeTheme.getDefault(context),
                1.0,
                TextDecoration.lineThrough)),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  VoidCallback payment(BuildContext context) {
    VoidCallback voidcallback = () => {
          //print(widget.subscribeData),

          if (widget.totalAmount != null && widget.totalAmount! > 0)
            {
              if (PaymentButton.discountedAmount != null &&
                  PaymentButton.discountedAmount == '0.00')
                {
                  checkout(),
                  debugPrint(
                      "from pay btn222" + PaymentButton.discountedAmount!)
                }
              else
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                                subscribeData: widget.subscribeData,
                                totalAmount:
                                    PaymentButton.discountedAmount != null
                                        ? double.parse(
                                            PaymentButton.discountedAmount!)
                                        : widget.totalAmount,
                                currency: widget.currency,
                                singlePayMode: widget.singlePayMode,
                                NotificationRenewKey:
                                    widget.NotificationRenewKey,
                                pageStack: widget.pageStack,
                              )))
                }
            }
          else
            {
              if (widget.subscribeData!.familyPackageEnable != null)
                {
                  //SetPacakgeKey(),
                  if (widget.subscribeData!.familyPackageEnable! &&
                      widget.subscribeData!.members == null)
                    {
                      UiUtil.showAlert(context, BaseConstant.APPNAME,
                          "Please Select Member", null, true)
                    }
                  else if (widget.totalAmount != null &&
                      widget.totalAmount! == 0 &&
                      packageKeyList[0] == 29)
                    {checkout(), print("from freeplan")}
                  else
                    {
                      UiUtil.showAlert(context, BaseConstant.APPNAME,
                          BaseConstant.error_check_plans, null, true)
                    }
                }
              else
                {
                  UiUtil.showAlert(context, BaseConstant.APPNAME,
                      BaseConstant.error_check_plans, null, true)
                }
            }
        };
    return voidcallback;
  }

  bool isSinglemagAndNewsPayMode() {
    if (widget.singlePayMode != null) return true;
    return false;
  }

  applyCouponContainer2() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: UiUtil.borderDecorationLightGrey(),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: TextFormField(
                style: FontUtil.style(
                    FontSizeUtil.Large, SizeWeight.Regular, context),
                controller: couponCodeText,
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(8),
                  FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9_]')),
                ],
                keyboardType: TextInputType.text,
                cursorColor: WidgetColors.primaryColor,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                    hintText: "Coupon Code",
                    border: InputBorder.none,
                    hintStyle: FontUtil.style(
                        FontSizeUtil.Large,
                        SizeWeight.Regular,
                        context,
                        ModeTheme.lightGreyOrDarkGrey(context))),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                checkValidation();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    BaseConstant.APPLY,
                    style: FontUtil.style(FontSizeUtil.Large, SizeWeight.Medium,
                        context, WidgetColors.primaryColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void applyCoupon(String code, BuildContext context) {
    CommonOverlayLoader.showLoader(context);

    HttpObj.instance
        .getClient()
        .applyCoupon(code, widget.totalAmount.toString())
        .then((it) {
      CommonOverlayLoader.hideLoader(context);
      if (it.sTATUS == BaseKey.SUCCESS) {
        print(it.DATA!.toString());
        PaymentButton.discountedAmount = it.DATA!.amount!.toString();
        PaymentButton.couponCode = code;
        setState(() {
          PaymentButton.discountedAmount = it.DATA!.amount!.toString();

          debugPrint(PaymentButton.discountedAmount);
          debugPrint(totalAmount.toString());
        });
        // Navigator.of(context).pop(code);
        /*  PaymentButton.couponCode == null
            ? applyCouponContainer2()
            : removeCouponContainer();*/
      } else {
        UiUtil.toastPrint(BaseConstant.SOMETHING_WENT_WRONG);
      }
    }).catchError((Object obj) {
      CommonOverlayLoader.hideLoader(context);
      print('data fetched successfullyerror ');
      CommonException().showException(context, obj);
    });
  }

  void checkValidation() {
    if (widget.totalAmount != null && widget.totalAmount! > 0) {
      if (couponCodeText.text.isNotEmpty) {
        if (couponCodeText.text.toString().length == 8) {
          if (Platform.isIOS) {
            showAlertDialog(context);
          } else {
            applyCoupon(couponCodeText.text.toUpperCase(), context);
            //showAlertDialog(context);
          }
        } else {
          UiUtil.toastPrint("The code must be at least 8 characters.");
        }
      } else {
        UiUtil.toastPrint(BaseConstant.ENTER_REFERRAL_CODE);
      }
    } else {
      UiUtil.showAlert(context, BaseConstant.APPNAME,
          BaseConstant.error_check_plans, null, true);
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          PaymentButton.couponCode = couponCodeText.text.toUpperCase();
          openUrl();
        });
    Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context, false);
        });
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(
          "You will be redirected to the Web to take advantage of this Code"),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  applyCouponContainer() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: UiUtil.borderDecorationLightGrey(),
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
                onTap: () {
                  openApplyCouponScreen();
                },
                child: Text(
                  "Apply Coupon",
                  style: FontUtil.style(
                      FontSizeUtil.Medium, SizeWeight.Regular, context),
                )),
          ),
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  openApplyCouponScreen();
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  removeCouponContainer() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: UiUtil.borderDecorationLightGrey(),
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    PaymentButton.couponCode.toString(),
                    style: FontUtil.style(
                        FontSizeUtil.Medium, SizeWeight.Regular, context),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(BaseConstant.OFFER_APPLIED_SUCCESSFULLY,
                      style: FontUtil.style(
                          FontSizeUtil.xsmall,
                          SizeWeight.Regular,
                          context,
                          ModeTheme.lightGreyOrDarkGrey(context))),
                ],
              )),
          Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  removeCoupon();
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.close,
                    size: 18,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  void openApplyCouponScreen() {
    if (widget.totalAmount != null && widget.totalAmount! > 0) {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ApplyCoupon(totalAmount: widget.totalAmount)))
          .then((couponCode) {
        setState(() {});
        if (couponCode != null && couponCode.toString().isNotEmpty) {
          ThankYouPage.thankYou(imagePath, BaseConstant.APPLIED_TITLE,
              'Your Coupon code $couponCode is successfully applied.', context);
        }
        debugPrint(couponCode);
      });
    } else {
      UiUtil.showAlert(context, BaseConstant.APPNAME,
          BaseConstant.error_check_plans, null, true);
    }
  }

  void removeCoupon() {
    CommonOverlayLoader.showLoader(context);

    HttpObj.instance
        .getClient()
        .removeCoupon(PaymentButton.couponCode!)
        .then((it) {
      CommonOverlayLoader.hideLoader(context);
      if (it.sTATUS == BaseKey.SUCCESS) {
        print(it.DATA!.toString());
        UiUtil.toastPrint(it.MESSAGE!);
        PaymentButton.discountedAmount = null;
        PaymentButton.couponCode = null;
        couponCodeText.clear();
        setState(() {});
      } else {
        UiUtil.toastPrint(BaseConstant.SOMETHING_WENT_WRONG);
      }
      // return it;
    }).catchError((Object obj) {
      CommonOverlayLoader.hideLoader(context);
      CommonException().showException(context, obj);
    });
  }

  checkout() {
    getPayStackInit();
  }

  getPayStackInit() {
    if (isSinglemagAndNewsPayMode()) {
      payStackInitSingleMagAndNews(
          widget.singlePayMode!.id.toString(),
          widget.singlePayMode!.PageType,
          null,
          PaymentButton.couponCode,
          'paystack');
    } else {
      SetPacakgeKey();
      durationKey = widget.subscribeData!.periods;
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
      PayStackInitAllPlans(packageKeyList, durationKey, isFamily!,
          PaymentButton.couponCode, 'paystack');
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
      //packageKeyList.clear();
      for (int key in widget.subscribeData!.multiplePlan!.keys) {
        packageKeyList.add(key);
      }
    }
  }

  PayStackInitAllPlans(List<int> packageKeyList, String? duration,
      String isfamily, String? coupon, String paymentMethod) {
    HttpObj.instance
        .getClient()
        .getPayStackInit(
            packageKeyList,
            duration!,
            isfamily,
            coupon ?? BaseConstant.EMPTY,
            widget.NotificationRenewKey ?? 0,
            paymentMethod)
        .then((it) {
      UiUtil.toastPrint(it.MESSAGE.toString());
      Navigator.of(context).pop();

      initResponse(it, paymentMethod);
    }).catchError((Object obj) {
      CommonException().showException(context, obj);
    });
  }

  payStackInitSingleMagAndNews(String? key, String? type, String? reference,
      String? coupon, String? paymentMethod) {
    HttpObj.instance
        .getClient()
        .getSinglePayStackInit(key!, type!, reference ?? BaseConstant.EMPTY,
            coupon ?? BaseConstant.EMPTY, paymentMethod!)
        .then((it) {
      UiUtil.toastPrint(it.MESSAGE.toString());
      Navigator.of(context).pop(true);
      /*  Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewsDetails() */ /*HomePage()*/ /*));*/
      if (reference == null) {
        initResponse(it, paymentMethod);
      }
    }).catchError((Object obj) {
      debugPrint("from exception" + "exception");
      CommonException().showException(context, obj);
    });
  }

  initResponse(PayStackInit it, String? paymentMethod) {
    if (it.sTATUS == BaseKey.SUCCESS && it.DATA != null) {
      debugPrint("from suceess" + "success");
    }
  }

  static openUrl() async {
    try {
      print(SharedManager.instance.getWebUrl() + "formopenurl--->>");
      print(SharedManager.instance.getWebUrl() +
          "&coupon=" +
          PaymentButton.couponCode +
          "formopenurlfull--->>");
      bool launched = await launch(
          SharedManager.instance.getWebUrl() +
              "&coupon=" +
              PaymentButton.couponCode,
          forceSafariVC: false);
      PaymentButton.couponCode = null;

      if (!launched) {
        print(SharedManager.instance.getWebUrl() + "!launched");
        await launch(
            SharedManager.instance.getWebUrl() +
                "&coupon=" +
                PaymentButton.couponCode,
            forceSafariVC: false);
      }
    } catch (e) {
      print(e.toString());
      await launch(
          SharedManager.instance.getWebUrl() +
              "&coupon=" +
              PaymentButton.couponCode,
          forceSafariVC: false);
    }
  }
}
