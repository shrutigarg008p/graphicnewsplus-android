import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/common_widget/alert_helper.dart';
import 'package:graphics_news/common_widget/common_filled_btn.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/historydownload/data_pdf.dart';

import 'mode_theme.dart';

/// Created by Amit Rawat on 11/12/2021.

class UiUtil {
  static noDataFound() {
    return Center(child: Text("No data found"));
  }

  static loadMoreData() {
    return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Center(
          child: CircularProgressIndicator(
            color: WidgetColors.primaryColor,
          ),
        ));
  }

  static nothingToLoad() {
    return Container();
    /* return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      color: Colors.amber,
      child: Center(
        child: Text('You have fetched all of the content'),
      ),
    );*/
  }

  static void getSnack(BuildContext context, String msg) {
    var snackBar = SnackBar(
      content: Text(
        msg,
        style: FontUtil.style(FontSizeUtil.small, SizeWeight.SemiBold, context),
      ),
      duration: Duration(seconds: 5),
      backgroundColor: WidgetColors.primaryColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static CircularProgress() {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
    );
  }

  static setImageNetwork(String? url, double? width, double? height,
      {bool? border}) {
    if (url == null) {
      url = BaseConstant.EMPTY;
    }
    return ClipRRect(
      borderRadius:
          border == null ? BorderRadius.circular(8) : BorderRadius.circular(0),
      child: CachedNetworkImage(
        maxHeightDiskCache: 350,
        maxWidthDiskCache: 350,
        imageUrl: url,
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          size: 30,
        ),
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    );
  }

  static setImageNetwork2(String? url, double? width, double? height,
      {bool? border}) {
    if (url == null) {
      url = BaseConstant.EMPTY;
    }
    return ClipRRect(
      borderRadius:
          border == null ? BorderRadius.circular(8) : BorderRadius.circular(0),
      child: CachedNetworkImage(
        maxHeightDiskCache: 1000,
        maxWidthDiskCache: 1000,
        imageUrl: url,
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          size: 30,
        ),
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    );
  }
  /*static setImageNetwork(String? url, double? width, double? height,
      {bool? border}) {
    if (url == null) {
      url = BaseConstant.EMPTY;
    }
    return ClipRRect(
      borderRadius:
          border == null ? BorderRadius.circular(8) : BorderRadius.circular(0),
      child:Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.fill,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return const  CircularProgressIndicator(

          );
          // You can use LinearProgressIndicator or CircularProgressIndicator instead
        },
        errorBuilder: (context, error, stackTrace) =>
        const Icon(
          Icons.error,
          size: 30,
        ),
      ),




 */ /*     CachedNetworkImage(
        maxHeightDiskCache: 500,
        imageUrl: url,
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          size: 30,
        ),
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),*/ /*
    );
  }*/

  static showAlert(BuildContext mcontext, String title, String description,
      VoidCallback? voidcallback, bool singleBtn) {
    if (voidcallback == null) {
      voidcallback = () => {
            Navigator.of(mcontext).pop(),
          };
    }

    showDialog(
        context: mcontext,
        builder: (BuildContext context) {
          return AlertHelper(title, description, singleBtn, voidcallback!);
        });
  }

  static toastPrint(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        backgroundColor: Colors.grey,
        fontSize: 16.0);
  }

  static BoxDecoration BoxCircleDecoration() {
    return BoxDecoration(
      color: WidgetColors.primaryColor,
      border: Border.all(width: 0.5, color: WidgetColors.primaryColor),
      borderRadius: BorderRadius.all(
          Radius.circular(15.0) //                 <--- border radius here
          ),
    );
  }

  static BoxDecoration simpleBoxDecoration() {
    return BoxDecoration();
  }

  static RoundedRectangleBorder roundedRectanleBorder() {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // if you need this
        side: BorderSide(
          color: Colors.red.withOpacity(0.5),
          width: 1,
        ));
  }

  static RoundedRectangleBorder simpleRoundedRectanleBorder() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));
  }

  static InputDecoration dropdownDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 0.00, horizontal: 10.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: WidgetColors.primaryColor),
        borderRadius: BorderRadius.circular(5.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      filled: true,
    );
  }

  static BoxDecoration borderDecorationLightGrey() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: WidgetColors.renewButtonColor, width: 1.0));
  }

  static BoxDecoration borderDecorationBlackBorder(BuildContext context) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: ModeTheme.getDefault(context), width: 1.0));
  }

  static BoxDecoration borderDecorationFillRed() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: WidgetColors.primaryColor,
        border: Border.all(color: WidgetColors.primaryColor, width: 1.0));
  }

  static BoxDecoration borderDecorationDropDown() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey, width: 1.0));
  }

  static BoxDecoration borderDecorationDropDownRed() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: WidgetColors.primaryColor, width: 1.0));
  }

  static BoxDecoration bottomBorder() {
    return BoxDecoration(
        border: new Border(bottom: new BorderSide(color: Colors.grey)));
  }

  static Widget readButton(DataPdf? dataPdf, BuildContext context) {
    return CommonFilledBtn(
      btnName: BaseConstant.open_document,
      onTap: () {
        if (dataPdf!.grid_view == 1) {
          RouteMap.gridPaper(context, dataPdf.req_id!, dataPdf.type!);
        } else {
          PdfOpen(dataPdf.filepath, context);
        }
      },
    );
  }

  static PdfOpen(String? pdfPath, BuildContext context) {
    if (pdfPath != null && File(pdfPath).existsSync()) {
      RouteMap().openPdf(context, pdfPath, null);
    } else {
      UiUtil.showAlert(context, "Error", "PDF file is not found", null, true);
    }
  }

  static Widget horizontalLine() {
    return Divider(
      color: Colors.grey,
      height: 5,
    );
  }

  static serverError(BuildContext context) {
    UiUtil.showAlert(context, BaseConstant.SERVER,
        BaseConstant.SOMETHING_WENT_WRONG, null, true);
  }

  static SliverGridDelegateWithFixedCrossAxisCount getDefaultDelegate(
      BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisSpacing: 6,
      crossAxisCount: UiRatio.isPotrait(context)
          ? UiRatio.getCount(2, 2)
          : UiRatio.getCount(3, 2),
      childAspectRatio: UiRatio.isPotrait(context)
          ? UiRatio.getHeight(0.95, -0.15)
          : UiRatio.getHeight(1.17, -0.35),
    );
  }
}
