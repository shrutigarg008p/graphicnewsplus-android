import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/show_ads.dart';
import 'package:graphics_news/Utility/size_util.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_timer.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/videolisting/video_res_list.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/videoPod/video_detail.dart';

class Videoslisting extends StatefulWidget {
  @override
  _VideoslistingState createState() => _VideoslistingState();
}

class _VideoslistingState extends State<Videoslisting> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool playVideo = false;
  late String videoId;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  dynamic mediaQueryData;
  VideoResponseList? videoResponseList;
  bool? exception;
  int _page = BaseKey.PAGINATION_KEY; //next page
  int _Firstpage = BaseKey.PAGINATION_KEY;
  bool _hasNextPage = true; // There is next page or not
  bool _isFirstLoadRunning =
      false; // Used to display loading indicators when _firstLoad function is running
  bool _isLoadMoreRunning =
      false; // Used to display loading indicators when _loadMore function is running

  @override
  void initState() {
    super.initState();
    CommonTimer.subscribeTime(update: update);
    getapi();
  }

  void update() {
    ShowAds.setFullAds(context, BaseKey.VIDEOS_LISTING);
  }

  @override
  void dispose() {
    CommonTimer.unsubscribeTime();
    super.dispose();
  }

  getapi() {
    HttpObj.instance.getClient().getVideosListing(_Firstpage).then((it) {
      setState(() {
        setException(false);
        videoResponseList = it;
        if (videoResponseList != null && videoResponseList?.DATA != null) {
          firstLoading(true);
        }
      });
    }).catchError((Object obj) {
      setException(true);
      CommonException().exception(context, obj);
    });
  }

  void _loadMore() async {
    _page = _page + 1;
    loadMoreData(true);
    HttpObj.instance.getClient().getVideosListing(_page).then((it) {
      if (mounted) {
        setState(() {
          final List<Video>? fetchedPosts = it.DATA?.data;
          if (fetchedPosts != null && fetchedPosts.length > 0) {
            setState(() {
              videoResponseList?.DATA?.data?.addAll(fetchedPosts);
            });
          } else {
            // This means there is no more data
            // and therefore, we will not send another GET request
            setState(() {
              _hasNextPage = false;
            });
          }
          loadMoreData(false);
        });
      }
    }).catchError((Object obj) {
      loadMoreData(false);
    });
  }

  firstLoading(bool value) {
    if (mounted) {
      setState(() {
        _isFirstLoadRunning = value;
      });
    }
  }

  loadMoreData(bool value) {
    if (mounted) {
      setState(() {
        _isLoadMoreRunning = value;
      });
    }
  }

  setException(bool? value) {
    if (mounted) {
      setState(() {
        exception = value;
      });
    }
  }

  VoidCallback retryCallback() {
    VoidCallback voidcallback = () => {setException(null), getapi()};
    return voidcallback;
  }

  _buildVideosList(BuildContext context, VideoResponseList? videoResponseList) {
    if (videoResponseList == null) {
      return Container();
    }
    return SafeArea(
      child: Column(
        children: [
          Expanded(
              child: NotificationListener<ScrollNotification>(
            child: videosGrid(videoResponseList),
            onNotification: (ScrollNotification scrollInfo) {
              if (_isFirstLoadRunning == true &&
                  _isLoadMoreRunning == false &&
                  _hasNextPage == true &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _loadMore();
              }
              return false;
            },
          )),
          if (_isLoadMoreRunning == true) UiUtil.loadMoreData(),
          if (_hasNextPage == false) UiUtil.nothingToLoad(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        key: scaffoldKey,
        appBar: HeaderWidget.appHeader(BaseConstant.VIDEOS, context),
        body: _buildBody(context));
  }

  _buildBody(BuildContext context) {
    return CommonWidget(context).getObjWidget(videoResponseList, exception,
        _buildVideosList(context, videoResponseList), retryCallback());
  }

  Widget videosGrid(VideoResponseList? videoResponseList) {
    if (videoResponseList?.DATA == null) {
      return Container();
    }
    if (videoResponseList?.DATA?.data == null) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: mediaQueryData.orientation == Orientation.landscape
              ? 4
              : data.size.shortestSide > 600 &&
                      mediaQueryData.orientation == Orientation.portrait
                  ? 4
                  : 2,
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15,
          childAspectRatio: 1.5,
        ),
        itemCount: videoResponseList?.DATA!.data!.length,
        itemBuilder: (context, index) => Container(
          height: 120.0,
          width: 148.0,
          child: GestureDetector(
            onTap: () {
              fireItemViewevent(
                  videoResponseList?.DATA!.data![index].id.toString(),
                  videoResponseList?.DATA!.data![index].title);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VideoDetail(
                            videoId: videoResponseList?.DATA!.data![index].id,
                          )));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                          child: UiUtil.setImageNetwork(
                              videoResponseList
                                  ?.DATA!.data![index].thumbnail_image,
                              148.0,
                              SizeUtil.getHeightInfinity(),
                              border: true)),
                      Positioned(
                        //bottom: 0.0,
                        child: Container(
                            height: 30.0,
                            child: new Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  StringUtil.getValue(
                      videoResponseList?.DATA!.data![index].title),
                  style: FontUtil.style(
                      FontSizeUtil.Medium, SizeWeight.Medium, context),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  fireItemViewevent(String? id, String? name) async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
    print(
        "newspaper id is" + " " + id.toString() + "name is " + name.toString());
    await FirebaseAnalytics.instance.logEvent(
      name: "view_item",
      parameters: {"item_id": id, "item_name": name, "item_category": "Videos"},
    );
  }
}
