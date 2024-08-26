import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/coupon_removal_warning.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/subscription/subscription_data.dart';
import 'package:graphics_news/network/entity/subscription/subscription_dto.dart';
import 'package:graphics_news/screens/subscription/payment_button.dart';

class PeriodHeader extends StatefulWidget {
  List<Period>? periods;
  List<Packages>? packages;
  bool? headReset;
  Function? callbackheaderRestKey;
  Function? callbackDurationKey;
  Function? callbackRestKey;
  Function? refreshData;
  SubscribeData? subscribeData;

  PeriodHeader(
      {Key? key,
      this.periods,
      this.packages,
      this.callbackheaderRestKey,
      this.headReset,
      this.callbackDurationKey,
      this.callbackRestKey,
      this.subscribeData,
      this.refreshData})
      : super(key: key);

  @override
  _PeriodHeaderState createState() => _PeriodHeaderState();
}

class _PeriodHeaderState extends State<PeriodHeader> {
  int lastBtnIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  reset() {
    lastBtnIndex = 0;
    resetDataCheck(widget.headReset!, widget.periods!);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.headReset == true) {
      reset();
   SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.callbackheaderRestKey!(false);
      });
    }

    return topHeaderButton(widget.periods!);
  }

  callbackDuration(String? key) {
 SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.callbackDurationKey!(key);
    });
  }

  Widget topHeaderButton(List<Period>? periodListHead) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: Container(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: periodListHead!.map((element) {
                      var index = periodListHead.indexOf(element);
                      return new GestureDetector(
                        onTap: () {
                          onChangeSelection(periodListHead, element, index);
                        },
                        child: (element.selected != null && element.selected!)
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                decoration: UiUtil.BoxCircleDecoration(),
                                //             <--- BoxDecoration here
                                child: Text(
                                  periodListHead[index].name.toString(),
                                  style: FontUtil.style(
                                      FontSizeUtil.Medium,
                                      SizeWeight.Regular,
                                      context,
                                      Colors.white),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                decoration: UiUtil.simpleBoxDecoration(),
                                //             <--- BoxDecoration here
                                child: Text(
                                  element.name.toString(),
                                  style: FontUtil.style(FontSizeUtil.Medium,
                                      SizeWeight.Regular, context),
                                ),
                              ),
                      );
                    }).toList())))
      ],
    ));
  }

  resetDataCheck(bool reset, List<Object> objectlist) {
    if (reset) {
      int i = 0;
      for (dynamic jsonString in objectlist) {
        if (i == 0) {
          jsonString.selected = true;
          saveData(jsonString.key);
          callbackDuration(jsonString.key);
        } else {
          jsonString.selected = false;
        }
        i++;
      }
    }
  }

  saveData(String? key) {
    widget.subscribeData!.periods = key;
  }

  void onChangeSelection(
      List<Period> periodListHead, Period element, int index) {
    {
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
                    saveSelection(periodListHead, element, index);
                  })
                }
            });
      } else {
        setState(() {
          saveSelection(periodListHead, element, index);
        });
      }
    }
  }

  void saveSelection(List<Period> periodListHead, Period element, int index) {
    periodListHead[lastBtnIndex].selected = false;
    if (widget.subscribeData != null) {
      setSinglePlan(element.key);
      setMultiplePlan(element.key);
    }
    element.selected = true;
    lastBtnIndex = index;
    callbackDuration(element.key);
    widget.refreshData!();
    saveData(element.key);
  }

  setSinglePlan(String? PeriodKey) {
    if (widget.subscribeData!.bundleData != null) {
      if (widget.subscribeData!.bundleData!.duration != null) {
        for (Duration duration in widget.subscribeData!.bundleData!.duration!) {
          if (duration.key == PeriodKey) {
            widget.subscribeData!.bundleData!.amount = duration.price;
            widget.subscribeData!.bundleData!.familyAmount = duration.family_price;
            widget.subscribeData!.bundleData!.appleProductId = duration.apple_product_id;
            widget.subscribeData!.bundleData!.appleFamilyProductId = duration.apple_family_product_id;
            widget.subscribeData!.bundleData!.family_price_arr = duration.family_price_arr;
            break;
          }
        }
      }
    }
  }

  setMultiplePlan(String? Periodkey) {
    if (widget.subscribeData!.multiplePlan != null) {
      for (SinglePlan singlePlan
          in widget.subscribeData!.multiplePlan!.values) {
        if (singlePlan.duration != null) {
          for (Duration duration in singlePlan.duration!) {
            if (duration.key == Periodkey) {
              singlePlan.amount = duration.price;
              singlePlan.familyAmount = duration.family_price;
              singlePlan.appleProductId = duration.apple_product_id;
              singlePlan.appleFamilyProductId = duration.apple_family_product_id;
              singlePlan.family_price_arr = duration.family_price_arr;
              break;
            }
          }
        }
      }
    }
  }
}
