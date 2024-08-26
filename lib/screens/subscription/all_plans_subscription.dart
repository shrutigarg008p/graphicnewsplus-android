import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/coupon_removal_warning.dart';
import 'package:graphics_news/common_widget/title_header.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/edges.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/subscription/subscription_data.dart';
import 'package:graphics_news/network/entity/subscription/subscription_dto.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/subscription/mutliple_package.dart';
import 'package:graphics_news/screens/subscription/payment_button.dart';
import 'package:graphics_news/screens/subscription/single_package.dart';
import 'package:graphics_news/screens/subscription/total_members.dart';

import 'period_header.dart';

class AllPlansSubscription extends StatefulWidget {
  String? PageStack;
  bool? resetKey = false;

  AllPlansSubscription({this.PageStack});

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<AllPlansSubscription> {
  String? groupValue;
  String? durationKey;
  SubscriptionDTO? subscriptionDTO;
  int? periodListHeadindex = 0;
  bool? resetKey = false;
  bool? headerResetKey = false;
  String? subDescription;
  SubscribeData? subscribeData;
  double? totalAmount = 0.00;
  bool? exception;
  String? Currency;

  @override
  void initState() {
    resetData();
    getAllPlans();

    super.initState();
  }

  resetData() {
    periodListHeadindex = 0;
    resetKey = false;
    headerResetKey = false;
    // packageKey = null;
  }

  bool isSingleBlogSubscription() {
    if (widget.PageStack != null) {
      if (widget.PageStack == BaseKey.PAGE_STACK_BLOG_Detail_Page) {
        return true;
      }
    }
    return false;
  }

  void getAllPlans() {
    HttpObj.instance.getClient().getSubscriptionPlan().then((it) {
      setState(() {
        subscriptionDTO = it;
        setException(false);
        subscribeData = new SubscribeData();
        if (subscriptionDTO != null) {
          if (isSingleBlogSubscription()) {
            groupValue = subscriptionDTO!.DATA!.plans![2].value;
            subDescription = subscriptionDTO!.DATA!.plans![2].description;
            subscribeData!.packagekey = BaseKey.PACKAGE_PREMIMUM;
            periodListHeadindex = 2;
          } else {
            groupValue = subscriptionDTO!.DATA!.plans![0].value;
            subDescription = subscriptionDTO!.DATA!.plans![0].description;
            subscribeData!.packagekey = BaseKey.PACKAGE_BUNDLE;
          }

          // packageKey = BaseKey.PACKAGE_BUNDLE;
          resetKey = true;
          headerResetKey = true;

          Currency = subscriptionDTO!.DATA!.currency;
        }
      });
    }).catchError((Object obj) {
      setException(true);
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
    VoidCallback voidcallback = () => {
          setException(null),
          getAllPlans()
          // api for logout
        };
    return voidcallback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget.appHeader(BaseConstant.All_PLANS, context),
      body: buildHome(context),
    );
  }

  buildHome(BuildContext context) {
    return CommonWidget(context).getObjWidget(subscriptionDTO, exception,
        myLayoutWidget(context, subscriptionDTO), retryCallback());
  }

  Widget myLayoutWidget(
      BuildContext context, SubscriptionDTO? subscriptionDTO) {
    if (subscriptionDTO == null) {
      return Container();
    }

    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          TitleHeader(
            title: BaseConstant.SELECT_EPAPER_PACKAGE,
          ),
          SizedBox(height: 10),
          getRadioTile(subscriptionDTO.DATA!.plans),
          SizedBox(height: 10),
          getDesc(subDescription),
          SizedBox(height: 10),
          getPeriod(),
          SizedBox(height: 10),
          TitleHeader(
            title: BaseConstant.TOTAL_MEMBERS,
          ),
          SizedBox(height: 5),
          TotalMembers(
            subscribeData: subscribeData,
            amountCallBack: amountCallBack,
          ),
          SizedBox(height: 10),
          TitleHeader(
            title: BaseConstant.CHECKOUT,
          ),
          SizedBox(height: 10),
          PaymentButton(
            subscribeData: subscribeData,
            totalAmount: totalAmount,
            currency: Currency,
            pageStack: widget.PageStack,
          )
        ],
      ),
    ));
  }

  Widget getPeriod() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Edges.mar_subs_horizontal),
      decoration: UiUtil.borderDecorationDropDown(),
      child: Column(
        children: [
          periodListHeadindex != null
              ? PeriodHeader(
                  periods: subscriptionDTO!
                      .DATA!.plans![periodListHeadindex!].period,
                  headReset: headerResetKey,
                  packages: subscriptionDTO!
                      .DATA!.plans![periodListHeadindex!].packages,
                  callbackheaderRestKey: callbackHeaderResetKey,
                  callbackDurationKey: callbackDurationKey,
                  callbackRestKey: callbackResetKey,
                  subscribeData: subscribeData,
                  refreshData: amountCallBack,
                )
              : Container(),
          SizedBox(height: 3),
          periodListHeadindex != null
              ? periodListHeadindex == 1
                  ? MultiplePacakge(
                      packages: subscriptionDTO!
                          .DATA!.plans![periodListHeadindex!].packages,
                      reset: resetKey,
                      durationKey: durationKey,
                      callbackRestKey: callbackResetKey,
                      subscribeData: subscribeData,
                      refreshData: amountCallBack,
                    )
                  : SinglePacakage(
                      packages: subscriptionDTO!
                          .DATA!.plans![periodListHeadindex!].packages,
                      reset: resetKey,
                      durationKey: durationKey,
                      callbackRestKey: callbackResetKey,
                      subscribeData: subscribeData,
                      refreshData: amountCallBack,
                    )
              : Container(),
        ],
      ),
    );
  }

  setPadding(Widget widget, double padding) {
    Padding(
      padding: EdgeInsets.all(padding),
      child: widget,
    );
  }

  getDesc(String? desc) {
    if (StringUtil.notEmptyNull(desc)) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: Edges.mar_subs_horizontal),
        alignment: Alignment.centerLeft,
        child: Text(
          desc!,
          style: FontUtil.style(
            FontSizeUtil.small,
            SizeWeight.Regular,
            context,
          ),
        ),
      );
    }
    return Container();
  }

  Widget getRadioTile(List<Plans>? plansList) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: plansList!.map((element) {
        // get index
        return Expanded(
            flex: 1,
            child: ListTileTheme(
                horizontalTitleGap: -4,
                child: RadioListTile<dynamic>(
                  dense: true,
                  activeColor: WidgetColors.primaryColor,
                  title: Text(
                    element.value.toString(),
                    style: FontUtil.style(
                      FontSizeUtil.small,
                      SizeWeight.SemiBold,
                      context,
                      StringUtil.compareValue(groupValue, element.value)
                          ? WidgetColors.primaryColor
                          : ModeTheme.getDefault(context),
                    ),
                  ),
                  groupValue:
                      groupValue == null ? BaseConstant.EMPTY : groupValue,
                  value: element.value,
                  onChanged: (val) {
                    onChangeSelection(plansList, element);
                  },
                )));
      }).toList(),
    );
  }

  callbackResetKey(newValue) {
    setState(() {
      resetPlan(subscribeData);
      resetKey = newValue;
      amountCallBack();
    });
  }

  callbackHeaderResetKey(newValue) {
    setState(() {
      resetPlan(subscribeData);
      headerResetKey = newValue;
      amountCallBack();
    });
  }

  callbackDurationKey(newValue) {
    setState(() {
      durationKey = newValue;
      amountCallBack();
    });
  }

  callbackResetSaveData() {
    setState(() {
      subscribeData = new SubscribeData();
      amountCallBack();
    });
  }

  resetPlan(SubscribeData? subscribeData) {
    subscribeData!.bundleData = null; //reset single plan
    subscribeData.multiplePlan = null; //reset multiple plan
  }

  amountCallBack() {
    if (subscribeData != null) {
      if (subscribeData!.bundleData != null) {
        checkBundlePlan();
        return;
      } else if (subscribeData!.multiplePlan != null) {
        checkMultiplePlan();
        return;
      }
    }
    setAmount(0.00);
  }

  checkBundlePlan() {
    if (subscribeData!.familyPackageEnable != null) {
      if (subscribeData!.familyPackageEnable!) {
        print(subscribeData!.members.toString() + " Billing for Total Members");
        if (subscribeData!.members != null) {
          for (FamilyPrice familyPrice
              in subscribeData!.bundleData!.family_price_arr!) {
            if (subscribeData!.members == familyPrice.member) {
              var amount = double.parse(familyPrice.amount!) +
                  (double.parse(familyPrice.amount!) / subscribeData!.members!);
              print(amount);

              setAmount(checkNullDouble(amount.toString()));

              // print(familyPrice.amount);

              //setAmount(checkNullDouble(familyPrice.amount));

              return;
            }
          }
        }
        setAmount(checkNullDouble(subscribeData!.bundleData!.familyAmount));
      } else {
        setAmount(checkNullDouble(subscribeData!.bundleData!.amount));
      }
    }
  }

  checkMultiplePlan() {
    if (subscribeData!.multiplePlan != null) {
      if (subscribeData!.familyPackageEnable != null) {
        if (subscribeData!.familyPackageEnable != null &&
            subscribeData!.familyPackageEnable!) {
          if (subscribeData!.members != null) {
            setAmount(calculateMultipleAmount(subscribeData!.members));
          } else {
            setAmount(0.00);
          }
        } else {
          setAmount(calculateMultipleAmount(null));
        }
      }
    }
  }

  calculateMultipleAmount(int? familyMember) {
    double amount = 0.0;
    if (familyMember != null) {
      for (SinglePlan singlePlan in subscribeData!.multiplePlan!.values) {
        if (singlePlan.duration != null) {
          for (FamilyPrice familyPrice in singlePlan.family_price_arr!) {
            if (familyPrice.member == familyMember) {
              amount += checkNullDouble(familyPrice.amount);
              print("family member" + familyPrice.amount.toString());
              print("amoutn" + familyPrice.amount.toString());
              print("amoutn" + familyPrice.amount.toString());
              break;
            }
          }
        }
      }
    } else {
      for (SinglePlan singlePlan in subscribeData!.multiplePlan!.values) {
        if (singlePlan.amount != null) {
          amount += checkNullDouble(singlePlan.amount);
        }
      }
    }
    return amount;
  }

  checkNullDouble(String? value) {
    if (value == null) {
      return 0.00;
    } else {
      return double.tryParse(value.toString());
    }
  }

  setAmount(double? amount) {
    setState(() {
      totalAmount = amount;
    });
  }

  void openCouponRemovalDialog() {}

  void onChangeSelection(List<Plans> plansList, Plans element) {
    setState(() {
      if (PaymentButton.couponCode != null) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CouponRemovalWarning();
            }).then((value) => {
              if (value == "removed")
                {
                  PaymentButton.discountedAmount = null,
                  PaymentButton.couponCode = null,
                  setState(() {
                    saveSelection(plansList, element);
                  })
                }
            });
      } else {
        setState(() {
          saveSelection(plansList, element);
        });
      }
    });
  }

  void saveSelection(List<Plans> plansList, Plans element) {
    groupValue = element.value!;
    var index = plansList.indexOf(element);
    // packageKey = element.key;
    subDescription = element.description;
    periodListHeadindex = index;
    resetKey = true;
    headerResetKey = true;
    subscribeData!.packagekey = element.key;
    subscribeData!.packagevalue = element.value;
  }
}
