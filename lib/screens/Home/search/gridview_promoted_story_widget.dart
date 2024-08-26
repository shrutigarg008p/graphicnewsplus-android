import 'package:flutter/material.dart';
import 'package:graphics_news/Assets/home_calander_icon_icons.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_overlay_loader.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/sub_header.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/search_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Home/blog/promoted/promoted_content_details.dart';
import 'package:graphics_news/screens/Home/blog/topStory/top_stories_details.dart';

class GridPromotedStorySearchWidget extends StatefulWidget {
  List<PopularContent>? popularContents;
  String? type;

  GridPromotedStorySearchWidget({Key? key, this.popularContents, this.type})
      : super(key: key);

  @override
  State<GridPromotedStorySearchWidget> createState() =>
      _GridPromotedStorySearchWidgetState();
}

class _GridPromotedStorySearchWidgetState
    extends State<GridPromotedStorySearchWidget> {
  dynamic mediaQueryData;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    if (widget.popularContents == null) {
      return Container();
    } else if (widget.popularContents!.isEmpty) {
      return Container();
    } else if (widget.popularContents!.length == 0) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.only(left: 18.0, top: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubHeader(
              isPadding: true,
              title: widget.type == BaseKey.TYPE_POPULAR_CONTENT
                  ? BaseConstant.PROMOTED_CONTENT
                  : BaseConstant.TOP_STORIES),
          SizedBox(
            height: 16.0,
          ),
          Container(
              child: SizedBox(
            height: UiRatio.isPotrait(context)
                ? UiRatio.getHeight(165, 55)
                : UiRatio.getHeight(185, 55),

            /* UiUtil.getHeight(widget.popularContents!.length < 4 ? 200 : 350, 100),*/
            child: GridView.builder(
              padding: EdgeInsets.only(right: 10),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.popularContents!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 0.9,
                crossAxisSpacing: 5.0,
                mainAxisSpacing:
                    mediaQueryData.orientation == Orientation.portrait
                        ? 5.0
                        : 5.0,
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
                                    widget
                                        .popularContents![index].contentImage!,
                                    double.infinity,
                                    UiRatio.isPotrait(context)
                                        ? UiRatio.getHeight(100, 50)
                                        : UiRatio.getHeight(120, 30),
                                    border: true)),
                            /* Visibility(
                              visible: false,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    bookmark(
                                        widget.popularContents![index].id,
                                        widget.popularContents![index].type,
                                        context);
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
                                        widget.type == BaseKey.TYPE_TOP_STORY
                                            ? SplashScreen.bookMarkTopStories
                                                    .contains(
                                                widget
                                                    .popularContents![index].id,
                                              )
                                                ? 'images/bookmark.png'
                                                : 'images/bookmark_white.png'
                                            : SplashScreen
                                                    .bookMarkPromotedContent
                                                    .contains(
                                                widget
                                                    .popularContents![index].id,
                                              )
                                                ? 'images/bookmark.png'
                                                : 'images/bookmark_white.png',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),*/
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
                                widget.popularContents![index].blogCategory!
                                    .name!,
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
                              Visibility(
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
                              )
                            ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    );
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
}
