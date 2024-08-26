import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/show_ads.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/LifeCycleManager.dart';
import 'package:graphics_news/common_widget/common_timer.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/podcasts_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/podcast/podcast_play.dart';

class Podcastlisting extends StatefulWidget {
  @override
  _PodcastlistingState createState() => _PodcastlistingState();
}

class _PodcastlistingState extends State<Podcastlisting> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool playVideo = false;
  late String videoId;
  AudioPlayer audioPlayer = AudioPlayer();
  PodCastsResponse? responseData;
  bool? exception;

  bool isPlaying = false;
  int _page = BaseKey.PAGINATION_KEY; //next page
  int _Firstpage = BaseKey.PAGINATION_KEY;
  bool _hasNextPage = true; // There is next page or not
  bool _isFirstLoadRunning =
      false; // Used to display loading indicators when _firstLoad function is running
  bool _isLoadMoreRunning =
      false; // Used to display loading indicators when _loadMore function is running

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  dynamic mediaQueryData;
  int _selectedIndex = 0;

  @override
  void initState() {
    CommonTimer.subscribeTime(update: update);
    super.initState();
    getPodCastListing();
  }

  void update() {
    ShowAds.setFullAds(context, BaseKey.PODCAST_LISTING);
  }

  @override
  void dispose() {
    CommonTimer.unsubscribeTime();
    super.dispose();
  }

  void getPodCastListing() {
    HttpObj.instance.getClient().getPodcastsListing(_Firstpage).then((it) {
      setState(() {
        responseData = it;
        if (responseData != null && responseData?.dATA != null) {
          firstLoading(true);
        }
        setException(false);
      });
    }).catchError((Object obj) {
      setException(true);
      CommonException().exception(context, obj);
    });
  }

  void _loadMore() async {
    _page = _page + 1;
    loadMoreData(true);
    HttpObj.instance.getClient().getPodcastsListing(_page).then((it) {
      if (mounted) {
        setState(() {
          final List<PodCastsListing>? fetchedPosts = it.dATA?.data;
          if (fetchedPosts != null && fetchedPosts.length > 0) {
            setState(() {
              responseData?.dATA?.data?.addAll(fetchedPosts);
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

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return LifeCycleManager(
      child: Scaffold(
          key: scaffoldKey,
          appBar: HeaderWidget.appHeader(BaseConstant.PODCASTS, context),
          body: _buildPodCastListBody(context)),
      audioPlayerTxt: StopPlaying,
    );
  }

  _buildPodCastListBody(BuildContext context) {
    return CommonWidget(context).getObjWidget(responseData, exception,
        _buildPodCastList(context, responseData), retryCallback());
  }

  _buildPodCastList(BuildContext context, PodCastsResponse? responseData) {
    if (responseData == null) {
      return Container();
    }
    return SafeArea(
      child: Column(
        children: [
          Expanded(
              child: NotificationListener<ScrollNotification>(
            child: magazineGrid(responseData.dATA),
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

  VoidCallback retryCallback() {
    VoidCallback voidcallback = () => {setException(null), getPodCastListing()};
    return voidcallback;
  }

  Widget magazineGrid(PodCastsDATA? podCastsListing) {
    if (podCastsListing == null) {
      return Container();
    }
    if (podCastsListing.data == null) {
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
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10,
          childAspectRatio: 2.0,
        ),
        itemCount: podCastsListing.data!.length,
        itemBuilder: (context, index) => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Container(
            width: 162.0,
            //height: 62.0,
            child: GestureDetector(
              onTap: () {
                fireItemViewevent(podCastsListing.data![index].id!.toString(),
                    podCastsListing.data![index].title);

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PodCastPlay(
                          podcastsId: podCastsListing.data![index].id!,
                          podcastsImage:
                              podCastsListing.data![index].thumbnailImage!,
                          podcastFile:
                              podCastsListing.data![index].podcastFile!);
                    }).then((value) => {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 62.0,
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          child: UiUtil.setImageNetwork(
                              podCastsListing.data![index].thumbnailImage,
                              62.0,
                              62.0,
                              border: true),
                        ),
                        Positioned(
                          //bottom: 0.0,
                          child: Container(
                            height: 30.0,
                            child: Icon(
                              _selectedIndex == index && isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Expanded(
                    child: Container(
                      // width: 50.0,
                      child: Text(
                        podCastsListing.data![index].title!,
                        style: FontUtil.style(8, SizeWeight.SemiBold, context),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getAudio(PodCastsDATA podCastsDATA, int index) async {
    _onSelected(index);
    var audioUrl = podCastsDATA.data![index].podcastFile;
    if (isPlaying) {
      var res = await audioPlayer.pause();
      if (res == 1) {
        setState(() {
          isPlaying = false;
        });
      }
    } else {
      var res = await audioPlayer.play(audioUrl!);
      if (res == 1) {
        setState(() {
          isPlaying = true;
        });
      }
    }
  }

  StopPlaying() {
    if (mounted) {
      setState(() {
        isPlaying = false;
      });
      audioPlayer.stop();
    }
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
        "item_category": "Podcast"
      },
    );
  }
}
