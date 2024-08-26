import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/subscription/subscription_data.dart';
import 'package:graphics_news/network/entity/subscription/subscription_dto.dart';

class MultiplePacakge extends StatefulWidget {
  List<Packages>? packages;
  bool? reset;
  String? durationKey;
  Function? callbackRestKey;
  SubscribeData? subscribeData;
  Function? refreshData;

  MultiplePacakge(
      {Key? key,
      this.packages,
      this.durationKey,
      this.callbackRestKey,
      this.reset,
      this.subscribeData,
      this.refreshData})
      : super(key: key);

  @override
  _MultiplePacakgeState createState() => _MultiplePacakgeState();
}

class _MultiplePacakgeState extends State<MultiplePacakge> {
  @override
  void initState() {
    super.initState();
  }

  reset() {
    resetDataCheck(widget.reset!, widget.packages!);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reset == true) {
      reset();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.callbackRestKey!(false);
      });
    }

    return getCheckboxTile(widget.packages!);
  }

  Widget getCheckboxTile(List<Packages>? packages) {
    return Column(
        children: packages!.map((element) {
      return Container(
          margin: const EdgeInsets.all(5.0),
          decoration: (element.ischecked != null && element.ischecked!)
              ? UiUtil.borderDecorationDropDownRed()
              : UiUtil.borderDecorationDropDown(),
          child: CheckboxListTile(
            checkColor: Colors.white,
            activeColor: WidgetColors.primaryColor,
            controlAffinity: ListTileControlAffinity.leading,
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
                            (element.ischecked != null && element.ischecked!)
                                ? WidgetColors.primaryColor
                                : ModeTheme.getDefault(context),
                          ),
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: <Widget>[
                            for (Duration duration in element.duration!)
                              if (duration.key == widget.durationKey) ...[
                                Text(
                                  duration.currency.toString() +
                                      " " +
                                      duration.price.toString(),
                                  style: FontUtil.style(
                                    FontSizeUtil.small,
                                    SizeWeight.SemiBold,
                                    context,
                                    (element.ischecked != null &&
                                            element.ischecked!)
                                        ? WidgetColors.primaryColor
                                        : ModeTheme.getDefault(context),
                                  ),
                                ),
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
                            (element.ischecked != null && element.ischecked!)
                                ? ModeTheme.getDefault(context)
                                : ModeTheme.getDefault(context),
                          ),
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
                                              : ModeTheme.getDefault(context),
                                        ),
                                      )
                              ]
                          ],
                        ))
                  ],
                ),
              ],
            ),
            value: element.ischecked == null ? false : element.ischecked,
            onChanged: (val) {
              setState(
                () {
                  element.ischecked = val!;
                  saveData(element, val);
                },
              );
            },
          ));
    }).toList());
  }

  resetDataCheck(bool reset, List<Object> objectlist) {
    if (reset) {
      int i = 0;
      for (dynamic jsonString in objectlist) {
        jsonString.ischecked = false;
        print("entercondition");
        i++;
      }
    }
  }

  saveData(Packages? packages, bool checked) {
    if (widget.subscribeData!.multiplePlan == null) {
      widget.subscribeData!.multiplePlan = new HashMap();
    }

    if (checked) {
      Map<int, SinglePlan> data = new HashMap();
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
        }
      }
      data[packages.key!] = singlePlan;

      widget.subscribeData!.multiplePlan!.addAll(data);
    } else {
      widget.subscribeData!.multiplePlan!.remove(packages!.key);
    }
    widget.refreshData!();
    print(widget.subscribeData!.multiplePlan);
  }
}
