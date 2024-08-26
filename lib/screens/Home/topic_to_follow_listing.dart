// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/data_holder.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/show_ads.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/LifeCycleManager.dart';
import 'package:graphics_news/common_widget/common_timer.dart';
import 'package:graphics_news/common_widget/magazine_list_item.dart';
import 'package:graphics_news/common_widget/sub_header.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/category_listing_response.dart';
import 'package:graphics_news/network/response/promoted_listing_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/blog/commonWidget/gridview_promoted_story__Listing_widget.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';
import 'package:responsive_grid/responsive_grid.dart';

class TopicToFollowListing extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const TopicToFollowListing({Key? key, this.categoryId, this.categoryName})
      : super(key: key);

  @override
  _TopicToFollowListingState createState() => _TopicToFollowListingState();
}

class _TopicToFollowListingState extends State<TopicToFollowListing> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  dynamic mediaQueryData;
  List settingsTile = ['Magazines', 'Stories', 'NewsPapers'];

  int activeIndex = 0;

  bool? exception;
  var isSelected = 0;

  var categoryTitle = "";
  CategoryListingResponse? categoryListingResponse;

  bool buttonLoading = false;
  int _page = BaseKey.PAGINATION_KEY; //next page
  int _Firstpage = BaseKey.PAGINATION_KEY;
  bool _hasNextPage = true; // There is next page or not
  bool _isFirstLoadRunning =
      false; // Used to display loading indicators when _firstLoad function is running
  bool _isLoadMoreRunning =
      false; // Used to display loading indicators when _loadMore function is running
  int categoryId = 0;
  String headerType = BaseKey.TOPIC_KEY_MAGAZINE;

  @override
  void initState() {
    super.initState();

    CommonTimer.subscribeTime(update: update);

    if (widget.categoryId != null) {
      categoryId = widget.categoryId!;
      categoryTitle = widget.categoryName!;
    }
    getapi();
  }

  void defaultHeader() {
    categoryId = 0;
    headerType = BaseKey.TOPIC_KEY_MAGAZINE;
  }

  void resetLoadMore() {
    _page = BaseKey.PAGINATION_KEY;
    _Firstpage = BaseKey.PAGINATION_KEY;
    _isFirstLoadRunning = false;
    _isLoadMoreRunning = false;
    _hasNextPage = true;
  }

  void update() {
    ShowAds.setFullAds(context, BaseKey.CATEGORIES_LISTING);
  }

  @override
  void dispose() {
    CommonTimer.unsubscribeTime();
    super.dispose();
  }

  void buttonloadingstate(bool stateload) {
    setState(() {
      buttonLoading = stateload;
    });
  }

  Category getDefaultCategory() {
    return Category(id: 0, name: 'All', slug: '');
  }

  getapi() {
    resetLoadMore();
    buttonloadingstate(true);

    HttpObj.instance
        .getClient()
        .getTopicFollowListingPage(categoryId, _Firstpage, headerType)
        .then((it) {
      setState(() {
        setException(false);
        categoryListingResponse = it;
        buttonloadingstate(false);

        categoryListingResponse!.dATA?.categories!
            .insert(0, getDefaultCategory());

        if (categoryListingResponse != null &&
            categoryListingResponse?.dATA != null) {
          firstLoading(true);
        }

        final index = categoryListingResponse!.dATA!.categories!
            .indexWhere((element) => element.id == categoryId);
        if (index >= 0) {
          isSelected = index;
        }
      });
    }).catchError((Object obj) {
      buttonloadingstate(false);
      setException(true);
      CommonException().exception(context, obj);
    });
  }

  void _loadMore() async {
    _page = _page + 1;
    loadMoreData(true);
    HttpObj.instance
        .getClient()
        .getTopicFollowListingPage(categoryId, _page, headerType)
        .then((it) {
      if (mounted) {
        setState(() {
          if (it != null && it.dATA != null) {
            if (headerType == BaseKey.TOPIC_KEY_MAGAZINE) {
              final List<Magazines>? fetchedPosts = it.dATA?.magazines;
              if (fetchedPosts != null && fetchedPosts.length > 0) {
                setState(() {
                  categoryListingResponse?.dATA!.magazines!
                      .addAll(fetchedPosts);
                });
              } else {
                // This means there is no more data
                // and therefore, we will not send another GET request
                noDataLoadMore(false);
              }
            } else if (headerType == BaseKey.TOPIC_KEY_STORY) {
              final List<PromotedDATA>? fetchedPosts = it.dATA?.stories;
              if (fetchedPosts != null && fetchedPosts.length > 0) {
                setState(() {
                  categoryListingResponse?.dATA!.stories!.addAll(fetchedPosts);
                });
              } else {
                // This means there is no more data
                // and therefore, we will not send another GET request
                noDataLoadMore(false);
              }
            } else if (headerType == BaseKey.TOPIC_KEY_NEWSPAPER) {
              final List<Magazines>? fetchedPosts = it.dATA?.newspapers;
              if (fetchedPosts != null && fetchedPosts.length > 0) {
                setState(() {
                  categoryListingResponse?.dATA!.newspapers!
                      .addAll(fetchedPosts);
                });
              } else {
                // This means there is no more data
                // and therefore, we will not send another GET request
                noDataLoadMore(false);
              }
            }
          }
          loadMoreData(false);
        });
      }
    }).catchError((Object obj) {
      loadMoreData(false);
    });
  }

  void noDataLoadMore(bool value) {
    if (mounted) {
      setState(() {
        _hasNextPage = value;
      });
    }
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

  _buildCategoryList(
      BuildContext context, CategoryListingResponse? categoryListingResponse) {
    if (categoryListingResponse == null) {
      return Container();
    }
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            if (categoryListingResponse != null)
              categoriesListTile(categoryListingResponse.dATA!.categories!),
            settingsListTile(),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    if (activeIndex == 0) ...[
                      SubHeader(title: BaseConstant.MAGAZINE_HEADER),
                      SizedBox(
                        height: 16.0,
                      ),
                      buttonLoading
                          ? LoadingIndicator()
                          : (categoryListingResponse.dATA!.magazines == null ||
                                  categoryListingResponse
                                          .dATA!.magazines!.length ==
                                      0)
                              ? noDataFound()
                              : Expanded(
                                  child: getScrollNotify(PaperGrid(
                                      categoryListingResponse.dATA!.magazines,
                                      BaseKey.Publish_Magzine))),
                      getLoadMoreData(),
                      getNothingTOLoad()
                    ],
                    if (activeIndex == 1) ...[
                      SubHeader(title: BaseConstant.STORIES),
                      SizedBox(
                        height: 16.0,
                      ),
                      buttonLoading
                          ? LoadingIndicator()
                          : (categoryListingResponse.dATA!.stories == null ||
                                  categoryListingResponse
                                          .dATA!.stories!.length ==
                                      0)
                              ? noDataFound()
                              : Expanded(
                                  child: getScrollNotify(storiesGrid(
                                      categoryListingResponse.dATA!.stories))),
                      getLoadMoreData(),
                      getNothingTOLoad()
                    ],
                    if (activeIndex == 2) ...[
                      SubHeader(title: BaseConstant.NEWSPAPER_HEADER),
                      SizedBox(
                        height: 16.0,
                      ),
                      buttonLoading
                          ? LoadingIndicator()
                          : (categoryListingResponse.dATA!.newspapers == null ||
                                  categoryListingResponse
                                          .dATA!.newspapers!.length ==
                                      0)
                              ? noDataFound()
                              : Expanded(
                                  child: getScrollNotify(PaperGrid(
                                      categoryListingResponse.dATA!.newspapers,
                                      BaseKey.Publish_NewsPaper))),
                      getLoadMoreData(),
                      getNothingTOLoad()
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getLoadMoreData() {
    if (_isLoadMoreRunning == true) return UiUtil.loadMoreData();
    return Container();
  }

  getNothingTOLoad() {
    if (_hasNextPage == false) UiUtil.nothingToLoad();
    return Container();
  }

  getScrollNotify(Widget widget) {
    return NotificationListener<ScrollNotification>(
      child: widget,
      onNotification: (ScrollNotification scrollInfo) {
        if (_isFirstLoadRunning == true &&
            _isLoadMoreRunning == false &&
            _hasNextPage == true &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadMore();
        }
        return false;
      },
    );
  }

  Expanded noDataFound() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Text('No data found',
            style: FontUtil.style(
                FontSizeUtil.Medium, SizeWeight.Regular, context)),
      ),
    );
  }

  Widget storiesGrid(List<PromotedDATA>? topStoriesListing) {
    if (topStoriesListing == null) {
      return UiUtil.noDataFound();
    }
    return Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: GridViewPromotedStoryListingWidget(
          popularContents: topStoriesListing,
        ));
  }

  Widget categoriesListTile(List<Category> categoryList) {
    return Container(
      margin: EdgeInsets.only(left: 17.0, top: 5),
      height: 38.0,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              categoryList.length,
              (index) => GestureDetector(
                onTap: () => {
                  isSelected = index,
                  categoryId = categoryList[index].id!,
                  categoryTitle = categoryList[index].name!,
                  getapi(),
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
                      child: Text(categoryList[index].name!,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    mediaQueryData = MediaQuery.of(context);
    return LifeCycleManager(child: getBody(), refresh: refreshPage);
  }

  refreshPage() {
    setState(() {});
  }

  getBody() {
    return Scaffold(
        key: scaffoldKey,
        appBar: HeaderWidget.appHeader(
            (widget.categoryId == null)
                ? BaseConstant.TOPIC_TO_FOLLOW
                : categoryTitle,
            context),
        body: _buildNewsList(context));
  }

  _buildNewsList(BuildContext context) {
    return CommonWidget(context).getObjWidget(
        categoryListingResponse,
        exception,
        _buildCategoryList(context, categoryListingResponse),
        retryCallback());
  }

  void setHeader(int index) {
    if (index == 0) {
      headerType = BaseKey.TOPIC_KEY_MAGAZINE;
    } else if (index == 1) {
      headerType = BaseKey.TOPIC_KEY_STORY;
    } else if (index == 2) {
      headerType = BaseKey.TOPIC_KEY_NEWSPAPER;
    }
  }

  Widget settingsListTile() {
    return Container(
      margin: EdgeInsets.all(17),
      height: 48.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
              settingsTile.length,
              (index) => Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            activeIndex = index;
                            setHeader(activeIndex);
                            getapi();
                          });
                        },
                        child: Container(
                          height: 44.0,
                          width: MediaQuery.of(context).size.width / 3 - 20,
                          decoration: BoxDecoration(
                            color: activeIndex == index
                                ? WidgetColors.primaryColor
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: Text(settingsTile[index],
                                textAlign: TextAlign.center,
                                style: FontUtil.style(
                                    13,
                                    SizeWeight.Regular,
                                    context,
                                    activeIndex == index
                                        ? Colors.white
                                        : Colors.black)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  )),
        ),
      ),
    );
  }

  Widget PaperGrid(List<Magazines>? magazines, String _type) {
    if (magazines == null) {
      return UiUtil.noDataFound();
    }
    return Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(horizontal: 17),
        child: ResponsiveGridList(
            desiredItemWidth: DataHolder.getHeightPaperCategory(context),
            minSpacing: 5,
            children: magazines.map((DataObj) {
              return MagazineListItem(
                title: DataObj.title ?? BaseConstant.EMPTY,
                img: DataObj.coverImage ?? BaseConstant.EMPTY,
                price: StringUtil.getPrice(DataObj.currency, DataObj.price),
                id: DataObj.id,
                type: _type,
              );
            }).toList()));
  }
/*
  void bookmark(int? id, String? type, BuildContext context) {
    CommonOverlayLoader.showLoader(context);

    HttpObj.instance.getClient().setBookMark(id!, type!).then((it) {
      CommonOverlayLoader.hideLoader(context);
      String msg = BaseConstant.SERVER_ERROR;
      if (it.sTATUS == BaseKey.SUCCESS) {
        print(it.MESSAGE);
        UiUtil.toastPrint(it.MESSAGE!);
        if (mounted) {
          setState(() {
            setdata(id, type);
          });
        }
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

  void setdata(int id, String type) {
    if (type == BaseKey.TYPE_TOP_STORY) {
      if (SplashScreen.bookMarkTopStories.contains(id)) {
        SplashScreen.bookMarkTopStories.remove(id);
      } else {
        SplashScreen.bookMarkTopStories.add(id);
      }
    } else {
      if (SplashScreen.bookMarkPromotedContent.contains(id)) {
        SplashScreen.bookMarkPromotedContent.remove(id);
      } else {
        SplashScreen.bookMarkPromotedContent.add(id);
      }
    }
  }*/

}
