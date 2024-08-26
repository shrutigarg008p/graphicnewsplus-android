import 'package:flutter/material.dart';
import 'package:graphics_news/Assets/home_calander_icon_icons.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_overlay_loader.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_drawer.dart';
import 'package:graphics_news/common_widget/no_data_container.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/bookmark_new_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Home/blog/promoted/promoted_content_details.dart';
import 'package:graphics_news/screens/Home/blog/topStory/top_stories_details.dart';
import 'package:graphics_news/screens/Home/paper/magazines/Magazine_details.dart';
import 'package:graphics_news/screens/Home/paper/newPaper/news_details.dart';

class BookmarksNew extends StatefulWidget {
  static var currentIndex;

  @override
  _BookmarksNewState createState() => _BookmarksNewState();
}

class _BookmarksNewState extends State<BookmarksNew> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  BookMarkNewResponse? bookMarkNewResponse;
  bool? exception;
  var isSelected;
  dynamic mediaQueryData;

  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  String noDataImagePath = 'images/no_bookmark.png';

  @override
  void initState() {
    super.initState();
    isSelected = 0;
    getBookMarkList();
  }

  void getBookMarkList() {
    HttpObj.instance.getClient().getBookMarksNew().then((it) {
      if (mounted) {
        setState(() {
          bookMarkNewResponse = it;
          SplashScreen.bookMarkMagazines.clear();
          SplashScreen.bookMarkNewsPaper.clear();
          SplashScreen.bookMarkTopStories.clear();
          SplashScreen.bookMarkPromotedContent.clear();
          if (bookMarkNewResponse != null &&
              bookMarkNewResponse!.DATA != null) {
            for (int i = 0; i < bookMarkNewResponse!.DATA!.length; i++) {
              print("key" + bookMarkNewResponse!.DATA![i].key!);
              if (bookMarkNewResponse!.DATA![i].key! == 'magazine') {
                for (var item in bookMarkNewResponse!.DATA![i].data!) {
                  SplashScreen.bookMarkMagazines.add(item.id!);
                }
              } else if (bookMarkNewResponse!.DATA![i].key == 'newspaper') {
                for (var item in bookMarkNewResponse!.DATA![i].data!) {
                  SplashScreen.bookMarkNewsPaper.add(item.id!);
                }
              } else if (bookMarkNewResponse!.DATA![i].key ==
                  'popular_content') {
                for (var item in bookMarkNewResponse!.DATA![i].data!) {
                  SplashScreen.bookMarkPromotedContent.add(item.id!);
                }
              } else {
                for (var item in bookMarkNewResponse!.DATA![i].data!) {
                  SplashScreen.bookMarkTopStories.add(item.id!);
                }
              }
            }
          }

          setException(false);
        });
      }
    }).catchError((Object obj) {
      if (mounted) {
        setException(true);
      }

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

  VoidCallback retryCallback() {
    VoidCallback voidcallback = () => {setException(null), getBookMarkList()};
    return voidcallback;
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: HeaderWidget.appHeader(BaseConstant.BOOKMARK_HEADER, context),
      drawer: CommonDrawer(),
      body: buildBookmark(context),
    );
  }

  buildBookmark(BuildContext context) {
    return CommonWidget(context).getObjWidget(bookMarkNewResponse, exception,
        myLayoutWidget(context, bookMarkNewResponse), retryCallback());
  }

  Widget myLayoutWidget(
      BuildContext context, BookMarkNewResponse? bookMarkNewResponse) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    if (bookMarkNewResponse != null &&
                        bookMarkNewResponse.DATA!.length > 0)
                      bookMarkTitleList(bookMarkNewResponse.DATA!),
                    if (bookMarkNewResponse != null)
                      (bookMarkNewResponse.DATA!.length > 0)
                          ? bookMarkContainer(bookMarkNewResponse.DATA)
                          : Expanded(
                              child: NoDataContainer(
                                noDataImagePath,
                                BaseConstant.NO_BOOKMARKS_TITLE,
                                BaseConstant.NO_BOOKMARKS_DESC,
                              ),
                            )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bookMarkContainer(List<BookMarkNewData>? bookMarkNewData) {
    return Expanded(
      child: ListView(
        children: [
          gridView(bookMarkNewData!),
        ],
      ),
    );
  }

  Widget gridView(List<BookMarkNewData> bookMarkNewData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: mediaQueryData.orientation == Orientation.landscape
              ? 4
              : data.size.shortestSide > 600 &&
                      mediaQueryData.orientation == Orientation.portrait
                  ? 4
                  : 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing:
              mediaQueryData.orientation == Orientation.portrait ? 20.0 : 35.0,
          childAspectRatio:
              bookMarkNewData[isSelected].rss_content == true ? 0.90 : 0.69,
        ),
        itemCount: bookMarkNewData[isSelected].data!.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => {openDetailPage(bookMarkNewData, index)},
          child: Container(
              child: bookMarkNewData[isSelected].rss_content == false
                  ? MagAndNewsLayout(bookMarkNewData, index)
                  : TopAndPopularLayout(bookMarkNewData, index)),
        ),
      ),
    );
  }

  openDetailPage(List<BookMarkNewData> bookMarkNewData, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => bookMarkNewData[isSelected].key == 'magazine'
                ? MagazineDetails(
                    magazineId: bookMarkNewData[isSelected].data![index].id!,
                    title: bookMarkNewData[isSelected].data![index].title,
                  )
                : bookMarkNewData[isSelected].key == 'newspaper'
                    ? NewsDetails(
                        newsId: bookMarkNewData[isSelected].data![index].id!,
                        title: bookMarkNewData[isSelected].data![index].title!,
                      )
                    : bookMarkNewData[isSelected].key == 'popular_content'
                        ? PromotedContentDetails(
                            promotedId:
                                bookMarkNewData[isSelected].data![index].id!,
                          )
                        : TopStoriesDetails(
                            id: bookMarkNewData[isSelected].data![index].id!,
                          )));
  }

  void bookmark(List<BookMarkNewSubData>? bookMarkNewSubData, int index,
      BuildContext context) {
    CommonOverlayLoader.showLoader(context);

    var id = bookMarkNewSubData![index].id;
    var type = bookMarkNewSubData[index].bookmark_type;

    HttpObj.instance.getClient().setBookMark(id!, type!).then((it) {
      CommonOverlayLoader.hideLoader(context);
      if (it.sTATUS == BaseKey.SUCCESS) {
        print(it.MESSAGE);
        UiUtil.toastPrint(it.MESSAGE!);
        setState(() {
          int isPreviousSelected = isSelected;
          isSelected = bookMarkNewSubData.length < 2
              ? isPreviousSelected > 0
                  ? isSelected - 1
                  : 0
              : isSelected;
          getBookMarkList();
        });
      } else {
        UiUtil.toastPrint(BaseConstant.SOMETHING_WENT_WRONG);
      }
      // return it;
    }).catchError((Object obj) {
      CommonOverlayLoader.hideLoader(context);
      CommonException().showException(context, obj);
    });
  }

  Widget bookMarkTitleList(List<BookMarkNewData>? bookMarkNewData) {
    return Container(
      margin: EdgeInsets.only(left: 17.0, top: 5),
      height: 38.0,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                bookMarkNewData!.length,
                (index) => GestureDetector(
                  onTap: () => {
                    setState(() {
                      isSelected = index;
                    }),
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                        height: 36.0,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: ModeTheme.blackOrGrey(context),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(bookMarkNewData[index].name!,
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: isSelected == index
                                    ? WidgetColors.primaryColor
                                    : null))),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  MagAndNewsLayout(List<BookMarkNewData> bookMarkNewData, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(alignment: Alignment.center, children: <Widget>[
          ClipRRect(
              child: UiUtil.setImageNetwork(
                  bookMarkNewData[isSelected].data![index].cover_image,
                  double.infinity,
                  190.0,
                  border: true)),
          Positioned(
            top: 0,
            right: 5,
            child: InkWell(
              onTap: () {
                bookmark(bookMarkNewData[isSelected].data, index, context);
              },
              child: Container(
                padding: EdgeInsets.only(right: 10, bottom: 10),
                alignment: Alignment.centerRight,
                width: 70,
                child: Image(
                  width: 26,
                  height: 26,
                  image: AssetImage('images/bookmark.png'),
                ),
              ),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            bookMarkNewData[isSelected].data![index].title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FontUtil.style(
                FontSizeUtil.Medium, SizeWeight.SemiBold, context),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              bookMarkNewData[isSelected].data![index].currency! +
                  BaseConstant.EMPTY_SPACE +
                  bookMarkNewData[isSelected].data![index].price!,
              style: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular,
                  context, Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  TopAndPopularLayout(List<BookMarkNewData> bookMarkNewData, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      elevation: 2.0,
      child: Container(
        child: Wrap(
          children: [
            Stack(
              children: [
                AspectRatio(
                    aspectRatio: 220 / 125,
                    child: UiUtil.setImageNetwork(
                        bookMarkNewData[isSelected].data![index].content_image,
                        null,
                        null,
                        border: true)),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      bookmark(
                          bookMarkNewData[isSelected].data, index, context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 10, bottom: 10),
                      alignment: Alignment.centerRight,
                      width: 70,
                      child: Image(
                        width: 26,
                        height: 26,
                        image: AssetImage('images/bookmark.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 3.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      bookMarkNewData[isSelected]
                          .data![index]
                          .blog_category![0]
                          .name!,
                      style: FontUtil.style(
                        10,
                        SizeWeight.Regular,
                        context,
                        WidgetColors.primaryColor,
                      ),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      bookMarkNewData[isSelected].data![index].title!,
                      style: FontUtil.style(10, SizeWeight.SemiBold, context),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Row(
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
                            bookMarkNewData[isSelected].data![index].date!,
                            style: FontUtil.style(10, SizeWeight.Regular,
                                context, Colors.grey, 1.6),
                          ),
                        )
                      ],
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
