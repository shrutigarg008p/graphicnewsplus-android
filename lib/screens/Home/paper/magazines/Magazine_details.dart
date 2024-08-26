import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_overlay_loader.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/route.dart';
import 'package:graphics_news/Utility/show_ads.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_deeplinking.dart';
import 'package:graphics_news/common_widget/common_download.dart';
import 'package:graphics_news/common_widget/common_filled_btn.dart';
import 'package:graphics_news/common_widget/common_set_event.dart';
import 'package:graphics_news/common_widget/common_timer.dart';
import 'package:graphics_news/common_widget/subtitle_header.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/database/SQLiteDbProvider.dart';
import 'package:graphics_news/network/entity/historydownload/data_pdf.dart';
import 'package:graphics_news/network/response/magazine_detail_pdf_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Home/gridView/common_grid_layout.dart';
import 'package:graphics_news/screens/Home/paper/paper_utility.dart';
import 'package:graphics_news/screens/Home/pdfWebview/pdf_view.dart';
import 'package:graphics_news/screens/Home/pdfWebview/web_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../constant/rest_path.dart';
import 'package:graphics_news/Authutil/shared_manager.dart';
import 'dart:math';

class MagazineDetails extends StatefulWidget {
  final int? magazineId;
  final String? title;

  const MagazineDetails({Key? key, this.magazineId, this.title})
      : super(key: key);

  @override
  _MagazineDetailsState createState() => _MagazineDetailsState();
}

class _MagazineDetailsState extends State<MagazineDetails> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  dynamic mediaQueryData;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  MagazineDetailPdfResponse? magazineDetailResponse;
  bool? exception;
  DataPdf? datapdf;
  int? tempId;
  bool subscription = false;
  bool gridView = false;
  bool? automatic_download;

  @override
  void initState() {
    super.initState();
    if (RouteMap.isLogin()) {
      getLocalDatabase();
    }

    CommonTimer.subscribeTime(update: update);
    getapi(backReloadApi: true); //getapi();
    fireScreenViewevent();
  }

  void update() {
    ShowAds.setFullAds(context, BaseKey.MAGAZINE_DETAILS);
  }

  @override
  void dispose() {
    CommonTimer.unsubscribeTime();
    super.dispose();
  }

  getLocalDatabase() {
    tempId = StringUtil.tempValue(widget.magazineId, BaseKey.Publish_Magzine);
    SQLiteDbProvider.db.getItemById(tempId!).then((value) => {
          setState(() {
            datapdf = value;
            print(datapdf);
          }),
        });
  }

  getapi({bool? backReloadApi}) {
    Random random = new Random();
    int randomNumber = random.nextInt(1000);
    HttpObj.instance
        .getClient()
        .getMagazineDetailPage(
            widget.magazineId!, randomNumber.toString() /*BaseKey.base64_NO*/)
        .then((it) {
      setState(() {
        setException(false);
        magazineDetailResponse = it;
        if (it.dATA != null) {
          if (it.dATA!.post != null) {
            if (it.dATA!.post!.subscribed != null) {
              subscription = it.dATA!.post!.subscribed!;
              gridView = it.dATA!.post!.gridView!;
              SharedManager.instance.setWebUrl(it.dATA?.weburl.toString());
              automaticDownload(backReloadApi, subscription);
            }
          }
        }
      });
    }).catchError((Object obj) {
      setException(true);
      CommonException().exception(context, obj);
    });
  }

  automaticDownload(bool? backReloadApi, bool? Subscription) {
    if (backReloadApi != null && backReloadApi) {
      if (Subscription != null && Subscription) {
        automatic_download = true;
      }
    }
  }

  VoidCallback reloadApi({bool? backReloadApi}) {
    VoidCallback voidcallback = () => {
          setException(null),
          if (mounted)
            {
              setState(() {
                magazineDetailResponse = null;
              })
            },

          getapi(backReloadApi: backReloadApi)
          // api for logout
        };
    return voidcallback;
  }

  VoidCallback retryCallback() {
    VoidCallback voidcallback = () => {
          setException(null),
          getapi()
          // api for logout
        };
    return voidcallback;
  }

  setException(bool? value) {
    if (mounted) {
      setState(() {
        exception = value;
      });
    }
  }

  _buildMagazineList(BuildContext context) {
    return CommonWidget(context).getObjWidget(magazineDetailResponse, exception,
        getbody(context, magazineDetailResponse), retryCallback());
  }

  getbody(
      BuildContext context, MagazineDetailPdfResponse? magazineDetailResponse) {
    if (magazineDetailResponse == null) {
      return Container();
    }
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          magazineCard(magazineDetailResponse),
                          SizedBox(
                            height: 18.0,
                          ),
                          textContainer(magazineDetailResponse),
                          SizedBox(
                            height: 26.0,
                          ),
                          Column(
                            children: [checkUid(context)],
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          ShowAds.setNativeAds(
                              context, BaseKey.MAGAZINE_DETAILS_MEDIUM),
                          if (magazineDetailResponse != null)
                            if (magazineDetailResponse.dATA!.related!.length >
                                0)
                              relatedData(magazineDetailResponse),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkUid(BuildContext context) {
    return Column(
      children: <Widget>[
        if (datapdf != null && (datapdf!.tempId! == tempId!)) ...[
          UiUtil.readButton(datapdf, context)
        ] else ...[
          CommonFilledBtn(
            btnName: "Preview",
            onTap: () async {
              fireMagzinePreviewEvent(
                  widget.magazineId.toString(), widget.title, "magazine");
              CommonSetEvent.setEvent("reading", "magazine",
                  id: widget.magazineId);
              if (magazineDetailResponse!.dATA!.pdf!.fileType == "pdf") {
                _pdfViewerKey.currentState?.openBookmarkView();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PdfPage(
                              url: magazineDetailResponse!.dATA!.pdf!.file,
                            )));
              } else if (magazineDetailResponse!.dATA!.post!.gridView == true) {
                print("hello");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommonGridLayout(
                            id: widget.magazineId,
                            type: magazineDetailResponse!.dATA!.post!.type)));
              } else {
                UiUtil.toastPrint(BaseConstant.PDF_FILE_TYPE_NOT_FOUND_);
              }
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          CommonDownload(
            post: magazineDetailResponse!.dATA!.post!,
            PublishTag: BaseKey.Publish_Magzine,
            function: downloadRefresh,
            refreshApiData: reloadApi(backReloadApi: true),
            retryCallBack: reloadApi(backReloadApi: false),
            btnName: StringUtil.getDownloadBtnName(
                magazineDetailResponse!.dATA!.post!.subscribed),
            automaticDownload: automatic_download,
            disableAutoDownload: disabledAutoDownload,
          ),
        ]
      ],
    );
  }

  disabledAutoDownload(bool? autoDownload) {
    if (mounted) {
      setState(() {
        automatic_download = autoDownload;
      });
    }
  }

  downloadRefresh(DataPdf? dataPdfData) {
    if (mounted) {
      setState(() {
        datapdf = dataPdfData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () => CommonDeepLinking.onBackPressed(
          SplashScreen.deeplinkingType, SplashScreen.deeplinkingId, context),
      child: Scaffold(
          floatingActionButton: subscription
              ? !gridView
                  ? FloatingActionButton(
                      backgroundColor: WidgetColors.primaryColor,
                      child: Text(
                        "flip",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        flipClick();
                      },
                    )
                  : Container()
              : Container(),
          key: scaffoldKey,
          appBar: HeaderWidget.appHeader(BaseConstant.APPNAME, context),
          body: _buildMagazineList(context)),
    );
  }

  void flipClick() {
    if (magazineDetailResponse == null ||
        magazineDetailResponse!.dATA!.flipData == null) {
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewContainer(magazineDetailResponse!
                  .dATA!.flipData
                  .toString()
                  .replaceAll("\n", " "))));
    }
  }

  Widget magazineCard(MagazineDetailPdfResponse magazineDetailResponse) {
    return Container(
      height: UiRatio.getAspectHeight(context, 300),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: AspectRatio(
                aspectRatio: UiRatio.getAspectRatio(context, 300),
                child: Stack(
                  children: [
                    UiUtil.setImageNetwork2(
                        magazineDetailResponse.dATA!.post!.coverImageLink,
                        double.infinity,
                        double.infinity,
                        border: false),
                    PaperUtility.setDetailPageImage(
                        magazineDetailResponse.dATA!.post!.coverImageLink),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          bookmark(magazineDetailResponse.dATA!.post!.id,
                              magazineDetailResponse.dATA!.post!.type, context);
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          alignment: Alignment.topRight,
                          height: 40,
                          width: 80,
                          child: Image(
                            width: 26,
                            height: 26,
                            image: AssetImage(
                              SplashScreen.bookMarkMagazines.contains(
                                      magazineDetailResponse.dATA!.post!.id)
                                  ? 'images/bookmark.png'
                                  : 'images/bookmark_white.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textContainer(MagazineDetailPdfResponse magazineDetailResponse) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            magazineDetailResponse.dATA!.post!.title!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: FontUtil.style(
                                FontSizeUtil.Large, SizeWeight.Bold, context),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  magazineDetailResponse
                                      .dATA!.post!.publication!.name!,
                                  style: FontUtil.style(FontSizeUtil.Medium,
                                      SizeWeight.Regular, context),
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text("|"),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  magazineDetailResponse
                                      .dATA!.post!.publishedDate!,
                                  style: FontUtil.style(FontSizeUtil.Medium,
                                      SizeWeight.Regular, context),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          checkSubscribed(magazineDetailResponse.dATA!.post)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () {
                        shareOption();
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CircleAvatar(
                          backgroundColor: ModeTheme.blackOrGrey(context),
                          child: Icon(
                            Icons.share,
                            color: ModeTheme.getDefault(context),
                          ),
                        ),
                      ))),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(
            thickness: 1.0,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            magazineDetailResponse.dATA!.post!.shortDescription!,
            style: FontUtil.style(
                FontSizeUtil.Medium, SizeWeight.Regular, context),
          ),
        ),
      ],
    );
  }

  checkSubscribed(Posts? posts) {
    if (posts!.subscribed!) {
      return Text(
        BaseConstant.Subscribed,
        style: FontUtil.style(FontSizeUtil.Large, SizeWeight.SemiBold, context,
            WidgetColors.primaryColor),
      );
    }
    return Text(
      posts.currency! + BaseConstant.EMPTY_SPACE + posts.price!,
      style: FontUtil.style(FontSizeUtil.Large, SizeWeight.Regular, context),
    );
  }

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  Widget relatedNewsSection(MagazineDetailPdfResponse magazineDetailResponse) {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      height: 250.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubTitleHeader(
            title: 'Related Magazines',
          ),
          SizedBox(
            height: 15.0,
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      magazineDetailResponse.dATA!.related!.length, (index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MagazineDetails(
                                    magazineId: magazineDetailResponse
                                        .dATA!.related![index].id,
                                    title: magazineDetailResponse
                                        .dATA!.related![index].title,
                                  ))),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                                child: UiUtil.setImageNetwork(
                                    magazineDetailResponse
                                        .dATA!.related![index].coverImage,
                                    132.0,
                                    158.0,
                                    border: true)),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              magazineDetailResponse
                                  .dATA!.related![index].title!,
                              style: FontUtil.style(FontSizeUtil.Medium,
                                  SizeWeight.Regular, context),
                            )
                          ],
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

  // void dispose() {
  //   super.dispose();
  //   AdsScreen.interstitialAd?.dispose();
  // }

  void shareOption() async {
    var id = widget.magazineId!;
    final Size size = MediaQuery.of(context).size;

    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
        BaseConstant.SHARING_MSG +
            RestPath.BASE_URL2 +
            "getstory?t=magazines&tid=$id",
        sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2));
  }

  void bookmark(int? id, String? type, BuildContext context) {
    CommonOverlayLoader.showLoader(context);

    HttpObj.instance.getClient().setBookMark(id!, type!).then((it) {
      CommonOverlayLoader.hideLoader(context);
      String msg = BaseConstant.SERVER_ERROR;
      if (it.sTATUS == BaseKey.SUCCESS) {
        print(it.MESSAGE);
        UiUtil.toastPrint(it.MESSAGE!);
        setState(() {
          if (SplashScreen.bookMarkMagazines.contains(id)) {
            SplashScreen.bookMarkMagazines.remove(id);
          } else {
            SplashScreen.bookMarkMagazines.add(id);
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

  relatedData(MagazineDetailPdfResponse magazineDetailResponse) {
    return Column(
      children: [
        relatedNewsSection(magazineDetailResponse),
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
        "screen_name": "MagzineDetailsScreen",
      },
    );
  }

  fireMagzinePreviewEvent(String? id, String? name, String type) async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
    print(
        "newspaper id is" + " " + id.toString() + "name is " + name.toString());
    await FirebaseAnalytics.instance.logEvent(
      name: "open_preview",
      parameters: {"item_id": id, "item_name": name, "item_category": type},
    );
  }
}
