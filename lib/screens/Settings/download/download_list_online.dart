import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_download.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/historydownload/data_pdf.dart';
import 'package:graphics_news/network/entity/historydownload/download_history.dart';
import 'package:graphics_news/network/response/magazine_detail_pdf_response.dart';
import 'package:graphics_news/screens/Settings/download/download_util.dart';

/// Created by Amit Rawat on 12/17/2021.

class DownloadListOnline extends StatefulWidget {
  List<History>? onlineData;
  List<DataPdf>? offlineData;

  DownloadListOnline({Key? key, this.onlineData, this.offlineData})
      : super(key: key);

  @override
  _Download_list_online_State createState() => _Download_list_online_State();
}

class _Download_list_online_State extends State<DownloadListOnline> {
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        dataMerge();
      });
    }
  }

  dataMerge() {
    if (widget.onlineData != null && widget.offlineData != null) {
      for (History history in widget.onlineData!) {
        for (DataPdf dataPdf in widget.offlineData!) {
          if (history.u_id == dataPdf.uId) {
            if (dataPdf.filepath != null) {
              if (File(dataPdf.filepath!).existsSync()) {
                history.offlinePdfPath = dataPdf.filepath;
              }
            }

            break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return getOfflineData(widget.onlineData);
  }

  Widget getOfflineData(List<History>? datapdf) {
    if (datapdf == null) {
      return Container();
    }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: datapdf.length,
            itemBuilder: (context, index) => Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          datapdf[index].thumbnail_image != null
                              ? UiUtil.setImageNetwork(
                                  datapdf[index].thumbnail_image,
                                  DownloadUtil.width(context),
                                  DownloadUtil.height(context),border: true)
                              : Container(
                                  width: 100,
                                  height: 100,
                                  child: Icon(
                                    Icons.error,
                                    size: 30,
                                  ),
                                ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 35),
                                  child: Text(
                                    datapdf[index].title!,
                                    style: FontUtil.style(FontSizeUtil.Medium,
                                        SizeWeight.SemiBold, context),
                                  ),
                                ),
                                SizedBox(
                                  height: 13.0,
                                ),
                                readButton(datapdf[index]),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        thickness: 1.6,
                      )
                    ],
                  ),
                )));
  }

  Widget readButton(History history) {
    if (history.offlinePdfPath == null && history.grid_view == 0) {
      String type;
      if (history.type == BaseKey.Publish_Magzine) {
        type = BaseKey.Publish_Magzine;
      } else {
        type = BaseKey.Publish_NewsPaper;
      }
      Posts post = new Posts();
      post.id = history.id;
      post.uId = history.u_id;
      post.subscribed = true;
      post.thumbnailImageLink = history.thumbnail_image;
      post.gridView = history.grid_view == 0 ? false : true;
      return CommonDownload(
        post: post,
        PublishTag: type,
        function: downloadRefresh,
        btnName: BaseConstant.DOWNLOAD_DOCUMENT,
      );
    }
    DataPdf dataPdf = new DataPdf();
    dataPdf.grid_view = history.grid_view;
    dataPdf.type = history.type;
    dataPdf.filepath = history.offlinePdfPath;
    dataPdf.req_id = history.id;

    return UiUtil.readButton(dataPdf, context);
    /*   return CommonFilledBtn(
      btnName: BaseConstant.open_document,
      onTap: () {
        PdfOpen(history.offlinePdfPath);
      },
    );*/
  }

  downloadRefresh(DataPdf dataPdf) {
    if (mounted) {
      setState(() {
        if (widget.onlineData != null && widget.offlineData != null) {
          for (History history in widget.onlineData!) {
            if (history.u_id == dataPdf.uId) {
              history.offlinePdfPath = dataPdf.filepath;
              history.grid_view = dataPdf.grid_view;
              break;
            }
          }
        }
      });
    }
  }
}
