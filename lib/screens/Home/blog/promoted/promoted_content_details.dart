// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/show_ads.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/common_widget/LifeCycleManager.dart';
import 'package:graphics_news/common_widget/SwipeTo.dart';
import 'package:graphics_news/common_widget/common_app_bar.dart';
import 'package:graphics_news/common_widget/common_deeplinking.dart';
import 'package:graphics_news/common_widget/common_timer.dart';
import 'package:graphics_news/common_widget/common_unfilled_btn.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/rest_path.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/constant/tts_state.dart';
import 'package:graphics_news/network/response/promoted_detail_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Home/blog/commonWidget/detail_image_widget.dart';
import 'package:graphics_news/screens/Home/blog/commonWidget/related_content_widget.dart';
import 'package:graphics_news/screens/subscription/all_plans_subscription.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../Utility/route.dart';

class PromotedContentDetails extends StatefulWidget {
  final int? promotedId;

  const PromotedContentDetails({Key? key, this.promotedId}) : super(key: key);

  @override
  _PromotedContentDetailsState createState() => _PromotedContentDetailsState();
}

class _PromotedContentDetailsState extends State<PromotedContentDetails> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var token;
  dynamic mediaQueryData;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  FlutterTts flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  bool get isIOS => Platform.isIOS;

  bool get isAndroid => Platform.isAndroid;
  bool playing = false;
  PromotedDetailResponse? promotedDetailResponse;
  bool? exception;
  List<String>? promotedids;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initTts();
    if (mounted) {
      CommonTimer.subscribeTime(update: update);
      if (widget.promotedId != null) getAllapi(id: widget.promotedId!);
    }
  }

  void update() {
    ShowAds.setFullAds(context, BaseKey.PROMOTED_CONTENT_DETAILS);
  }

  @override
  void dispose() {
    flutterTts.stop();
    CommonTimer.unsubscribeTime();
    super.dispose();
  }

  void clear() {
    setException(null);
    if (mounted)
      setState(() {
        promotedDetailResponse = null;
      });
  }

  getapi({int? id}) {
    clear();
    HttpObj.instance.getClient().getPromotedContentDetailPage(id!).then((it) {
      print(it.dATA!.promoted_ids);
      setState(() {
        setException(false);
        promotedDetailResponse = it;
      });
    }).catchError((Object obj) {
      setException(true);
      //  RouteMap.backReloadLogin(context, apiReload);
      RouteMap.commonExceptionBlog(context, obj, apiReload);
    });
  }

  getAllapi({int? id}) {
    HttpObj.instance.getClient().getPromotedContentDetailPage(id!).then((it) {
      print(it.dATA!.promoted_ids);
      promotedids = it.dATA!.promoted_ids;
      if (promotedids != null)
        promotedids!.remove(widget.promotedId?.toString());
      promotedids!.insert(0, widget.promotedId!.toString());
      print(promotedids);

      setState(() {
        setException(false);
        promotedDetailResponse = it;
      });
    }).catchError((Object obj) {
      setException(true);
      RouteMap.commonExceptionBlog(context, obj, apiReload);
      //  CommonException().exception(context, obj);
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
    print("sdf");
    VoidCallback voidcallback = () => {
          print("sdf"),
          setException(null),
          getapi(id: widget.promotedId)
          // api for logout
        };
    return voidcallback;
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return LifeCycleManager(
      child: WillPopScope(
        onWillPop: () => CommonDeepLinking.onBackPressed(
            SplashScreen.deeplinkingType, SplashScreen.deeplinkingId, context),
        child: Scaffold(
            key: scaffoldKey,
            appBar: CommonAppBar.getAppBarwithNext(context, () {
              next();
            }, () {
              previous();
            },
                promotedids == null
                    ? false
                    : !promotedids![selectedIndex]
                        .contains(widget.promotedId.toString())),
            body: _buildbody(context)),
      ),
      ttspeach: stopTTS,
    );
  }

  void previous() {
    if (selectedIndex != 0) {
      InternetUtil.check().then((value) => {
            if (value)
              {
                stopTTS(),
                selectedIndex = selectedIndex - 1,
                getapi(id: int.parse(promotedids![selectedIndex]))
              }
            else
              {InternetUtil.errorMsg(context)}
          });
    }
  }

  void next() {
    InternetUtil.check().then((value) => {
          if (value)
            {
              stopTTS(),
              selectedIndex = selectedIndex + 1,
              getapi(id: int.parse(promotedids![selectedIndex]))
            }
          else
            {InternetUtil.errorMsg(context)}
        });
  }

  _buildbody(BuildContext context) {
    return CommonWidget(context).getObjWidget(
        promotedDetailResponse,
        exception,
        _buildPromotedContentList(context, promotedDetailResponse),
        retryCallback());
  }

  getttsSetting() async {
    await flutterTts.setSharedInstance(true);
    await flutterTts
        .setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers
    ]);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.awaitSynthCompletion(true);
  }

  _buildPromotedContentList(
      BuildContext context, PromotedDetailResponse? promotedDetailResponse) {
    if (promotedDetailResponse == null) {
      return Container();
    }

    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SwipeTo(
                  iconOnLeftSwipe: Icons.swipe_rounded,
                  iconOnRightSwipe: Icons.swipe_rounded,
                  onRightSwipe: () {
                    previous();
                  },
                  onLeftSwipe: () {
                    next();
                  },
                  child: Column(
                    children: [
                      DetailImageWidget(
                        promotedContent:
                            promotedDetailResponse.dATA!.promotedContent,
                        type: "promoted_content",
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      titleContainer(promotedDetailResponse),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              textContainer(promotedDetailResponse),
                              SizedBox(
                                height: 24.0,
                              ),
                              if (promotedDetailResponse.dATA != null &&
                                  promotedDetailResponse.dATA!.promotedContent!
                                          .needsSubscription ==
                                      true)
                                purchaseButtonContainer(promotedDetailResponse),
                              ShowAds.setNativeAds(context,
                                  BaseKey.PROMOTED_CONTENT_DETAILS_MEDIUM),
                              if (promotedDetailResponse != null)
                                if (promotedDetailResponse
                                        .dATA!.related!.length >
                                    0)
                                  relatedData(promotedDetailResponse),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textContainer(PromotedDetailResponse promotedDetailResponse) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Container(
            child: Html(
              data: promotedDetailResponse.dATA!.promotedContent!.content!,
              /* style: {
                "body": Style(
                    fontSize:
                        FontSize(FontUtil.getFontSize(FontSizeUtil.Large)),
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.justify),
              },*/
            ),
          )
        ],
      ),
    );
  }

  initTts() {
    flutterTts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
    }
    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        playing = false;
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print(" iOS Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _speak(String newVoiceText) async {
    print(newVoiceText);
    playingstate(true);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (newVoiceText.isNotEmpty) {
      await flutterTts.awaitSpeakCompletion(true);
      // var result = await flutterTts.speak(newVoiceText);
      // var result = await flutterTts.speak(newVoiceText.substring(0, 2000));
      var result;
      var count = newVoiceText.length;
      var max = 2000;
      var loopCount = count ~/ max;
      print(count);
      print(max);
      print(loopCount);

      if (Platform.isAndroid) {
        for (var i = 0; i <= loopCount; i++) {
          print("loop");
          if (i != loopCount) {
            print("i != loopCount");
            result = await flutterTts
                .speak(newVoiceText.substring(i * max, (i + 1) * max));
            print(result);
          } else {
            var end = (count - ((i * max)) + (i * max));
            result =
                await flutterTts.speak(newVoiceText.substring(i * max, end));
            print(result);
          }
        }
      } else {
        await flutterTts.speak(newVoiceText);
      }
      if (result == 1)
        setState(
          () => {
            ttsState = TtsState.playing,
          },
        );
      print(ttsState);
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1)
      setState(() => {playing = false, ttsState = TtsState.stopped});
    playingstate(false);
  }

  void playingstate(bool stateplay) {
    setState(() {
      playing = stateplay;
    });
  }

  stopTTS() {
    if (mounted) {
      setState(() {
        playing = false;
      });
      flutterTts.stop();
    }
  }

  void shareOption() async {
    var id = widget.promotedId!;
    final Size size = MediaQuery.of(context).size;
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
        BaseConstant.SHARING_MSG +
            RestPath.BASE_URL2 +
            "getstory?t=popular_content&tid=$id",
        sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2));
  }

  relatedData(PromotedDetailResponse promotedDetailResponse) {
    return Column(
      children: [
        RelatedContentWidget(
          promotedDetailResponse: promotedDetailResponse,
          type: BaseKey.TYPE_POPULAR_CONTENT,
        ),
        SizedBox(
          height: 24.0,
        ),
      ],
    );
  }

  titleContainer(PromotedDetailResponse promotedDetailResponse) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promotedDetailResponse.dATA!.promotedContent!.title!,
                      style: FontUtil.style(13, SizeWeight.Bold, context),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      promotedDetailResponse
                              .dATA!.promotedContent!.blogCategory!.name! +
                          " | " +
                          promotedDetailResponse.dATA!.promotedContent!.date!,
                      style: FontUtil.style(12, SizeWeight.Regular, context),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: new IconButton(
                      iconSize: 25,
                      icon:
                          playing ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                      highlightColor: Colors.black26,
                      onPressed: () {
                        !playing
                            ? _speak(promotedDetailResponse
                                .dATA!.promotedContent!.content!
                                .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' '))
                            : _stop();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        shareOption();
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            backgroundColor: ModeTheme.blackOrGrey(context),
                            child: Icon(
                              Icons.share,
                              color: ModeTheme.getDefault(context),
                            ),
                          ),
                        ),
                      )),
                ],
              )
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Divider(color: Colors.grey),
          SizedBox(
            height: 2,
          ),
        ],
      ),
    );
  }

  purchaseButtonContainer(PromotedDetailResponse promotedDetailResponse) {
    return Column(
      children: [
        Text(
          "There's more to it. Buy subscription to continue.",
          textAlign: TextAlign.left,
          style: FontUtil.style(13, SizeWeight.Bold, context, Colors.red),
        ),
        SizedBox(
          height: 10.0,
        ),
        CommonUnFilledBtn(
          btnName: BaseConstant.PURCHASE_DOCUMENT,
          onTap: () {
            Route route = MaterialPageRoute(
                builder: (context) => AllPlansSubscription(
                      PageStack: BaseKey.PAGE_STACK_BLOG_Detail_Page,
                    ));
            Navigator.push(context, route).then(apiReload);
          },
        ),
        SizedBox(
          height: 24.0,
        ),
      ],
    );
  }

  FutureOr apiReload(dynamic value) {
    if (RouteMap.isLogin()) {
      print("hello");
      setException(null);
      getAllapi(id: widget.promotedId!);
    }
  }
}
