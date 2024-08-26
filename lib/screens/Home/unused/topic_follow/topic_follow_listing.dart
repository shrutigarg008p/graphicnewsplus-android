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
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/topics_listing_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/paper/newPaper/news_details.dart';

class TopicListing extends StatefulWidget {
  @override
  _TopicListingState createState() => _TopicListingState();
}

class _TopicListingState extends State<TopicListing> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  dynamic mediaQueryData;
  int activeIndex = 0;
  bool isMagazine = true;
  bool isNewsPaper = false;
  List settingsTile = ['Magazines', 'NewsPapers'];
  TopicsListingResponse? topicsListingResponse;
  bool? exception;

  @override
  void initState() {
    super.initState();
    CommonTimer.subscribeTime(update: update);
    getapi();
  }

  void update() {
    ShowAds.setFullAds(context, BaseKey.TOPIC_LISTING);
  }

  @override
  void dispose() {
    CommonTimer.unsubscribeTime();
    super.dispose();
  }

  getapi() {
    HttpObj.instance.getClient().getTopicsListingPage().then((it) {
      setState(() {
        setException(false);
        topicsListingResponse = it;
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

  _buildTopicList(
      BuildContext context, TopicsListingResponse? topicsListingResponse) {
    if (topicsListingResponse == null) {
      return Container();
    }
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: settingsListTile(),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 15.0,
                          ),
                          if (isMagazine) magazineGrid(topicsListingResponse),
                          if (isNewsPaper) newsPaperGrid(topicsListingResponse),
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
        appBar: HeaderWidget.appHeader(BaseConstant.TOPIC_TO_FOLLOW, context),
        body: _buildNewsList(context));
  }

  _buildNewsList(BuildContext context) {
    return CommonWidget(context).getObjWidget(topicsListingResponse, exception,
        _buildTopicList(context, topicsListingResponse), retryCallback());
  }

  Widget settingsListTile() {
    return Container(
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
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Container(
                        height: 44.0,
                        width:
                            mediaQueryData.orientation == Orientation.landscape
                                ? MediaQuery.of(context).size.width * 0.47
                                : data.size.shortestSide > 600 &&
                                        mediaQueryData.orientation ==
                                            Orientation.portrait
                                    ? MediaQuery.of(context).size.width * 0.48
                                    : MediaQuery.of(context).size.width * 0.45,
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

  Widget newsPaperGrid(TopicsListingResponse topicListingResponse) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: UiUtil.getDefaultDelegate(context),
        itemCount: topicListingResponse.dATA!.newspapers!.length,
        itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewsDetails(
                          newsId:
                              topicListingResponse.dATA!.newspapers![index].id,
                          title: topicListingResponse
                              .dATA!.newspapers![index].title!,
                        ))),
            child: MagazineListItem(
              title: topicListingResponse.dATA!.newspapers![index].title!,
              img: topicListingResponse.dATA!.newspapers![index].coverImage!,
              price: StringUtil.getPrice(
                  topicListingResponse.dATA!.newspapers![index].currency,
                  topicListingResponse.dATA!.newspapers![index].price),
              id: topicListingResponse.dATA!.newspapers![index].id!,
              type: BaseKey.Publish_NewsPaper,
            )),
      ),
    );
  }

  Widget magazineGrid(TopicsListingResponse topicListingResponse) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: UiUtil.getDefaultDelegate(context),
        itemCount: topicListingResponse.dATA!.magazines!.length,
        itemBuilder: (context, index) => MagazineListItem(
          title: topicListingResponse.dATA!.magazines![index].title!,
          img: topicListingResponse.dATA!.magazines![index].coverImage!,
          price: StringUtil.getPrice(
              topicListingResponse.dATA!.magazines![index].currency,
              topicListingResponse.dATA!.magazines![index].price),
          id: topicListingResponse.dATA!.magazines![index].id!,
          type: BaseKey.Publish_Magzine,
        ),
      ),
    );
  }
}
