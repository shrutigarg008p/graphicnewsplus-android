import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/show_ads.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/LifeCycleManager.dart';
import 'package:graphics_news/common_widget/common_timer.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/network/response/promoted_listing_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/blog/commonWidget/gridview_promoted_story__Listing_widget.dart';

class TopStoriesListing extends StatefulWidget {
  @override
  _TopStoriesListingState createState() => _TopStoriesListingState();
}

class _TopStoriesListingState extends State<TopStoriesListing> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  dynamic mediaQueryData;
  bool? exception;
  PromotedListingResponse? promotedListingResponse;
  int _page = BaseKey.PAGINATION_KEY; //next page
  int _Firstpage = BaseKey.PAGINATION_KEY;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    CommonTimer.subscribeTime(update: update);
    getapi();
  }

  void update() {
    ShowAds.setFullAds(context, BaseKey.TOP_STORIES_LISTING);
  }

  @override
  void dispose() {
    CommonTimer.unsubscribeTime();
    super.dispose();
  }

  getapi() {
    HttpObj.instance
        .getClient()
        .getTopStoriesListingPage(_Firstpage)
        .then((it) {
      setState(() {
        setException(false);
        promotedListingResponse = it;
        if (promotedListingResponse != null &&
            promotedListingResponse?.dATA != null) {
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
    HttpObj.instance.getClient().getTopStoriesListingPage(_page).then((it) {
      if (mounted) {
        setState(() {
          final List<PromotedDATA>? fetchedPosts = it.dATA;
          if (fetchedPosts != null && fetchedPosts.length > 0) {
            setState(() {
              promotedListingResponse?.dATA?.addAll(fetchedPosts);
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
    VoidCallback voidcallback = () => {
          setException(null),
          getapi()
          // api for logout
        };
    return voidcallback;
  }

  _buildTopStoriesList(BuildContext context,
      PromotedListingResponse? topStoriesListingResponse) {
    if (topStoriesListingResponse == null) {
      return Container();
    }
    return SafeArea(
      child: Column(
        children: [
          Expanded(
              child: NotificationListener<ScrollNotification>(
            child: GridViewPromotedStoryListingWidget(
              popularContents: promotedListingResponse?.dATA,
            ),
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
    return LifeCycleManager(child: getBody(), refresh: refreshPage);
  }

  refreshPage() {
    setState(() {});
  }

  getBody() {
    return Scaffold(
        key: scaffoldKey,
        appBar: HeaderWidget.appHeader(BaseConstant.TOP_STORIES, context),
        body: _buildNewsList(context));
  }

  _buildNewsList(BuildContext context) {
    return CommonWidget(context).getObjWidget(
        promotedListingResponse,
        exception,
        _buildTopStoriesList(context, promotedListingResponse),
        retryCallback());
  }
}
