import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_overlay_loader.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/home_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Home/paper/commonWidget/mag_news_listing.dart';
import 'package:graphics_news/screens/Home/paper/magazines/Magazine_details.dart';

class SectionMagazinesContent extends StatefulWidget {
  List<Newspapers>? magazines;
  String dataKey;

  SectionMagazinesContent(
      {Key? key, required this.magazines, required this.dataKey})
      : super(key: key);

  @override
  State<SectionMagazinesContent> createState() =>
      _SectionMagazinesContentState();
}

class _SectionMagazinesContentState extends State<SectionMagazinesContent> {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  @override
  Widget build(BuildContext context) {
    if (widget.magazines == null || widget.magazines!.isEmpty) {
      return Container();
    }
    final mediaQueryData = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.only(left: 18.0),
      //  height: 280.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget.subHeader(BaseConstant.MAGAZINES, context, onTap: () {
            redirect(context);
          }),
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: SizedBox(
              height: widget.magazines!.length > 10 ? 410 : 190,
              child: GridView.builder(
                padding: EdgeInsets.only(right: 10),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.magazines!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.magazines!.length > 10 ? 2 : 1,
                  childAspectRatio: 1.90,
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
                            builder: (context) => MagazineDetails(
                                  magazineId: widget.magazines![index].id,
                                  title: widget.magazines![index].title!,
                                ))),
                    fireItemViewevent(widget.magazines![index].id.toString(),
                        widget.magazines![index].title!)
                  },
                  child: Container(
                    child: Wrap(
                      children: [
                        Container(
                          child: Stack(children: [
                            ClipRRect(
                              child: UiUtil.setImageNetwork(
                                  widget.magazines![index].coverImage,
                                  double.infinity,
                                  145.0,
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
                                        SplashScreen.bookMarkMagazines.contains(
                                                widget.magazines![index].id)
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
                        Container(
                          height: 5.0,
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            widget.magazines![index].title!,
                            style: FontUtil.style(FontSizeUtil.small,
                                SizeWeight.SemiBold, context),
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          height: 5.0,
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            widget.magazines![index].currency! +
                                BaseConstant.EMPTY_SPACE +
                                widget.magazines![index].price!,
                            style: FontUtil.style(
                              FontSizeUtil.small,
                              SizeWeight.Regular,
                              context,
                              Theme.of(context).brightness == Brightness.dark
                                  ? WidgetColors.renewButtonColor
                                  : WidgetColors.darkGreyColor,
                            ),
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // child: SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: List.generate(widget.magazines!.length, (index) {
            //       return GestureDetector(
            //         onTap: () => Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => MagazineDetails(
            //                       magazineId: widget.magazines![index].id,
            //                       title: widget.magazines![index].title!,
            //                     ))),
            //         child: Container(
            //           width: 140,
            //           // height: 220,
            //           child: Padding(
            //             padding: const EdgeInsets.only(right: 10.0),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Stack(children: [
            //                   ClipRRect(
            //                     borderRadius: BorderRadius.circular(5.0),
            //                     child: UiUtil.setImageNetwork(
            //                         widget.magazines![index].coverImage,
            //                         132.0,
            //                         158.0),
            //                   ),
            //                   Align(
            //                     alignment: Alignment.centerRight,
            //                     child: InkWell(
            //                       onTap: () {
            //                         bookmark(index, context);
            //                       },
            //                       child: Container(
            //                         padding:
            //                             EdgeInsets.only(right: 10, bottom: 10),
            //                         alignment: Alignment.centerRight,
            //                         width: 70,
            //                         child: Image(
            //                           width: 26,
            //                           height: 26,
            //                           image: AssetImage(
            //                             SplashScreen.bookMarkMagazines.contains(
            //                                     widget.magazines![index].id)
            //                                 ? 'images/bookmark.png'
            //                                 : 'images/bookmark_white.png',
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ]),
            //                 SizedBox(
            //                   height: 10.0,
            //                 ),
            //                 Container(
            //                   height: mediaQueryData.orientation ==
            //                               Orientation.landscape &&
            //                           data.size.shortestSide > 600
            //                       ? 38
            //                       : 58,
            //                   child: Text(
            //                     widget.magazines![index].title!,
            //                     style: FontUtil.style(
            //                         13, SizeWeight.Regular, context),
            //                     maxLines: 2,
            //                     softWrap: true,
            //                     overflow: TextOverflow.ellipsis,
            //                   ),
            //                 )
            //               ],
            //             ),
            //           ),
            //         ),
            //       );
            //     }),
            //   ),
            // ),
          )
        ],
      ),
    );
  }

  void bookmark(int? index, BuildContext context) {
    CommonOverlayLoader.showLoader(context);
    var id = widget.magazines![index!].id;
    var type = widget.magazines![index].type;

    HttpObj.instance.getClient().setBookMark(id!, type!).then((it) {
      CommonOverlayLoader.hideLoader(context);
      String msg = BaseConstant.SERVER_ERROR;
      if (it.sTATUS == BaseKey.SUCCESS) {
        print(it.MESSAGE);
        UiUtil.toastPrint(it.MESSAGE!);
        setState(() {
          if (SplashScreen.bookMarkMagazines
              .contains(widget.magazines![index].id)) {
            SplashScreen.bookMarkMagazines.remove(widget.magazines![index].id!);
          } else {
            SplashScreen.bookMarkMagazines.add(widget.magazines![index].id!);
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
            builder: (context) => MagNewsListing(BaseKey.Publish_Magzine)));
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
        "item_category": "Magzine"
      },
    );
  }
}
