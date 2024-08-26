import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/show_ads.dart';
import 'package:graphics_news/Utility/size_util.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/LifeCycleManager.dart';
import 'package:graphics_news/common_widget/ads_screen.dart';
import 'package:graphics_news/common_widget/common_app_bar.dart';
import 'package:graphics_news/common_widget/common_deeplinking.dart';
import 'package:graphics_news/common_widget/common_drawer.dart';
import 'package:graphics_news/common_widget/common_set_event.dart';
import 'package:graphics_news/common_widget/common_timer.dart';
import 'package:graphics_news/common_widget/save_ads_data.dart';
import 'package:graphics_news/constant/GlobalVariable.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/rest_path.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/bookmark_response.dart';
import 'package:graphics_news/network/response/home_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Home/homeSection/gallery/gallery.dart';
import 'package:graphics_news/screens/Home/homeSection/image_slider.dart';
import 'package:graphics_news/screens/Home/homeSection/instagram/instagram.dart';
import 'package:graphics_news/screens/Home/homeSection/magazine.dart';
import 'package:graphics_news/screens/Home/homeSection/news.dart';
import 'package:graphics_news/screens/Home/homeSection/popular_category.dart';
import 'package:graphics_news/screens/Home/homeSection/promoted_topstory/promoted_content.dart';
import 'package:graphics_news/screens/Home/homeSection/promoted_topstory/top_story.dart';
import 'package:graphics_news/screens/Home/podcast/podcast_play.dart';
import 'package:graphics_news/screens/Home/videoPod/pod_cast_listing.dart';
import 'package:graphics_news/screens/Home/videoPod/video_detail.dart';
import 'package:graphics_news/screens/Home/videoPod/videos_listing.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double aspect_ratio = 1.53;
  var selected = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  static String fallbackUrl =
      RestPath.BASE_URL2 /*'https://gcgl.dci.in/public'*/;
  bool isPlaying = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  BookMarkResponse? bookMarkResponse;

  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  dynamic mediaQueryData;
  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  bool playVideo = false;
  late String videoId;
  HomeResponse? responseData;
  String adUnitIdValue = "";
  bool? exception;

  @override
  void initState() {
    isTablet(context);

    getNotification();

    callHomeData();
    GlobalVariable.HomepageLoad = true;
    super.initState();
    fireScreenViewevent();
  }

  getNotification() {
    if (GlobalVariable.HomepageLoad == null) {
      if (GlobalVariable.notification != null) {
        if (GlobalVariable.notification!) {
          if (GlobalVariable.notificationType != null) {
            RouteMap.notificationLinking(GlobalVariable.notificationType,
                GlobalVariable.notificationId, GlobalVariable.subscriptionData);
          }
        }
      }
    }
  }

  VoidCallback retryCallback() {
    VoidCallback voidcallback = () => {
          setException(null),
          callHomeData()
          // api for logout
        };
    return voidcallback;
  }

  void callHomeData() {
    HttpObj.instance.getClient().getHomePage().then((it) {
      if (mounted) {
        setState(() {
          responseData = it;
          setException(false);
          checkSubscription(responseData);

          print("testEvent");
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

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return LifeCycleManager(
        child: getBody(), audioPlayerTxt: StopPlaying, refresh: refreshPage);
  }

  refreshPage() {
    setState(() {});
  }

  getBody() {
    return Scaffold(
        appBar: CommonAppBar.getAppBar(
            context, () => scaffoldKey.currentState!.openDrawer()),
        key: scaffoldKey,
        drawer: CommonDrawer(),
        onDrawerChanged: (isDrawerOpen) {
          if (isDrawerOpen) {
          } else {
            setState(() {});
          }
        },
        body: buildHome(context));
  }

  buildHome(BuildContext context) {
    return CommonWidget(context).getObjWidget(responseData, exception,
        _buildHomePage(context, responseData), retryCallback());
  }

  _buildHomePage(BuildContext context, HomeResponse? homeResponse) {
    if (responseData == null) {
      return Container();
    }
    // CommonTimer.isTimer == true
    //     ? {print("home timer is true")}
    //     : {print("home timer is false")};
    HomeDATA homeDATA = homeResponse!.dATA!;
    return RefreshIndicator(
      onRefresh: () async {
        InternetUtil.check().then((value) => {
              if (value)
                {_refresh()}
              else
                {UiUtil.getSnack(context, BaseConstant.INTERNET_CONNECTION_MSG)}
            });
      },
      child: Stack(children: [
        Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
              // SectionTreadingNews(
              //   dataKey: '',
              //   homeDATA: homeDATA,
              // ),
              //static data
              SectionImageSlider(
                sliderData: homeDATA.slider,
                dataKey: '',
              ),
              getList(homeDATA),
              SizedBox(
                height: 24.0,
              ),
              if (homeDATA.instagramData!.length > 0) instagramSection(homeDATA)
            ]))),
            AdsScreen.anchoredBanner != null
                ? Visibility(
                    visible: AdsScreen.bannerAdVisibility,
                    child: Container(
                      width: AdsScreen.anchoredBanner!.size.width.toDouble(),
                      height: AdsScreen.anchoredBanner!.size.height.toDouble(),
                      child: AdWidget(ad: AdsScreen.anchoredBanner!),
                    ))
                : InkWell(
                    onTap: () {
                      openUrl(SaveAdsData.sharedInstance.bannerAdsUrl);
                    },
                    child: Visibility(
                        visible: AdsScreen.bannerAdVisibility,
                        child: AdsScreen.showCustomBannerAd(
                            context, SaveAdsData.sharedInstance.bannerAdValue)),
                  ),
          ],
        ),
      ]),
    );
  }

  Widget getList(HomeDATA homedata) {
    if (homedata == null) {
      return Container();
    }
    return new ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: homedata.positions!.length,
        itemBuilder: (BuildContext ctxt, int Index) {
          return new Container(
              child: getView(homedata.positions![Index].section.toString(),
                  homedata, context));
        });
  }

  Widget getView(String Tag, HomeDATA homedata, BuildContext context) {
    switch (Tag) {
      case BaseKey.KEY_GALLERY:
        return Container(
            margin: getTop(),
            child: SectionGallery(
                albums: homedata.albums, dataKey: BaseKey.KEY_GALLERY));

      // case BaseKey.KEY_PODCASTS:
      //   return podcastSection(homedata.podcasts!, BaseKey.KEY_PODCASTS);

      case BaseKey.KEY_VIDEOS:
        //  SectionVideos(videos: homedata.videos, dataKey: BaseKey.KEY_VIDEOS);//not working
        // return videoSection(homedata.videos!, BaseKey.KEY_VIDEOS);
        return Container(
            margin: getTop(), child: videoAndPodcastSection(homedata));

      case BaseKey.KEY_CATEGORIES: //popular categories
        return Container(
            margin: getTop(),
            child: SectionPopularCategory(
                categories: homedata.categories,
                dataKey: BaseKey.KEY_CATEGORIES));

      case BaseKey.KEY_UN_POPULAR_CATEGORIES: //unpopular categories
        return Container();

      case BaseKey.KEY_NEWSPAPER: //newspaper
        return Container(
            margin: getTop(),
            child: SectionNewsContent(
              newspapers: homedata.newspapers,
              dataKey: BaseKey.KEY_NEWSPAPER,
              aspect_ratio: aspect_ratio,
            ));

      case BaseKey.KEY_MAGAZINES: //magazines
        return Container(
            margin: getTop(),
            child: SectionMagazinesContent(
                magazines: homedata.magazines, dataKey: BaseKey.KEY_MAGAZINES));

      case BaseKey.KEY_PROMOTED_CONTENT: //popular contents
        return Container(
            margin: getTop(),
            child: SectionPromotedContent(
                popularContents: homedata.popularContents,
                dataKey: BaseKey.KEY_PROMOTED_CONTENT));

      case BaseKey.KEY_TOP_STORIES:
        return Container(
            margin: getTop(),
            child: SectionTopStories(
                topStories: homedata.topStories,
                dataKey: BaseKey.KEY_TOP_STORIES));

      // case BaseKey.KEY_TOPICS: //topics to follow
      //   return SectionTopics(
      //       topics: homedata.topics, dataKey: BaseKey.KEY_TOPICS);

      /* case BaseKey.KEY_ADS://for ads
        //TODO: not implemented yet please check @vandana
        return SectionAdsBanner(ads: homedata.ads, dataKey: BaseKey.KEY_ADS);*/
    }

    return Container();
  }

  EdgeInsets getTop() {
    return EdgeInsets.only(
      top: 20,
    );
  }

  Widget videoSection(List<Videos> videos, String tag) {
    if (videos.isEmpty) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(left: 18.0),
      height: 145.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(videos.length, (index) {
                    return Container(
                      height: 120.0,
                      width: 148.0,
                      child: GestureDetector(
                        onTap: () {
                          fireItemViewevent(videos[index].id.toString(),
                              videos[index].title, "Videos");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideoDetail(
                                        videoId: videos[index].id,
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
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
                                            videos[index].thumbnailImage,
                                            148.0,
                                            SizeUtil.getHeightInfinity(),
                                            border: true)),
                                    Positioned(
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
                                videos[index].title!,
                                style: FontUtil.style(FontSizeUtil.small,
                                    SizeWeight.SemiBold, context),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget podcastSection(List<Podcasts> podcasts, String tag) {
    if (podcasts.isEmpty) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(left: 18.0),
      height: 115.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(podcasts.length, (index) {
                    return Card(
                      child: Container(
                        width: 162.0,
                        child: GestureDetector(
                          onTap: () {
                            fireItemViewevent(podcasts[index].id.toString(),
                                podcasts[index].title, "Podcasts");
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>

                            //         PodCastPlay(
                            //             podcasts: podcasts, index: index)
                            //             ));
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PodCastPlay(
                                      podcastsId: podcasts[index].id!,
                                      podcastsImage:
                                          podcasts[index].thumbnailImage!,
                                      podcastFile:
                                          podcasts[index].podcastFile!);
                                }).then((value) => {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
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
                                              podcasts[index].thumbnailImage,
                                              62.0,
                                              62.0,
                                              border: true)),
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
                                    child: Text(
                                      podcasts[index].title!,
                                      style: FontUtil.style(FontSizeUtil.small,
                                          SizeWeight.Medium, context),
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
                    );
                  }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  StopPlaying() {
    if (mounted) {
      setState(() {
        isPlaying = false;
      });
      audioPlayer.stop();
    }
  }

  getAudio(int index, List<Podcasts>? podcasts) async {
    _onSelected(index);
    var audioUrl = podcasts![index].podcastFile;
    print(audioUrl);

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

  void checkSubscription(HomeResponse? responseData) {
    if (responseData != null) {
      if (responseData.dATA!.subscribe == false) {
        if (responseData.dATA!.ads!.isEnable == "1") {
          SaveAdsData.sharedInstance.saveData(responseData);
          CommonTimer.subscribeTime(update: update);
          // callAds(BaseKey.HOME_PAGE);
        } else {
          SaveAdsData.sharedInstance.clear();
        }
      } else {
        SaveAdsData.sharedInstance.clear();
      }

      if (SplashScreen.deeplinkingType != null) {
        CommonDeepLinking.redirectDeeplinking(
            SplashScreen.deeplinkingType, SplashScreen.deeplinkingId, context);
      }
    }
  }

  void update() {
    callAds(BaseKey.HOME_PAGE);
  }

  void callAds(String type) {
    print('callAds');
    // adUnitIdValue = ShowAds.setBannerAds(context, type);
    ShowAds.setBannerAds(context, type);
    // ShowAds.setFullAds(context, type);
  }

  @override
  void dispose() {
    CommonTimer.unsubscribeTime();
    super.dispose();
  }

  void redirectToPodCastListing(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Podcastlisting()));
  }

  void redirectToVideoListing(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Videoslisting()));
  }

  openUrl(String url) async {
    try {
      bool launched = await launch(url, forceSafariVC: false);
      CommonSetEvent.setEvent("ads", "banner");
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }

  Widget videoAndPodcastSection(HomeDATA homedata) {
    if (homedata.videos!.isEmpty && homedata.podcasts!.isEmpty) {
      return Container();
    }
    List<bool> _selections = List.generate(2, (_) => false);

    return Container(
      child: Column(
        children: [
          Container(
            child: ToggleButtons(
              children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).size.width - 40) / 2,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: selected == 0
                      ? WidgetColors.primaryColor
                      : WidgetColors.iconBackground,
                  child: Center(
                      child: Text(
                    BaseConstant.VIDEOS,
                    style: FontUtil.style(
                        FontSizeUtil.XXLarge,
                        SizeWeight.SemiBold,
                        context,
                        selected == 0 ? Colors.white : Colors.black),
                  )),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width - 40) / 2,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: selected == 1
                      ? WidgetColors.primaryColor
                      : WidgetColors.iconBackground,
                  child: Center(
                      child: Text(
                    BaseConstant.PODCASTS,
                    style: FontUtil.style(
                        FontSizeUtil.XXLarge,
                        SizeWeight.SemiBold,
                        context,
                        selected == 1 ? Colors.white : Colors.black),
                  )),
                )
              ],
              isSelected: _selections,
              borderRadius: BorderRadius.circular(5),
              onPressed: (int index) {
                setState(() {
                  selected = index;
                  _selections[index] = !_selections[index];
                });
              },
            ),
          ),
          selected == 0
              ? videoSection(homedata.videos!, BaseKey.KEY_VIDEOS)
              : podcastSection(homedata.podcasts!, BaseKey.KEY_PODCASTS),
          InkWell(
            onTap: () {
              selected == 0
                  ? redirectToVideoListing(context)
                  : redirectToPodCastListing(context);
            },
            child: Container(
              padding: const EdgeInsets.only(right: 18.0, top: 10),
              child: Container(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "VIEW ALL",
                      style: FontUtil.style(
                          FontSizeUtil.Large,
                          SizeWeight.SemiBold,
                          context,
                          WidgetColors.primaryColor),
                    )
                    //  Icon(
                    //   Icons.east,
                    //   size: 25,
                    //   color: WidgetColors.primaryColor,
                    // )
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    callHomeData();
  }

  instagramSection(HomeDATA homeDATA) {
    return Column(
      children: [
        SectionInstagram(
          homeDATA: homeDATA,
          dataKey: '',
        ),
        SizedBox(
          height: 24.0,
        ),
      ],
    );
  }

  fireScreenViewevent() async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
    await FirebaseAnalytics.instance.logEvent(
      name: "screen_view",
      parameters: {
        "screen_name": "HomeScreen",
      },
    );
  }

  fireItemViewevent(String? id, String? name, String type) async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
    print(
        "newspaper id is" + " " + id.toString() + "name is " + name.toString());
    await FirebaseAnalytics.instance.logEvent(
      name: "view_item",
      parameters: {"item_id": id, "item_name": name, "item_category": type},
    );
  }

  static Future<bool> isTablet(BuildContext context) async {
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
  }
}
