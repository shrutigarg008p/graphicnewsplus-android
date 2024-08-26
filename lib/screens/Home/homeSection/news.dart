import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_overlay_loader.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/network/response/home_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Home/paper/newPaper/news_details.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../paper/commonWidget/mag_news_listing.dart';

class SectionNewsContent extends StatefulWidget {
  List<Newspapers>? newspapers;
  String dataKey;
  double aspect_ratio = 1.53;

  SectionNewsContent(
      {Key? key,
      required this.newspapers,
      required this.dataKey,
      required this.aspect_ratio})
      : super(key: key);

  @override
  State<SectionNewsContent> createState() => _SectionNewsContentState();
}

class _SectionNewsContentState extends State<SectionNewsContent> {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  dynamic mediaQueryData;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    //isTablet(context);

    if (widget.newspapers == null || widget.newspapers!.isEmpty) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.only(left: 18.0),
      //height: 300.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget.subHeader(BaseConstant.NEWSPAPERS, context, onTap: () {
            redirect(context);
          }),
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: SizedBox(
              height: widget.newspapers!.length > 2 ? 330 : 160,
              child: GridView.builder(
                padding: EdgeInsets.only(right: 10),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.newspapers!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.newspapers!.length > 2 ? 2 : 1,
                  childAspectRatio: widget.aspect_ratio, //1.53, //1.03
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing:
                      mediaQueryData.orientation == Orientation.portrait
                          ? 10.0
                          : 15.0,
                ),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewsDetails(
                                  newsId: widget.newspapers![index].id,
                                  title: widget.newspapers![index].title,
                                ))),
                    fireItemViewevent(widget.newspapers![index].id.toString(),
                        widget.newspapers![index].title)
                  },
                  child: Container(
                    child: Wrap(
                      children: [
                        Container(
                          child: Stack(children: [
                            ClipRRect(
                              child: UiUtil.setImageNetwork(
                                  widget.newspapers![index].coverImage,
                                  double.infinity,
                                  160.0,
                                  border: true),
                            ),
                            Visibility(
                              visible: false,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    bookmark(index, context);
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(right: 10, bottom: 10),
                                    alignment: Alignment.centerRight,
                                    width: 70,
                                    child: Image(
                                      width: 26,
                                      height: 26,
                                      image: AssetImage(
                                        SplashScreen.bookMarkNewsPaper.contains(
                                                widget.newspapers![index].id)
                                            ? 'images/bookmark.png'
                                            : 'images/bookmark_white.png',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void bookmark(int? index, BuildContext context) {
    CommonOverlayLoader.showLoader(context);
    var id = widget.newspapers![index!].id;
    var type = widget.newspapers![index].type;

    HttpObj.instance.getClient().setBookMark(id!, type!).then((it) {
      CommonOverlayLoader.hideLoader(context);
      String msg = BaseConstant.SERVER_ERROR;
      if (it.sTATUS == BaseKey.SUCCESS) {
        print(it.MESSAGE);
        UiUtil.toastPrint(it.MESSAGE!);
        setState(() {
          if (SplashScreen.bookMarkNewsPaper
              .contains(widget.newspapers![index].id)) {
            SplashScreen.bookMarkNewsPaper
                .remove(widget.newspapers![index].id!);
          } else {
            SplashScreen.bookMarkNewsPaper.add(widget.newspapers![index].id!);
          }
        });
      } else {
        UiUtil.toastPrint(BaseConstant.SOMETHING_WENT_WRONG);
      }
      // return it;
    }).catchError((Object obj) {
      CommonOverlayLoader.hideLoader(context);
      print(obj);
      print('data fetched successfullyerror ');
      CommonException().showException(context, obj);
    });
  }

  void redirect(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MagNewsListing(BaseKey.Publish_NewsPaper)));
  }

  fireItemViewevent(String? id, String? name) async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
    print(
        "newspaper id is" + " " + id.toString() + "name is " + name.toString());
    await FirebaseAnalytics.instance.logEvent(
      name: "view_item",
      parameters: {
        "item_id": id,
        "item_name": name,
        "item_category": "Newspaper"
      },
    );
  }

  /* static Future<bool> isTablet(BuildContext context) async {
    //https://pub.dev/packages/device_info_plus/install
    bool isTab = false;
    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.model?.toLowerCase() == "ipad") {
        isTab = true;
        aspect_ratio = 1.03;

      } else {
        isTab = false;
        aspect_ratio = 1.53;
      }
      return isTab;
    } else {
      var shortestSide = MediaQuery.of(context).size.shortestSide;
      if (shortestSide > 600) {
        isTab = true;
        aspect_ratio = 1.03;
      } else {
        isTab = false;
         aspect_ratio = 1.53;
      }
      return isTab;
    }
  }*/
}
