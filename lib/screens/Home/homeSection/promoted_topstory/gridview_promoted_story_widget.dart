import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_overlay_loader.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/home_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Home/blog/promoted/promoted_content_details.dart';
import 'package:graphics_news/screens/Home/blog/topStory/top_stories_details.dart';

class GridViewPromotedStoryWidget extends StatefulWidget {
  List<PopularContents>? popularContents;
  String? type;

  GridViewPromotedStoryWidget({Key? key, this.popularContents, this.type})
      : super(key: key);

  @override
  State<GridViewPromotedStoryWidget> createState() =>
      _GridViewPromotedStoryWidgetState();
}

class _GridViewPromotedStoryWidgetState
    extends State<GridViewPromotedStoryWidget> {
  dynamic mediaQueryData;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    if (widget.popularContents == null) {
      return Container();
    } else if (widget.popularContents!.isEmpty) {
      return Container();
    }

    return Container(
        child: SizedBox(
      height: UiRatio.isPotrait(context)
          ? UiRatio.getHeight(340, 110)
          : UiRatio.getHeight(380, 100),

      /* UiUtil.getHeight(widget.popularContents!.length < 4 ? 200 : 350, 100),*/
      child: GridView.builder(
        padding: EdgeInsets.only(right: 10),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.popularContents!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.popularContents!.length > 2 ? 2 : 1,
          childAspectRatio: 0.9,
          crossAxisSpacing: 10.0,
          mainAxisSpacing:
              mediaQueryData.orientation == Orientation.portrait ? 10.0 : 10.0,
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            navigate(widget.type, widget.popularContents![index].id);
          },
          child: Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Stack(
                    children: [
                      ClipRRect(
                          // borderRadius: BorderRadius.only(
                          //     topRight: Radius.circular(8),
                          //     topLeft: Radius.circular(8)),
                          child: UiUtil.setImageNetwork(
                              widget.popularContents![index].contentImage!,
                              double.infinity,
                              UiRatio.isPotrait(context)
                                  ? UiRatio.getHeight(100, 50)
                                  : UiRatio.getHeight(120, 30),
                              border: true)),
                      Visibility(
                        visible: false,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              bookmark(widget.popularContents![index].id,
                                  widget.popularContents![index].type, context);
                              fireItemViewevent(
                                  widget.popularContents![index].id.toString(),
                                  widget.popularContents![index].type,
                                  widget.popularContents![index].title);
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 10, bottom: 10),
                              alignment: Alignment.centerRight,
                              width: 70,
                              child: Image(
                                width: 26,
                                height: 26,
                                image: AssetImage(
                                  widget.type == BaseKey.TYPE_TOP_STORY
                                      ? SplashScreen.bookMarkTopStories
                                              .contains(
                                          widget.popularContents![index].id,
                                        )
                                          ? 'images/bookmark.png'
                                          : 'images/bookmark_white.png'
                                      : SplashScreen.bookMarkPromotedContent
                                              .contains(
                                          widget.popularContents![index].id,
                                        )
                                          ? 'images/bookmark.png'
                                          : 'images/bookmark_white.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          widget.popularContents![index].blogCategory!.name!,
                          style: FontUtil.style(
                            FontSizeUtil.xsmall,
                            SizeWeight.SemiBold,
                            context,
                            Colors.red,
                          ),
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          widget.popularContents![index].title!,
                          style: FontUtil.style(FontSizeUtil.xsmall,
                              SizeWeight.SemiBold, context),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        /* Visibility(
                          visible: false,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                HomeCalanderIcon.home_calender,
                                color: Colors.grey,
                                size: 10.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Expanded(
                                child: Text(
                                  widget.popularContents![index].date!,
                                  style: FontUtil.style(
                                      FontSizeUtil.xsmall,
                                      SizeWeight.Regular,
                                      context,
                                      Colors.grey,
                                      1.6),
                                ),
                              )
                            ],
                          ),
                        )*/
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    ));
    // ResponsiveGridList(
    //     scroll: true,
    //     desiredItemWidth: UiUtil.getHeightGrid(context: context, height: 100),
    //     minSpacing: 5,
    //     children: widget.popularContents!.map((popularContent) {
    //       return GestureDetector(
    //         onTap: () {
    //           navigate(widget.type, popularContent.id);
    //         },
    //         child: Card(
    //           elevation: 2.0,
    //           child: Wrap(
    //             // mainAxisAlignment: MainAxisAlignment.start,
    //             // crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Container(
    //                 child: Stack(
    //                   children: [
    //                     ClipRRect(
    //                         borderRadius: BorderRadius.only(
    //                             topRight: Radius.circular(8),
    //                             topLeft: Radius.circular(8)),
    //                         child: UiUtil.setImageNetwork(
    //                             popularContent.contentImage!,
    //                             double.infinity,
    //                             UiUtil.isPotrait(context)
    //                                 ? UiUtil.getHeight(100, 50)
    //                                 : UiUtil.getHeight(120, 70),
    //                             border: true)),
    //                     Align(
    //                       alignment: Alignment.centerRight,
    //                       child: InkWell(
    //                         onTap: () {
    //                           bookmark(popularContent.id, popularContent.type,
    //                               context);
    //                         },
    //                         child: Container(
    //                           padding: EdgeInsets.only(right: 10, bottom: 10),
    //                           alignment: Alignment.centerRight,
    //                           width: 70,
    //                           child: Image(
    //                             width: 26,
    //                             height: 26,
    //                             image: AssetImage(
    //                               widget.type == BaseKey.TYPE_TOP_STORY
    //                                   ? SplashScreen.bookMarkTopStories
    //                                           .contains(
    //                                       popularContent.id,
    //                                     )
    //                                       ? 'images/bookmark.png'
    //                                       : 'images/bookmark_white.png'
    //                                   : SplashScreen.bookMarkPromotedContent
    //                                           .contains(
    //                                       popularContent.id,
    //                                     )
    //                                       ? 'images/bookmark.png'
    //                                       : 'images/bookmark_white.png',
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 10.0, top: 3.0),
    //                 child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       SizedBox(
    //                         height: 3.0,
    //                       ),
    //                       Text(
    //                         popularContent.blogCategory!.name!,
    //                         style: FontUtil.style(
    //                           FontSizeUtil.xsmall,
    //                           SizeWeight.SemiBold,
    //                           context,
    //                           Colors.red,
    //                         ),
    //                         maxLines: 1,
    //                         softWrap: true,
    //                         overflow: TextOverflow.ellipsis,
    //                       ),
    //                       SizedBox(
    //                         height: 3.0,
    //                       ),
    //                       Text(
    //                         popularContent.title!,
    //                         style: FontUtil.style(FontSizeUtil.xsmall,
    //                             SizeWeight.SemiBold, context),
    //                         overflow: TextOverflow.ellipsis,
    //                         maxLines: 1,
    //                         softWrap: true,
    //                       ),
    //                       SizedBox(
    //                         height: 3.0,
    //                       ),
    //                       Row(
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         mainAxisAlignment: MainAxisAlignment.start,
    //                         children: [
    //                           Icon(
    //                             HomeCalanderIcon.home_calender,
    //                             color: Colors.grey,
    //                             size: 10.0,
    //                           ),
    //                           SizedBox(
    //                             width: 5.0,
    //                           ),
    //                           Expanded(
    //                             child: Text(
    //                               popularContent.date!,
    //                               style: FontUtil.style(
    //                                   FontSizeUtil.xsmall,
    //                                   SizeWeight.Regular,
    //                                   context,
    //                                   Colors.grey,
    //                                   1.6),
    //                             ),
    //                           )
    //                         ],
    //                       )
    //                     ]),
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    //     }).toList());
  }

  navigate(String? type, int? id) {
    if (type == BaseKey.TYPE_TOP_STORY) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TopStoriesDetails(
                    id: id,
                  )));

      fireItemViewevent(id.toString(), type, "Top Stories");
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PromotedContentDetails(
                    promotedId: id,
                  )));
      fireItemViewevent(id.toString(), type, "Promoted Contents");
    }
  }

  void bookmark(int? id, String? type, BuildContext context) {
    CommonOverlayLoader.showLoader(context);

    HttpObj.instance.getClient().setBookMark(id!, type!).then((it) {
      CommonOverlayLoader.hideLoader(context);
      String msg = BaseConstant.SERVER_ERROR;
      if (it.sTATUS == BaseKey.SUCCESS) {
        print(it.MESSAGE);
        UiUtil.toastPrint(it.MESSAGE!);
        if (mounted) {
          setState(() {
            setdata(id, type);
          });
        }
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

  setdata(int? id, String? type) {
    if (type == BaseKey.TYPE_TOP_STORY) {
      if (SplashScreen.bookMarkTopStories.contains(id)) {
        SplashScreen.bookMarkTopStories.remove(id);
      } else {
        SplashScreen.bookMarkTopStories.add(id!);
      }
    } else {
      if (SplashScreen.bookMarkPromotedContent.contains(id)) {
        SplashScreen.bookMarkPromotedContent.remove(id);
      } else {
        SplashScreen.bookMarkPromotedContent.add(id!);
      }
    }
  }

  fireItemViewevent(String? id, String? name, String? itemCategory) async {
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
        "item_category": "Top Stories"
      },
    );
  }
}
