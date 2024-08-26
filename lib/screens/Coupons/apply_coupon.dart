import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_overlay_loader.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/no_data_container.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/all_coupons_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/subscription/payment_button.dart';

class ApplyCoupon extends StatefulWidget {
  double? totalAmount;

  ApplyCoupon({Key? key, this.totalAmount}) : super(key: key);

  @override
  _ApplyCouponState createState() => _ApplyCouponState();
}

class _ApplyCouponState extends State<ApplyCoupon> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool? exception;
  AllCouponsResponse? allCouponsResponse;

  String noDataImagePath = 'images/no_coupons.png';
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  var couponCodeText = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCouponList();
  }

  void getCouponList() {
    HttpObj.instance.getClient().getAllCoupons().then((it) {
      if (mounted) {
        setState(() {
          allCouponsResponse = it;
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
    VoidCallback voidcallback = () => {setException(null), getCouponList()};
    return voidcallback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:
          HeaderWidget.appHeader(BaseConstant.APPLY_COUPONS_HEADER, context),
      body: buildAllCoupons(context),
    );
  }

  buildAllCoupons(BuildContext context) {
    return CommonWidget(context).getObjWidget(allCouponsResponse, exception,
        myLayoutWidget(context, allCouponsResponse), retryCallback());
  }

  Widget myLayoutWidget(
      BuildContext context, AllCouponsResponse? allCouponsResponse) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            Container(
                decoration: UiUtil.borderDecorationLightGrey(),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
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
                            FilteringTextInputFormatter.allow(
                                RegExp('[A-Za-z0-9_]')),
                          ],
                          keyboardType: TextInputType.text,
                          cursorColor: WidgetColors.primaryColor,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(0, 10, 10, 10),
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
                              style: FontUtil.style(
                                  FontSizeUtil.Large,
                                  SizeWeight.Medium,
                                  context,
                                  WidgetColors.primaryColor),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            availableCouponHeader(), //Uncomment to show coupon  header
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Row(
                  children: [
                    if (allCouponsResponse != null)
                      (allCouponsResponse.DATA!.length > 0)
                          ? Expanded(
                              child: ListView(
                                children: [
                                  couponsList(allCouponsResponse
                                      .DATA) //Uncomment to show coupon list
                                ],
                              ),
                            )
                          : Expanded(
                              child: NoDataContainer(
                                noDataImagePath,
                                BaseConstant.NO_COUPONS_TITLE,
                                BaseConstant.NO_COUPONS_DESC,
                              ),
                            )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  couponsList(List<AllCouponsData>? allCouponsData) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: allCouponsData!.length,
      itemBuilder: (context, index) => Container(
        decoration: UiUtil.borderDecorationLightGrey(),
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 38,
                  width: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/coupon_code_bg.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      allCouponsData[index].code!,
                      style: FontUtil.style(
                        FontSizeUtil.Large,
                        SizeWeight.Medium,
                        context,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    applyCoupon(allCouponsData[index].code!, context);
                  },
                  child: Container(
                    height: 40,
                    width: 120,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        BaseConstant.APPLY,
                        style: FontUtil.style(
                            FontSizeUtil.Large,
                            SizeWeight.Medium,
                            context,
                            WidgetColors.primaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              allCouponsData[index].title!,
              style: FontUtil.style(FontSizeUtil.Medium, SizeWeight.SemiBold,
                  context, ModeTheme.whiteGrey(context), 1.1),
            ),
            if (allCouponsData[index].description != null)
              couponDescriptionContainer(allCouponsData[index].description!)
          ],
        ),
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
        Navigator.of(context).pop(code);
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
    if (couponCodeText.text.isNotEmpty) {
      if (couponCodeText.text.toString().length == 8) {
        applyCoupon(couponCodeText.text.toUpperCase(), context);
      } else {
        UiUtil.toastPrint("The code must be at least 8 characters.");
      }
    } else {
      UiUtil.toastPrint(BaseConstant.ENTER_REFERRAL_CODE);
    }
  }

  availableCouponHeader() {
    return Row(
      children: [
        Container(
            width: 3.0,
            height: 20.0,
            child: VerticalDivider(
              thickness: 2.0,
              color: WidgetColors.primaryColor,
            )),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  BaseConstant.AVAILABLE_COUPON,
                  style: FontUtil.style(FontSizeUtil.Large, SizeWeight.SemiBold,
                      context, ModeTheme.getDefault(context)),
                ),
              ),
            ),
          ],
        )),
      ],
    );
  }

  couponDescriptionContainer(String description) {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        Text(
          description,
          style: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular,
              context, ModeTheme.lightGreyOrDarkGrey(context), 1.1),
        ),
      ],
    );
  }
}
