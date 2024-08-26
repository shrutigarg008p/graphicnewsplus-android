// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/subtitle_header.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/subscription_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';

class RefundSubscriptionDialog extends StatefulWidget {
  SubscriptionData? subscriptionData;
  int? index;
  Function? refreshRefund;

  RefundSubscriptionDialog(
      {Key? key, this.subscriptionData, this.refreshRefund, this.index})
      : super(key: key);

  @override
  _RefundSubscriptionDialogState createState() =>
      _RefundSubscriptionDialogState();
}

class _RefundSubscriptionDialogState extends State<RefundSubscriptionDialog> {
  var reasonText = TextEditingController();

  bool? isLoading = false;

  @override
  void initState() {
    super.initState();
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
                      title: BaseConstant.cancel_subscription_title,
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
                TextValue(
                    BaseConstant.cancel_subscription_desc +
                        widget.subscriptionData!.value! +
                        BaseConstant.cancel_subscription_end_desc,
                    context),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: reasonEditbox(),
                ),
                SizedBox(
                  height: 25,
                ),
                alertButtons(context)
              ],
            ),
            actions: <Widget>[]));
  }

  Widget reasonEditbox() {
    return Material(
      borderRadius: BorderRadius.circular(5.0),
      elevation: 1.0,
      child: TextFormField(
        style: TextStyle(
          color: ModeTheme.getDefault(context),
          fontSize: FontSizeUtil.small,
        ),
        controller: reasonText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.multiline,
        cursorColor: WidgetColors.primaryColor,
        inputFormatters: [
          LengthLimitingTextInputFormatter(5000),
        ],
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          hintText: "Cancellation Reason",
          hintStyle: TextStyle(
            fontSize: FontSizeUtil.small,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 0.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 0.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        maxLines: 5,
        minLines: 3,
      ),
    );
  }

  alertButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: UiUtil.borderDecorationBlackBorder(context),
              child: Align(
                alignment: Alignment.center,
                child: Text(BaseConstant.NO,
                    style: FontUtil.style(
                      FontSizeUtil.Medium,
                      SizeWeight.Medium,
                      context,
                      ModeTheme.getDefault(context),
                    )),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: isLoading!
              ? LoadingIndicator()
              : GestureDetector(
                  onTap: () {
                    InternetUtil.check().then((value) => {
                          if (value)
                            {
                              refundSubscription(
                                  context,
                                  widget.subscriptionData!.reference_id!,
                                  reasonText.text)
                            }
                          else
                            {InternetUtil.errorMsg(context)}
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: UiUtil.borderDecorationFillRed(),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(BaseConstant.YES,
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

  stopLoading() {
    loading(false);
  }

  startLoading() {
    loading(true);
  }

  loading(bool loader) {
    if (mounted) {
      setState(() {
        isLoading = loader;
      });
    }
  }

  Future refundSubscription(
      BuildContext context, int ReferenceId, String reason) async {
    if (!StringUtil.notEmptyNull(reason)) {
      UiUtil.toastPrint("Please Enter Reason for Cancel Subscription");
      return;
    }

    startLoading();
    HttpObj.instance
        .getClient()
        .SubscriptionRefund(ReferenceId, reason)
        .then((it) {
      stopLoading();
      if (it.sTATUS == BaseKey.SUCCESS) {
        widget.refreshRefund!(widget.index, true, it.MESSAGE);
        RouteMap.onBack(context);
        UiUtil.showAlert(
            context, BaseConstant.cancel_subscription, it.MESSAGE!, null, true);

        return;
      }
      UiUtil.toastPrint(BaseConstant.SOMETHING_WENT_WRONG);
      // return it;
    }).catchError((Object obj) {
      stopLoading();
      CommonException().showException(context, obj);
    });
  }
}
