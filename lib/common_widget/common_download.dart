import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/permission_util.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_unfilled_btn.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/database/SQLiteDbProvider.dart';
import 'package:graphics_news/database/file_util.dart';
import 'package:graphics_news/network/entity/historydownload/data_pdf.dart';
import 'package:graphics_news/network/entity/historydownload/data_pdf_response.dart';
import 'package:graphics_news/network/entity/markDownload/mark_download_resp.dart';
import 'package:graphics_news/network/entity/single_paymode.dart';
import 'package:graphics_news/network/response/magazine_detail_pdf_response.dart';
import 'package:graphics_news/network/services/common_dio.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';

import '../network/services/http_client.dart';
import '../screens/subscription/single_page_subscription.dart';

class CommonDownload extends StatefulWidget {
  Posts? post;
  bool? isold;
  String? weburl;
  String? PublishTag;
  String? historyData;
  Function? function;
  VoidCallback? refreshApiData;
  VoidCallback? retryCallBack;
  String? btnName;
  bool? automaticDownload;
  Function? disableAutoDownload;

  CommonDownload(
      {Key? key,
      this.post,
      this.isold,
      this.PublishTag,
      this.historyData,
      this.function,
      this.refreshApiData,
      this.retryCallBack,
      this.btnName,
      this.automaticDownload,
      this.disableAutoDownload})
      : super(key: key);

  @override
  _CommonDownloadState createState() => _CommonDownloadState();
}

class _CommonDownloadState extends State<CommonDownload> {
  bool? isLoading = false;
  String progress = "";

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return isLoading!
        ? LoadingIndicator()
        : CommonUnFilledBtn(
            btnName: widget.btnName,
            onTap: getAutoDownload()
                ? getDownload()
                : () {
                    getDownload();
                  });
  }

  bool getAutoDownload() {
    if (widget.automaticDownload != null) {
      if (widget.automaticDownload!) {
        StopAutoDownload();
        return true;
      }
    }
    return false;
  }

  StopAutoDownload() {
    if (widget.disableAutoDownload != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.disableAutoDownload!(null);
      });
    }
  }

  getDownload() {
    if (RouteMap.isLogin()) {
      if (widget.post!.subscribed != null && widget.post!.subscribed!) {
        requestWritePermission(widget.post!);
      } else if (!widget.post!.subscribed! && widget.isold == true) {
        SinglePayMode singlePayMode = new SinglePayMode();
        singlePayMode.title = widget.post!.title;
        singlePayMode.id = widget.post!.id;
        singlePayMode.amount = widget.post!.price;
        singlePayMode.coverImage = widget.post!.coverImageLink;
        singlePayMode.publication = widget.post!.publication!.name;
        singlePayMode.currency = widget.post!.currency;
        singlePayMode.thumbnail = widget.post!.thumbnailImageLink;
        singlePayMode.PageType = widget.PublishTag;
        singlePayMode.appleProductId = widget.post!.apple_product_id;
        singlePayMode.isold = widget.isold;
        singlePayMethod(context, singlePayMode);
      } else {
        singlePayment();
      }
    } else {
      RouteMap.backReloadLogin(context, retryCallBack);
    }
  }

  getProfile() {
    UiUtil.showAlert(context, BaseConstant.APPNAME,
        BaseConstant.profile_update_data, profileRoute(context), false);
  }

  VoidCallback profileRoute(BuildContext context) {
    VoidCallback voidcallback = () => {RouteMap.ProfilePage(context)};
    return voidcallback;
  }

  singlePayment() {
    SinglePayMode singlePayMode = new SinglePayMode();
    singlePayMode.title = widget.post!.title;
    singlePayMode.id = widget.post!.id;
    singlePayMode.amount = widget.post!.price;
    singlePayMode.coverImage = widget.post!.coverImageLink;
    singlePayMode.publication = widget.post!.publication!.name;
    singlePayMode.currency = widget.post!.currency;
    singlePayMode.thumbnail = widget.post!.thumbnailImageLink;
    singlePayMode.PageType = widget.PublishTag;
    singlePayMode.appleProductId = widget.post!.apple_product_id;
    singlePayMode.isold = widget.isold;
    singlePayMode.isfreeplanenablel = widget.post!.isfreeplanenabled;

    if (widget.PublishTag ==
            BaseKey
                .Publish_NewsPaper /*&&
        singlePayMode.isold == false*/
        ) {
      RouteMap.payModeAlert(context, singlePayMode, widget.refreshApiData);
    } else {
      singlePayMethod(context, singlePayMode);
    }

    /*use of alert box single and multiple */
    // RouteMap.payModeAlert(context, singlePayMode, widget.refreshApiData);
  }

  FutureOr apiReload(dynamic value) {
    widget.refreshApiData!();
  }

  FutureOr retryCallBack(dynamic value) {
    if (RouteMap.isLogin()) {
      widget.retryCallBack!();
    }
  }

  singlePayMethod(BuildContext context, SinglePayMode singlePayMode) {
    double? totalAmount = double.tryParse(singlePayMode.amount.toString());
    if (totalAmount != null && totalAmount > 0) {
      //  RouteMap.onBack(context);
      Route route = MaterialPageRoute(
          builder: (context) => SinglePageSubscription(
                subscribeData: null,
                totalAmount: totalAmount,
                currency: singlePayMode.currency,
                singlePayMode: singlePayMode,
              ));
      Navigator.push(context, route).then(apiReload);
    } else {
      UiUtil.showAlert(context, BaseConstant.APPNAME,
          BaseConstant.error_check_plans, null, true);
    }
  }

  requestWritePermission(Posts postData) async {
    if (Platform.isIOS) {
      checkMobileDataEnable(postData);
    } else {
      Permission.storage.isGranted.then((value) => {
            if (value)
              {checkMobileDataEnable(postData)}
            else
              {PermissionUtil().checkPermissionStorage()}
          });
    }
  }

  checkMobileDataEnable(Posts postData) {
    dynamic mobileData = SharedManager.instance.getMobileData();
    if (mobileData) {
      checkMobileAndWifi(postData);
    } else {
      checkWifi(postData);
    }
  }

  checkWifi(Posts postData) {
    InternetUtil.checkWifi().then((value) => {
          if (value)
            {checkUid(postData)}
          else
            {InternetUtil.errorMsgWifi(context)}
        });
  }

  checkMobileAndWifi(Posts postData) {
    InternetUtil.check().then((value) => {
          if (value) {checkUid(postData)} else {InternetUtil.errorMsg(context)}
        });
  }

  checkUid(Posts postData) {
    SQLiteDbProvider.db.uidExists(postData.uId).then((value) => {
          print("check uid exits "),
          if (!value)
            {
              startLoading(),
              if (postData.gridView!)
                {setGridView(postData)}
              else
                {getPdfMagNews(postData)}
            }
          else
            {
              UiUtil.showAlert(
                  context, " Download", "File is already Download ", null, true)
            }
        });
  }

  getPdfMagNews(Posts postData) {
    if (widget.PublishTag == BaseKey.Publish_Magzine) {
      getPdfMagzine(postData);
    } else if (widget.PublishTag == BaseKey.Publish_NewsPaper) {
      getPdfNews(postData);
    }
  }

  void getPdfNews(Posts postData) {
    HttpObj.instance
        .getClient()
        .getNewsPaperDetailDownloadPdf(postData.id!)
        .then((it) {
      response(it, postData);
    }).catchError((Object obj) {
      stopLoading();
      CommonException().showException(context, obj);
    });
  }

  void getPdfMagzine(Posts postData) {
    HttpObj.instance
        .getClient()
        .getMagazineDetailDownloadPdf(postData.id!)
        .then((it) {
      response(it, postData);
    }).catchError((Object obj) {
      stopLoading();
      CommonException().showException(context, obj);
    });
  }

  void exception() {
    UiUtil.showAlert(context, " Server ",
        "Something went wrong please try again ", null, true);
  }

  void response(DataPdfResponse it, Posts postData) {
    if (it.sTATUS == BaseKey.SUCCESS) {
      if (it.DATA!.file != null) {
        DataPdf dataPdf = it.DATA!;
        dataPdf.uId = postData.uId;
        dataPdf.req_id = postData.id;

        _downloadAndSavePhoto(dataPdf, postData);
        return;
      }
      stopLoading();
      UiUtil.showAlert(
          context, " ", "Something went wrong please try again ", null, true);
    } else {
      stopLoading();
      UiUtil.showAlert(
          context, " ", "Something went wrong please try again ", null, true);
    }
  }

  void _downloadAndSavePhoto(DataPdf dataPdf, Posts post) async {
    try {
      var url = Uri.parse(post.thumbnailImageLink!);
      var response = await http.get(url);
      if (response != null) {
        stopLoading();
        FileUtil().getDirectoryPath().then((path) {
          File file = File(
              path + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
          file.writeAsBytesSync(response.bodyBytes);
          if (file.path.isNotEmpty) {
            dataPdf.tempId = StringUtil.tempValue(post.id, widget.PublishTag);
            dataPdf.ImageUrl = file.path;
            dataPdf.type = post.type;
            dataPdf.grid_view = post.gridView == true ? 1 : 0;
            if (post.gridView!) {
              setCounter(context, dataPdf);
            } else {
              downloadPdf(FileUtil().getFilePath(path, dataPdf.file!), dataPdf);
            }
          }
        });
      } else {
        stopLoading();
        exception();
      }
    } catch (e) {
      stopLoading();
      exception();
      print(e.toString());
    }
  }

  Future downloadPdf(pdfFilePath, DataPdf dataPdf) async {
    ProgressDialog? progressDialog;
    try {
      progressDialog = ProgressDialog(context,
          dialogTransitionType: DialogTransitionType.Bubble,
          title: Text(BaseConstant.Downloading,
              style: FontUtil.style(
                FontSizeUtil.Large,
                SizeWeight.Regular,
                context,
              )));

      progressDialog.show();

      Dio dio = ApiClient.instance.getdio();
      print(pdfFilePath);

      await dio
          .download(dataPdf.file!, pdfFilePath,
              onReceiveProgress: (rec, total) {
            setState(() {
              progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
              progressDialog!.setMessage(Text("Dowloading $progress",
                  style: FontUtil.style(
                    FontSizeUtil.Medium,
                    SizeWeight.Regular,
                    context,
                  )));
            });
          })
          .then((value) => {
                progressDialog!.dismiss(),
                print("downloading successfully "),
                dataPdf.filepath = pdfFilePath,
                setCounter(context, dataPdf),
              })
          .catchError((Object obj) {
            CommonException().showException(context, obj);
          });
      progressDialog.dismiss();
    } catch (e) {
      if (progressDialog != null) {
        progressDialog.dismiss();
      }
      UiUtil.showAlert(
          context, BaseConstant.Server_error, "Invalid Pdf File ", null, true);
      print(e.toString());
    }
  }

  setCounter(BuildContext context, DataPdf dataPdf) {
    if (widget.PublishTag == BaseKey.Publish_Magzine) {
      markDownloadMagzineCounter(context, dataPdf);
    } else if (widget.PublishTag == BaseKey.Publish_NewsPaper) {
      markDownloadNewsPaperCounter(context, dataPdf);
    }
  }

  void markDownloadMagzineCounter(BuildContext context, DataPdf dataPdf) {
    HttpObj.instance
        .getClient()
        .getMagazineMarkAsDownload(dataPdf.req_id!)
        .then((it) {
      markResponse(it, dataPdf);
    }).catchError((Object obj) {
      CommonException().showException(context, obj);
    });
  }

  void markDownloadNewsPaperCounter(BuildContext context, DataPdf dataPdf) {
    HttpObj.instance
        .getClient()
        .getNewsPaperMarkAsDownload(dataPdf.req_id!)
        .then((it) {
      markResponse(it, dataPdf);
    }).catchError((Object obj) {
      CommonException().showException(context, obj);
    });
  }

  void markResponse(MarkDownloadResponse it, DataPdf dataPdf) {
    MarkDownloadResponse downloadResponse = it;
    print('data fetched successfully');
    print(it.DATA.toString());
    if (downloadResponse.sTATUS == BaseKey.SUCCESS) {
      refreshHistoryData(dataPdf);
      FileUtil().insertDatabase(context, dataPdf);
      return;
      UiUtil.showAlert(context, " Server ",
          "Something went wrong please try again ", null, true);
    } else {
      UiUtil.showAlert(context, "Server ",
          "Something went wrong please try again ", null, true);
    }
  }

  refreshHistoryData(DataPdf dataPdf) {
    if (widget.function != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.function!(dataPdf);
      });
    }
  }

  setGridView(Posts postData) {
    DataPdf dataPdf = new DataPdf();
    dataPdf.uId = postData.uId;
    dataPdf.req_id = postData.id;

    _downloadAndSavePhoto(dataPdf, postData);
  }
}
