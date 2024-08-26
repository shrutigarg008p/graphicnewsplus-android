import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/show_ads.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_timer.dart';
import 'package:graphics_news/common_widget/magazine_list_item.dart';
import 'package:graphics_news/common_widget/sub_header.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/topics_detail_response.dart';
import 'package:graphics_news/network/services/http_client.dart';

class TopicFollowDetails extends StatefulWidget {
  final int? topicId;
  final String? topicName;

  const TopicFollowDetails({Key? key, this.topicId, this.topicName})
      : super(key: key);

  @override
  _TopicFollowDetailsState createState() => _TopicFollowDetailsState();
}

class _TopicFollowDetailsState extends State<TopicFollowDetails> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  dynamic mediaQueryData;
  int activeIndex = 0;
  bool isMagazine = true;
  bool isNewsPaper = false;
  List settingsTile = ['Magazines', 'NewsPapers'];
  bool? exception;
  TopicsDetailResponse? topicsDetailResponse;

  @override
  void initState() {
    super.initState();
    CommonTimer.subscribeTime(update: update);
    getapi();
  }

  void update() {
    ShowAds.setFullAds(context, BaseKey.TOPIC_FOLLOW_DETAILS);
  }

  @override
  void dispose() {
    CommonTimer.unsubscribeTime();
    super.dispose();
  }

  getapi() {
    HttpObj.instance
        .getClient()
        .getTopicsDetailPage(widget.topicId!)
        .then((it) {
      setState(() {
        setException(false);
        topicsDetailResponse = it;
      });
    }).catchError((Object obj) {
      setException(true);
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
    VoidCallback voidcallback = () => {setException(null), getapi()};
    return voidcallback;
  }

  _buildNewsList(BuildContext context) {
    return CommonWidget(context).getObjWidget(topicsDetailResponse, exception,
        _buildTopicList(context, topicsDetailResponse), retryCallback());
  }

  _buildTopicList(
      BuildContext context, TopicsDetailResponse? topicsDetailResponse) {
    if (topicsDetailResponse == null) {
      return Container();
    }
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            settingsListTile(),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 26.0,
                          ),
                          if (isMagazine)
                            SubHeader(title: BaseConstant.MAGAZINE_HEADER),
                          if (isMagazine)
                            SizedBox(
                              height: 16.0,
                            ),
                          if (isMagazine) magazineGrid(topicsDetailResponse),
                          if (isNewsPaper)
                            SubHeader(title: BaseConstant.NEWSPAPER_HEADER),
                          if (isNewsPaper)
                            SizedBox(
                              height: 16.0,
                            ),
                          if (isNewsPaper) newsPaperGrid(topicsDetailResponse),
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

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        key: scaffoldKey,
        appBar: HeaderWidget.appHeader("${widget.topicName}", context),
        body: _buildNewsList(context));
  }

  Widget settingsListTile() {
    return Container(
      margin: EdgeInsets.only(left: 17.0),
      height: 48.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
              settingsTile.length,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        switch (index) {
                          case 0:
                            isMagazine = true;
                            isNewsPaper = false;
                            break;
                          case 1:
                            isMagazine = false;
                            isNewsPaper = true;
                            break;
                        }
                        activeIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        height: 44.0,
                        width: MediaQuery.of(context).size.width * 0.42,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: activeIndex == index
                              ? WidgetColors.primaryColor
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Text(
                            settingsTile[index],
                            textAlign: TextAlign.center,
                            style: FontUtil.style(
                                13,
                                SizeWeight.Regular,
                                context,
                                activeIndex == index
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  )),
        ),
      ),
    );
  }

  Widget newsPaperGrid(TopicsDetailResponse topicsDetailResponse) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: UiUtil.getDefaultDelegate(context),
        itemCount: topicsDetailResponse.dATA!.newspapers!.length,
        itemBuilder: (context, index) => MagazineListItem(
          title: topicsDetailResponse.dATA!.newspapers![index].title!,
          img: topicsDetailResponse.dATA!.newspapers![index].coverImage!,
          price: StringUtil.getPrice(
              topicsDetailResponse.dATA!.newspapers![index].currency,
              topicsDetailResponse.dATA!.newspapers![index].price),
          id: topicsDetailResponse.dATA!.newspapers![index].id!,
          type: BaseKey.Publish_NewsPaper,
        ),
      ),
    );
  }

  Widget magazineGrid(TopicsDetailResponse topicsDetailResponse) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: UiUtil.getDefaultDelegate(context),
        itemCount: topicsDetailResponse.dATA!.magazines!.length,
        itemBuilder: (context, index) => MagazineListItem(
          title: topicsDetailResponse.dATA!.magazines![index].title!,
          img: topicsDetailResponse.dATA!.magazines![index].coverImage!,
          price: StringUtil.getPrice(
              topicsDetailResponse.dATA!.magazines![index].currency,
              topicsDetailResponse.dATA!.magazines![index].price),
          id: topicsDetailResponse.dATA!.magazines![index].id!,
          type: BaseKey.Publish_Magzine,
        ),
      ),
    );
  }
}
