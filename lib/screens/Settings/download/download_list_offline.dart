import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/historydownload/data_pdf.dart';

import 'download_util.dart';

/// Created by Amit Rawat on 12/17/2021.

class DownloadListOffline extends StatefulWidget {
  List<DataPdf>? datapdf;

  DownloadListOffline({Key? key, this.datapdf}) : super(key: key);

  @override
  _Download_list_offline_State createState() => _Download_list_offline_State();
}

class _Download_list_offline_State extends State<DownloadListOffline> {
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getOfflineData(widget.datapdf);
  }

  Widget getOfflineData(List<DataPdf>? datapdf) {
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
                          datapdf[index].ImageUrl != null &&
                                  File(datapdf[index].ImageUrl!).existsSync()
                              ? Image.file(
                                  File(datapdf[index].ImageUrl!),
                                  width: DownloadUtil.width(context),
                                  height: DownloadUtil.height(context),
                                )
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

  Widget readButton(DataPdf datapdf) {
    return UiUtil.readButton(datapdf, context);
  }

  buttonChanged(bool value) {
    if (mounted) {
      setState(() {
        isSwitched = value;
      });
    }
  }
}
