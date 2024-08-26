import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_overlay_loader.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_drawer.dart';
import 'package:graphics_news/common_widget/no_data_container.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/bookmark_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Home/paper/magazines/Magazine_details.dart';
import 'package:graphics_news/screens/Home/paper/newPaper/news_details.dart';

class Bookmarks extends StatefulWidget {
  static var currentIndex;

  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  BookMarkResponse? bookMarkResponse;
  bool? exception;

  dynamic mediaQueryData;

  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  String noDataImagePath = 'images/no_bookmark.png';

  @override
  void initState() {
    super.initState();
    getBookMarkList();
  }

  void getBookMarkList() {
    HttpObj.instance.getClient().getBookMarks().then((it) {
      if (mounted) {
        setState(() {
          bookMarkResponse = it;
          SplashScreen.bookMarkMagazines.clear();
          SplashScreen.bookMarkNewsPaper.clear();
          if (bookMarkResponse != null && bookMarkResponse!.DATA != null) {
            for (int i = 0; i < bookMarkResponse!.DATA!.length; i++) {
              if (bookMarkResponse!.DATA![i].bookmark_type == 'magazine') {
                SplashScreen.bookMarkMagazines
                    .add(bookMarkResponse!.DATA![i].id!);
              } else {
                SplashScreen.bookMarkNewsPaper
                    .add(bookMarkResponse!.DATA![i].id!);
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
    return CommonWidget(context).getObjWidget(bookMarkResponse, exception,
        myLayoutWidget(context, bookMarkResponse), retryCallback());
  }

  Widget myLayoutWidget(
      BuildContext context, BookMarkResponse? bookMarkResponse) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    if (bookMarkResponse != null)
                      (bookMarkResponse.DATA!.length > 0)
                          ? Expanded(
                              child: ListView(
                                children: [magazineGrid(bookMarkResponse.DATA)],
                              ),
                            )
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

  Widget magazineGrid(List<BookMarkData>? bookMarkData) {
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
          childAspectRatio: 0.69,
        ),
        itemCount: bookMarkData!.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => {openDetailPage(index)},
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(alignment: Alignment.center, children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: UiUtil.setImageNetwork(
                          bookMarkData[index].thumbnail_image,
                          double.infinity,
                          200.0)),
                  Positioned(
                    top: 0,
                    right: 5,
                    child: InkWell(
                      onTap: () {
                        bookmark(bookMarkData, index, context);
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
                    bookMarkData[index].title!,
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
                      bookMarkData[index].currency! +
                          BaseConstant.EMPTY_SPACE +
                          bookMarkData[index].price!,
                      style: FontUtil.style(FontSizeUtil.Medium,
                          SizeWeight.Regular, context, Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  openDetailPage(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                bookMarkResponse!.DATA![index].bookmark_type == 'magazine'
                    ? MagazineDetails(
                        magazineId: bookMarkResponse!.DATA![index].id!,
                        title: bookMarkResponse!.DATA![index].title,
                      )
                    : NewsDetails(
                        newsId: bookMarkResponse!.DATA![index].id!,
                        title: bookMarkResponse!.DATA![index].title!,
                      )));
  }

  void bookmark(
      List<BookMarkData>? bookMarkData, int index, BuildContext context) {
    CommonOverlayLoader.showLoader(context);
    var id = bookMarkData![index].id;
    var type = bookMarkData[index].bookmark_type;

    HttpObj.instance.getClient().setBookMark(id!, type!).then((it) {
      CommonOverlayLoader.hideLoader(context);
      if (it.sTATUS == BaseKey.SUCCESS) {
        print(it.MESSAGE);
        UiUtil.toastPrint(it.MESSAGE!);
        setState(() {
          getBookMarkList();
        });
      } else {
        UiUtil.toastPrint(BaseConstant.SOMETHING_WENT_WRONG);
      }
      // return it;
    }).catchError((Object obj) {
      CommonOverlayLoader.hideLoader(context);
      print('data fetched successfullyerror ');
      CommonException().showException(context, obj);
    });
  }
}
