import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Assets/d_o_b_icon_icons.dart';
import 'package:graphics_news/Assets/listing_calander_icon_icons.dart';
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
import 'package:graphics_news/network/response/news_listing_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

class MagNewsListing extends StatefulWidget {
  @override
  _MagNewsListingState createState() => _MagNewsListingState();
  String text;

  MagNewsListing(this.text);
}

class _MagNewsListingState extends State<MagNewsListing> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  //final int? newsId;
  var datatype = "newspaper";
  int categoryid = 0;
  int publicationid = 0;
  String fdate = "";
  String publications = "";
  DateTime selectedDate = DateTime.now();
  bool buttonLoading = false;

  dynamic mediaQueryData;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  NewsListingResponse? listingResponse1;
  List<PublicationsList>? publicationsList;
  NewsListingResponse? listingResponseData;
  var dateText = TextEditingController();
  bool? exception;
  var isSelected;

  var selectedValue;

  int _page = BaseKey.PAGINATION_KEY; //next page
  int _Firstpage = BaseKey.PAGINATION_KEY;
  bool _hasNextPage = true; // There is next page or not
  bool _isFirstLoadRunning =
      false; // Used to display loading indicators when _firstLoad function is running
  bool _isLoadMoreRunning =
      false; // Used to display loading indicators when _loadMore function is running

  @override
  void initState() {
    datatype = widget.text;
    super.initState();
    isSelected = 0;
    getPaperlistApi();
    CommonTimer.subscribeTime(update: update);
  }

  void resetLoadMore() {
    _page = BaseKey.PAGINATION_KEY;
    _Firstpage = BaseKey.PAGINATION_KEY;
    _isFirstLoadRunning = false;
    _isLoadMoreRunning = false;
    _hasNextPage = true;
  }

  void update() {
    ShowAds.setFullAds(
        context,
        datatype == "newspaper"
            ? BaseKey.NEWS_LISTING
            : BaseKey.MAGAZINE_LISTING);
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

  getPaperlistApi({int cat_id = 0 /*, int pub_id = 0*/}) {
    resetLoadMore();
    categoryid = cat_id;
    // publicationid = pub_id;
    buttonloadingstate(true);

    HttpObj.instance
        .getClient()
        .getNewsMagListingPage(
            categoryid, publicationid, fdate, datatype, _Firstpage)
        .then((value) => {
              buttonloadingstate(false),
              setState(() {
                value.dATA?.categoryList
                    ?.insert(0, CategoryListing(id: 0, name: "All", slug: ""));
                isSelected = isSelected;
                listingResponse1 = value;

                if (publicationsList == null) {
                  getPublicationslistApi();
                }
                if (value.dATA != null) {
                  firstLoading(true);
                }
                setException(false);
                //checkSubscription(responseData);
              })
            })
        .catchError((Object obj) {
      if (mounted) {
        buttonloadingstate(false);

        setException(true);
      }
      CommonException().exception(context, obj);
    });
  }

  getPublicationslistApi({int cat_id = 0}) {
    buttonloadingstate(true);

    HttpObj.instance
        .getClient()
        .getPublicationslistApi(cat_id, datatype)
        .then((value) => {
              print(value),
              publicationsList = value?.dATA!,
              buttonloadingstate(false),
              setState(() {
                selectedValue = null;
                dropdownItems();

                // setException(false);
                //checkSubscription(responseData);
              })
            })
        .catchError((Object obj) {
      if (mounted) {
        buttonloadingstate(false);

        setException(true);
      }
      CommonException().exception(context, obj);
    });
  }

  void _loadMore() async {
    _page = _page + 1;
    loadMoreData(true);
    HttpObj.instance
        .getClient()
        .getNewsMagListingPage(
            categoryid, publicationid, fdate, datatype, _page)
        .then((it) {
      if (mounted) {
        setState(() {
          if (it.dATA != null) {
            final List<NewsData>? fetchedPosts = it.dATA?.data;
            if (fetchedPosts != null && fetchedPosts.length > 0) {
              setState(() {
                listingResponse1?.dATA!.data!.addAll(fetchedPosts);
              });
            } else {
              // This means there is no more data
              // and therefore, we will not send another GET request
              setState(() {
                _hasNextPage = false;
              });
            }
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
          getPaperlistApi()
          // api for logout
        };
    return voidcallback;
  }

  _buildNewsList(BuildContext context) {
    if (listingResponse1 == null) return Text("No data found");

    return SafeArea(
        child: Column(
      children: [
        if (listingResponse1!.dATA!.categoryList != null)
          categoriesListTile(listingResponse1!.dATA!.categoryList!),
        SizedBox(
          height: 14.0,
        ),
        searchFilterRow(),
        SizedBox(
          height: 20.0,
        ),
        SubHeader(
            title: widget.text == 'newspaper'
                ? BaseConstant.NEWSPAPER_HEADER
                : BaseConstant.MAGAZINES),
        SizedBox(
          height: 16.0,
        ),
        Expanded(
            child: NotificationListener<ScrollNotification>(
          child: PaperListGrid(listingResponse1!),
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
    ));
  }

  Widget dropdown() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Material(
            borderRadius: BorderRadius.circular(5.0),
            child: new DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
              isExpanded: true,
              hint: Text(
                'Select Publication',
                overflow: TextOverflow.ellipsis,
                style: getFontStyle(context),
              ),
              style: getFontStyle(context),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: WidgetColors.primaryColor),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onTap: () => {print("hi")},
              value: selectedValue,
              items: dropdownItems(),
              onChanged: (value) {
                setState(() {
                  print("previous ${this.selectedValue}");
                  print("selected $value");
                  selectedValue = value;
                  publicationid = int.parse("$value");
                  // getPaperlistApi(pub_id: int.parse("$value"));
                  getPaperlistApi();
                });
              },
            ))));
  }

  dropdownItems() {
    List<DropdownMenuItem<String>> menuItem = [];
    // menuItem.clear();

    if (publicationsList != null) {
      for (var i = 0; i < publicationsList!.length; i++) {
        menuItem.add(DropdownMenuItem(
            child: Text(publicationsList![i].name.toString()),
            value: publicationsList![i].id.toString()));
      }
    } else {
      //return [];
    }

    return menuItem;
  }

  Widget dateTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        child: TextFormField(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectDate(context);
          },
          style: getFontStyle(context),
          keyboardType: TextInputType.datetime,
          cursorColor: WidgetColors.primaryColor,
          controller: dateText,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: "Search by date",
            hintStyle: getFontStyle(context),
            suffixIcon: IconButton(
              icon: Icon(
                DOBIcon.date_of_birth_calender,
                color: Colors.grey,
              ),
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectDate(context);
              },
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: WidgetColors.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onSaved: (input) => fdate = input!,
        ),
      ),
    );
  }

  getFontStyle(BuildContext context) {
    return FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular, context,
        ModeTheme.getDefault(context));
  }

  Future<void> _selectDate(BuildContext context) async {
    var now = new DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(1950, 1),
        lastDate: now);
    print(("selecteddate+$selectedDate+$picked"));
    if (picked != null /*&& picked != selectedDate*/)
      setState(() {
        selectedDate = picked;
        dateText.text = DateFormat('MM/dd/yyyy').format(selectedDate);
        fdate = dateText.text;
        getPaperlistApi();
        print(dateText.text);
      });
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
        appBar: HeaderWidget.appHeader(
            widget.text == BaseKey.Publish_NewsPaper
                ? BaseConstant.NEWSPAPERS
                : BaseConstant.MAGAZINES,
            context),
        body: buildHome(context));
  }

  buildHome(BuildContext context) {
    return CommonWidget(context).getObjWidget(
        listingResponse1, exception, _buildNewsList(context), retryCallback());
  }

  Widget selectedFieldIndexContainer() {
    return Container(
      height: 40.0,
      margin: EdgeInsets.only(right: 15.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: WidgetColors.primaryColor,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            height: 36.0,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              'NewsPapers',
              style: FontUtil.style(13, SizeWeight.Regular, context),
            ),
          )
        ],
      ),
    );
  }

  Widget categoriesListTile(List<CategoryListing> category) {
    return Container(
      margin: EdgeInsets.only(left: 17.0, top: 5),
      alignment: Alignment.centerLeft,
      height: 38.0,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              category.length,
              (index) => GestureDetector(
                onTap: () => {
                  isSelected = index,
                  selectedValue = null,
                  getPublicationslistApi(cat_id: category[index].id!),
                  getPaperlistApi(cat_id: category[index].id!),
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
                      child: Text(category[index].name!,
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

  Widget searchFilterRow() {
    return Container(
      height: 50.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchPublicationField(),
          SizedBox(
            width: 11.0,
          ),
          Expanded(child: dateTextFormField()),
        ],
      ),
    );
  }

  Widget searchPublicationField() {
    return Container(
        width: (MediaQuery.of(context).size.width / 2) - 20.0,
        height: 50.0,
        child: dropdown());
  }

  Widget searchByDateField() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.phone,
        cursorColor: WidgetColors.primaryColor,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          suffixIcon: IconButton(
            icon: Icon(ListingCalanderIcon.listing_page_calender),
            onPressed: () {},
          ),
          hintText: "Search by date",
          hintStyle: TextStyle(fontSize: 13.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: WidgetColors.primaryColor),
            borderRadius: BorderRadius.circular(5.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  Widget PaperListGrid(NewsListingResponse newsListingResponse) {
    if (listingResponse1!.dATA!.data!.length == 0) {
      return Center(child: Text("No data found"));
    }

    /* final List<NewsData>? fetchedPosts = listingResponse1!.dATA!.data;

    listingResponse1?.dATA!.data!.add(fetchedPosts![0]);
    listingResponse1?.dATA!.data!.add(fetchedPosts![0]);
    listingResponse1?.dATA!.data!.add(fetchedPosts![0]);
    listingResponse1?.dATA!.data!.add(fetchedPosts![0]);
    listingResponse1?.dATA!.data!.add(fetchedPosts![0]);
    listingResponse1?.dATA!.data!.add(fetchedPosts![0]);
    listingResponse1?.dATA!.data!.add(fetchedPosts![0]);
    listingResponse1?.dATA!.data!.add(fetchedPosts![0]);
    listingResponse1?.dATA!.data!.add(fetchedPosts![0]);
    listingResponse1?.dATA!.data!.add(fetchedPosts![0]);
    listingResponse1?.dATA!.data!.add(fetchedPosts![0]);*/

    return buttonLoading
        ? LoadingIndicator()
        : Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: ResponsiveGridList(
                desiredItemWidth: DataHolder.getHeightPaperCategory(context),
                minSpacing: 5,
                children: newsListingResponse.dATA!.data!.map((newsDataObj) {
                  return MagazineListItem(
                    title: newsDataObj.title ?? BaseConstant.EMPTY,
                    img: newsDataObj.coverImage ?? BaseConstant.EMPTY,
                    price: StringUtil.getPrice(
                        newsDataObj.currency, newsDataObj.price),
                    id: newsDataObj.id,
                    type: newsDataObj.type,
                  );
                }).toList()));
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
        "item_category": "Newspaper"
      },
    );
  }
}
