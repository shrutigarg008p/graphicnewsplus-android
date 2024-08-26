import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/coupon_removal_warning.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/subscription/subscription_data.dart';
import 'package:graphics_news/network/entity/subscription/subscription_dto.dart';
import 'package:graphics_news/screens/subscription/payment_button.dart';

class SinglePacakage extends StatefulWidget {
  List<Packages>? packages;
  bool? reset;

  String? durationKey;
  Function? callbackRestKey;
  SubscribeData? subscribeData;
  Function? refreshData;

  SinglePacakage(
      {Key? key,
      this.packages,
      this.reset,
      this.durationKey,
      this.callbackRestKey,
      this.subscribeData,
      this.refreshData})
      : super(key: key);

  @override
  _SinglePacakageState createState() => _SinglePacakageState();
}

class _SinglePacakageState extends State<SinglePacakage> {
  String? groupValue;

  reset() {
    groupValue = null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reset == true) {
      reset();
   SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.callbackRestKey!(false);
      });
    }

    return getRadioTile(widget.packages);
  }

  Widget getRadioTile(List<Packages>? packages) {
    return Column(
        children: packages!.map((element) {
      return Container(
          margin: const EdgeInsets.all(5.0),
          decoration: StringUtil.compareValue(groupValue, element.value)
              ? UiUtil.borderDecorationDropDownRed()
              : UiUtil.borderDecorationDropDown(),
          child: RadioListTile<dynamic>(
            activeColor: WidgetColors.primaryColor,
            title: Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Text(
                          element.value.toString(),
                          style: FontUtil.style(
                              FontSizeUtil.small,
                              SizeWeight.SemiBold,
                              context,
                              StringUtil.compareValue(groupValue, element.value)
                                  ? WidgetColors.primaryColor
                                  : ModeTheme.getDefault(context)),
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: <Widget>[
                            for (Duration duration in element.duration!)
                              if (duration.key == widget.durationKey) ...[
                                Text(
                                  duration.currency.toString() +
                                      BaseConstant.EMPTY_SPACE +
                                      duration.price.toString(),
                                  style: FontUtil.style(
                                      FontSizeUtil.small,
                                      SizeWeight.SemiBold,
                                      context,
                                      StringUtil.compareValue(
                                              groupValue, element.value)
                                          ? WidgetColors.primaryColor
                                          : ModeTheme.getDefault(context)),
                                )
                              ]
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Text(
                          element.description.toString(),
                          style: FontUtil.style(
                              FontSizeUtil.small,
                              SizeWeight.Regular,
                              context,
                              StringUtil.compareValue(groupValue, element.value)
                                  ? ModeTheme.getDefault(context)
                                  : ModeTheme.getDefault(context)),
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: <Widget>[
                            for (Duration duration in element.duration!)
                              if (duration.key == widget.durationKey) ...[
                                duration.discount == null
                                    ? Text(BaseConstant.EMPTY)
                                    : Text(
                                        "Save " + duration.discount.toString(),
                                        style: FontUtil.style(
                                            FontSizeUtil.small,
                                            SizeWeight.Regular,
                                            context,
                                            (element.ischecked != null &&
                                                    element.ischecked!)
                                                ? WidgetColors.primaryColor
                                                : ModeTheme.getDefault(
                                                    context)),
                                      )
                              ]
                          ],
                        ))
                  ],
                ),
              ],
            ),
            groupValue: groupValue == null ? BaseConstant.EMPTY : groupValue,
            value: element.value,
            onChanged: (val) {
              onChangeSelection(element);
            },
          ));
    }).toList());
  }

  saveData(Packages? packages) {
    if (widget.subscribeData == null) {
      widget.subscribeData = new SubscribeData();
    }
    SinglePlan singlePlan = SinglePlan(
        discount: null,
        amount: null,
        appleFamilyProductId: null,
        appleProductId: null,
        planKey: packages!.key,
        planValue: packages.value,
        duration: packages.duration);

    for (Duration duration in packages.duration!) {
      if (duration.key == widget.durationKey) {
        singlePlan.amount = duration.price;
        singlePlan.appleProductId = duration.apple_product_id;
        singlePlan.appleFamilyProductId = duration.apple_family_product_id;
        singlePlan.familyAmount = duration.family_price;
        singlePlan.family_price_arr = duration.family_price_arr;
        widget.subscribeData!.bundleData = singlePlan;
      }
    }
    widget.refreshData!();
  }

  void openCouponRemovalDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CouponRemovalWarning();
        }).then((value) => {
          if (value == "removed")
            {
              PaymentButton.discountedAmount = null,
              PaymentButton.couponCode = null,
              setState(() {})
            }
        });
  }

  void onChangeSelection(Packages element) {
    print("element" + element.toString());
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
                    saveSelection(element);
                  })
                }
            });
      } else {
        setState(() {
          saveSelection(element);
        });
      }
    }
  }

  void saveSelection(Packages element) {
    groupValue = element.value;
    saveData(element);
  }
}
