// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_overlay_loader.dart';
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
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Home/blog/commonWidget/gridview_promoted_story__Listing_widget.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';
import 'package:responsive_grid/responsive_grid.dart';

class CategoriesListing extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const CategoriesListing({Key? key, this.categoryId, this.categoryName})
      : super(key: key);

  @override
  _CategoriesListingState createState() => _CategoriesListingState();
}

class _CategoriesListingState extends State<CategoriesListing> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  dynamic mediaQueryData;
  List settingsTile = ['Magazines', 'Stories', 'NewsPapers'];

  int activeIndex = 0;

  bool? exception;
  var isSelected;
  var catid;
  var categoryTitle = "";
  CategoryListingResponse? categoryListingResponse;
  CategoryListingResponse? categoryListingResponse1;
  bool buttonLoading = false;

  @override
  void initState() {
    super.initState();
    isSelected = 0;
    CommonTimer.subscribeTime(update: update);

    if (widget.categoryId == null) {
      getapi();
    } else {
      catid = widget.categoryId!;
      categoryTitle = widget.categoryName!;
      getCategoryDetailapi(categoryid: widget.categoryId!);
    }
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

  getapi() {
    buttonloadingstate(true);

    HttpObj.instance.getClient().getCategoryListingPage().then((it) {
      setState(() {
        setException(false);
        categoryListingResponse = it;
        buttonloadingstate(false);

        categoryListingResponse!.dATA?.categories!
            .insert(0, Category(id: 0, name: 'All', slug: ''));
      });
    }).catchError((Object obj) {
      setException(true);
      CommonException().exception(context, obj);
    });
  }

  getCategoryDetailapi({int categoryid = 0}) {
    print(categoryid);
    buttonloadingstate(true);

    HttpObj.instance.getClient().getCategoryDetailPage(categoryid).then((it) {
      setState(() {
        setException(false);
        buttonloadingstate(false);

        categoryListingResponse1 = it;

        if (catid != null) {
          categoryListingResponse = categoryListingResponse1;
          categoryListingResponse!.dATA?.categories!
              .insert(0, Category(id: 0, name: 'All', slug: ''));

          final index = categoryListingResponse!.dATA!.categories!
              .indexWhere((element) => element.id == widget.categoryId);
          if (index >= 0) {
            isSelected = index;
            catid = null;

            print(
                'Using indexWhere: ${categoryListingResponse!.dATA!.categories![index]}');
          }
        } else {
          isSelected = isSelected;
          categoryListingResponse!.dATA!.magazines =
              categoryListingResponse1!.dATA!.magazines;
          categoryListingResponse!.dATA!.newspapers =
              categoryListingResponse1!.dATA!.newspapers;
          categoryListingResponse!.dATA!.stories =
              categoryListingResponse1!.dATA!.stories;
        }
      });
    }).catchError((Object obj) {
      buttonloadingstate(false);

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
                    if (activeIndex == 0)
                      SubHeader(title: BaseConstant.MAGAZINE_HEADER),
                    if (activeIndex == 0)
                      SizedBox(
                        height: 16.0,
                      ),
                    if (activeIndex == 0)
                      buttonLoading
                          ? LoadingIndicator()
                          : categoryListingResponse.dATA!.magazines!.length == 0
                              ? Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text('No data found',
                                        style: FontUtil.style(
                                            FontSizeUtil.Medium,
                                            SizeWeight.Regular,
                                            context)),
                                  ),
                                )
                              : Expanded(
                                  child: magazineGrid(categoryListingResponse),
                                ),
                    if (activeIndex == 1)
                      SubHeader(title: BaseConstant.STORIES),
                    if (activeIndex == 1)
                      SizedBox(
                        height: 16.0,
                      ),
                    if (activeIndex == 1)
                      buttonLoading
                          ? LoadingIndicator()
                          : categoryListingResponse.dATA!.stories!.length == 0
                              ? Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text('No data found',
                                        style: FontUtil.style(
                                            FontSizeUtil.Medium,
                                            SizeWeight.Regular,
                                            context)),
                                  ),
                                )
                              : Expanded(
                                  child: storiesGrid(
                                      categoryListingResponse.dATA!.stories!),
                                ),
                    if (activeIndex == 2)
                      SubHeader(title: BaseConstant.NEWSPAPER_HEADER),
                    if (activeIndex == 2)
                      SizedBox(
                        height: 16.0,
                      ),
                    if (activeIndex == 2)
                      buttonLoading
                          ? LoadingIndicator()
                          : categoryListingResponse.dATA!.newspapers!.length ==
                                  0
                              ? Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text('No data found',
                                        style: FontUtil.style(
                                            FontSizeUtil.Medium,
                                            SizeWeight.Regular,
                                            context)),
                                  ),
                                )
                              : Expanded(
                                  child: newsPaperGrid(categoryListingResponse),
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

  Widget storiesGrid(List<PromotedDATA> topStoriesListing) {
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
                  if (categoryList[index].name == 'All')
                    {categoryTitle = "All", getapi()}
                  else
                    {
                      categoryTitle = categoryList[index].name!,
                      print(categoryList[index].id),
                      getCategoryDetailapi(categoryid: categoryList[index].id!),
                    }
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

  Widget newsPaperGrid(CategoryListingResponse categoryListingResponse) {
    return Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ResponsiveGridList(
            desiredItemWidth: DataHolder.getHeightPaperCategory(context),
            minSpacing: 5,
            children: categoryListingResponse.dATA!.newspapers!.map((DataObj) {
              return MagazineListItem(
                title: DataObj.title ?? BaseConstant.EMPTY,
                img: DataObj.coverImage ?? BaseConstant.EMPTY,
                price: StringUtil.getPrice(DataObj.currency, DataObj.price),
                id: DataObj.id,
                type: BaseKey.Publish_NewsPaper,
              );
            }).toList()));
  }

  Widget magazineGrid(CategoryListingResponse categoryListingResponse) {
    return Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(horizontal: 17),
        child: ResponsiveGridList(
            desiredItemWidth: DataHolder.getHeightPaperCategory(context),
            minSpacing: 5,
            children: categoryListingResponse.dATA!.magazines!.map((DataObj) {
              return MagazineListItem(
                title: DataObj.title ?? BaseConstant.EMPTY,
                img: DataObj.coverImage ?? BaseConstant.EMPTY,
                price: StringUtil.getPrice(DataObj.currency, DataObj.price),
                id: DataObj.id,
                type: BaseKey.Publish_Magzine,
              );
            }).toList()));
  }

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
  }
}
