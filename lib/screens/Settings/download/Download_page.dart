import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/common_widget/no_data_container.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/database/SQLiteDbProvider.dart';
import 'package:graphics_news/network/entity/historydownload/data_pdf.dart';
import 'package:graphics_news/network/entity/historydownload/download_history.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Settings/download/download_list_online.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';

import 'download_list_offline.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  List<DataPdf>? datapdf;
  String noDataImagePath = 'images/no_download.png';

  DownloadHistory? downloadHistory;
  bool? exception;
  bool? isInternet;
  bool? databaseCheck;

  @override
  void initState() {
    super.initState();
    getLocalDatabase(null, null);
    checkInternet();
  }

  getLocalDatabase(bool? isInternet, DownloadHistory? History) {
    SQLiteDbProvider.db.getAllPdfDownload().then((value) => {
          setState(() {
            internet(isInternet);
            downloadHistory = History;
            datapdf = value;
            //print("datapdf" + datapdf!.toString());
          }),
        });
  }

  checkInternet() {
    InternetUtil.check().then((value) => {
          if (value)
            {callHomeData(value)}
          else
            {
              if (datapdf == null)
                {getLocalDatabase(value, null)}
              else
                {
                  internet(value),
                }
            }
        });
  }

  internet(bool? value) {
    if (mounted) {
      setState(() {
        isInternet = value;
      });
    }
  }

  void callHomeData(bool? isInternet) {
    HttpObj.instance.getClient().downloadHistory().then((it) {
      if (mounted) {
        setState(() {
          if (datapdf == null) {
            getLocalDatabase(isInternet, it);
          } else {
            internet(isInternet);
            downloadHistory = it;
          }
        });
      }
    }).catchError((Object obj) {
      internet(isInternet);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget.appHeader(BaseConstant.MY_PURCHASE_HEADER, context),
      body: SafeArea(
        child: Container(child: getHistory()),
      ),
    );
  }

  getHistory() {
    if (isInternet == null) {
      return Center(child: LoadingIndicator());
    } else if (!isInternet! && (datapdf != null && datapdf!.length > 0)) {
      return offlineHistory();
    } else if (isInternet! && downloadHistory != null) {
      if (downloadHistory!.DATA != null) {
        return onlineHistory();
      }
      return HistoryNotFound();
    }
    /* else if(isInternet! && downloadHistory == null&& datapdf!=null){

    } */
    else {
      print("data");
      return HistoryNotFound();
    }
  }

  offlineHistory() {
    if (datapdf != null && datapdf!.length > 0) {
      return ListView(
        children: [
          DownloadListOffline(
            datapdf: datapdf,
          )
        ],
      );
    }
  }

  onlineHistory() {
    return ListView(
      children: [
        DownloadListOnline(
          onlineData: downloadHistory!.DATA,
          offlineData: datapdf,
        )
      ],
    );
  }

  HistoryNotFound() {
    return NoDataContainer(noDataImagePath, BaseConstant.no_download_title,
        BaseConstant.no_download_desc);
  }
}
