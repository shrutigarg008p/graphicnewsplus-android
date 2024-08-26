/// Created by Amit Rawat on 12/2/2021.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/coupon_removal_warning.dart';
import 'package:graphics_news/common_widget/title_header.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/subscription/subscription_data.dart';
import 'package:graphics_news/screens/subscription/payment_button.dart';

class TotalMembers extends StatefulWidget {
  SubscribeData? subscribeData;
  Function? amountCallBack;

  TotalMembers({Key? key, this.subscribeData, this.amountCallBack})
      : super(key: key);

  @override
  _TotalMembersState createState() => _TotalMembersState();
}

class _TotalMembersState extends State<TotalMembers> {
  List<String> _locations = [
    '1 Members',
    '2 Members',
    '3 Members',
    '4 Members',
    '5 Members',
    '6 Members',
  ]; // Option 2
  int _groupValue = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool visibilityMemberTag = false;
  var selectedMember = 'Please Select Members';

  @override
  void initState() {
    super.initState();
    if (_groupValue == 0) {
      amountFamilyPack(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return totalMembersWidget();
  }

  Widget totalMembersWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: RadioListTile(
                            value: 0,
                            groupValue: _groupValue,
                            title: Text(
                              "Only Me",
                              style: FontUtil.style(
                                  FontSizeUtil.small,
                                  SizeWeight.Medium,
                                  context,
                                  ModeTheme.getDefault(context)),
                            ),
                            onChanged: (newValue) =>
                                onChangeSelection(_groupValue, newValue, false),
                            activeColor: WidgetColors.primaryColor,
                            selected: false,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: RadioListTile(
                            value: 1,
                            groupValue: _groupValue,
                            title: Text(
                                Platform.isAndroid
                                    ? "With Family & Friends(6 members)"
                                    : "With Family & Friends",
                                style: FontUtil.style(
                                    FontSizeUtil.small,
                                    SizeWeight.Medium,
                                    context,
                                    ModeTheme.getDefault(context))),
                            onChanged: (newValue) => {
                              if (Platform.isAndroid) ...[
                                onChangeSelection(_groupValue, newValue, true),
                              ] else
                                {
                                  setState(() {
                                    _groupValue = newValue as int;
                                    print(_groupValue);

                                    forIosFamilyAmount();
                                  })
                                }
                            },
                            activeColor: WidgetColors.primaryColor,
                            selected: false,
                          ),
                        ),
                      ],
                    ),
                    if (Platform.isAndroid) ...[
                      Visibility(
                          visible: visibilityMemberTag //Default is true,
                          ,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _membersDialog(
                                  context,
                                ),
                              );
                            },
                            child: memberContainer(),
                          ))
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  forIosFamilyAmount() {
    amountFamilyPack(true);
    setState(() {
      if (widget.subscribeData == null) {
        widget.subscribeData = new SubscribeData();
      }
      SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.amountCallBack!();
      });
      widget.subscribeData!.members = 6;
    });
  }

  amountFamilyPack(bool value) {
    if (widget.subscribeData == null) {
      widget.subscribeData = new SubscribeData();
    }

    widget.subscribeData!.familyPackageEnable = value;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.amountCallBack!();
    });
  }

  memberContainer() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: UiUtil.borderDecorationLightGrey(),
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              selectedMember,
              style: FontUtil.style(
                  FontSizeUtil.Medium, SizeWeight.Regular, context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _membersDialog(
    BuildContext context,
  ) {
    return new AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleHeader(
            title: "Please select members",
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _locations.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      _getListItemTile(context, index),
                      Divider(
                          color: Colors
                              .grey), //                           <-- Divider
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getListItemTile(BuildContext context, int index) {
    return ListTile(
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      dense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      title: Text(_locations[index],
          style: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular,
              context, ModeTheme.getDefault(context))),
      onTap: () => {
        setState(() {
          selectedMember = _locations[index];
          if (widget.subscribeData == null) {
            widget.subscribeData = new SubscribeData();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            widget.amountCallBack!();
          });
          widget.subscribeData!.members = index +
              1; // here we will change the price calculation for members.

          RouteMap.onBack(context);
        })
      },
    );
  }

  onChangeSelection(int groupValue, Object? newValue, bool isFamily) {
    {
      visibilityMemberTag = !visibilityMemberTag;

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
                    _groupValue = newValue as int;
                    print(_groupValue.toString() + "on_selection");
                    amountFamilyPack(isFamily);
                  })
                }
            });
      } else {
        setState(() {
          _groupValue = newValue as int;
          print(_groupValue.toString() + "groupvalue");

          amountFamilyPack(isFamily);
        });
      }
    }
  }
}
