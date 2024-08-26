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
import 'package:graphics_news/network/response/promoted_listing_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Home/blog/promoted/promoted_content_details.dart';
import 'package:graphics_news/screens/Home/blog/topStory/top_stories_details.dart';
import 'package:responsive_grid/responsive_grid.dart';

class GridViewPromotedStoryListingWidget extends StatefulWidget {
  List<PromotedDATA>? popularContents;

  GridViewPromotedStoryListingWidget({Key? key, this.popularContents})
      : super(key: key);

  @override
  State<GridViewPromotedStoryListingWidget> createState() =>
      _GridViewPromotedStoryListingWidgetState();
}

class _GridViewPromotedStoryListingWidgetState
    extends State<GridViewPromotedStoryListingWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.popularContents == null) {
      return Container();
    } else if (widget.popularContents!.isEmpty) {
      return Container();
    }

    return ResponsiveGridList(
        desiredItemWidth: UiRatio.isPotrait(context)
            ? UiRatio.getHeight(150, 100)
            : UiRatio.getHeight(150, 100),
        minSpacing: 5,
        children: widget.popularContents!.map((popularContent) {
          return GestureDetector(
            onTap: () {
              navigate(popularContent.type, popularContent.id);

              fireItemViewevent(popularContent.id.toString(),
                  popularContent.title, popularContent.type);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              elevation: 2.0,
              child: Wrap(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        ClipRRect(
                            // borderRadius: BorderRadius.only(
                            //     topRight: Radius.circular(8),
                            //     topLeft: Radius.circular(8)),
                            child: UiUtil.setImageNetwork(
                                popularContent.contentImage!,
                                double.infinity,
                                UiRatio.isPotrait(context)
                                    ? UiRatio.getHeight(150, 50)
                                    : UiRatio.getHeight(150, 70),
                                border: true)),
                        Visibility(
                          visible: false,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                bookmark(popularContent.id, popularContent.type,
                                    context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(right: 10, bottom: 10),
                                alignment: Alignment.centerRight,
                                width: 70,
                                child: Image(
                                  width: 26,
                                  height: 26,
                                  image: AssetImage(
                                    popularContent.type ==
                                            BaseKey.TYPE_TOP_STORY
                                        ? SplashScreen.bookMarkTopStories
                                                .contains(
                                            popularContent.id,
                                          )
                                            ? 'images/bookmark.png'
                                            : 'images/bookmark_white.png'
                                        : SplashScreen.bookMarkPromotedContent
                                                .contains(
                                            popularContent.id,
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
                    padding: const EdgeInsets.only(left: 10.0, top: 3.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            popularContent.blogCategory!.name!,
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
                          Container(
                            height:
                                FontUtil.getFontSize(FontSizeUtil.xsmall) * 2.5,
                            child: Text(
                              popularContent.title!,
                              style: FontUtil.style(FontSizeUtil.xsmall,
                                  SizeWeight.SemiBold, context),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: true,
                            ),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          /* Row(
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
                                  popularContent.date!,
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
                          SizedBox(
                            height: 3.0,
                          ),*/
                        ]),
                  )
                ],
              ),
            ),
          );
        }).toList());
  }

  navigate(String? type, int? id) {
    if (type == BaseKey.TYPE_TOP_STORY) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TopStoriesDetails(
                    id: id,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PromotedContentDetails(
                    promotedId: id,
                  )));
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

  fireItemViewevent(String? id, String? name, String? Type) async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
    print(
        "newspaper id is" + " " + id.toString() + "name is " + name.toString());
    await FirebaseAnalytics.instance.logEvent(
      name: "view_item",
      parameters: {"item_id": id, "item_name": name, "item_category": Type},
    );
  }
}
