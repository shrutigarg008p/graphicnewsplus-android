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
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/LifeCycleManager.dart';
import 'package:graphics_news/common_widget/magazine_list_item.dart';
import 'package:graphics_news/common_widget/sub_header.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/archives/archives_dto.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ArchiveListing extends StatefulWidget {
  @override
  _ArchiveListingState createState() => _ArchiveListingState();
}

class _ArchiveListingState extends State<ArchiveListing> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  //final int? newsId;
  var datatype = "";
  int publicationid = 0;
  String fdate = "";
  String publications = "";
  DateTime selectedDate = DateTime.now();
  bool buttonLoading = false;
  dynamic mediaQueryData;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  List<Publication>? publicationsList;
  ArchivesDTO? listingResponseData;

  var dateText = TextEditingController();
  bool? exception;
  var isSelected;
  var selectedValue;
  List settingsTile = ['Magazines', 'NewsPapers'];
  int activeIndex = 0;
  int _page = BaseKey.PAGINATION_KEY; //next page
  int _Firstpage = BaseKey.PAGINATION_KEY;
  bool _hasNextPage = true; // There is next page or not
  bool _isFirstLoadRunning =
      false; // Used to display loading indicators when _firstLoad function is running
  bool _isLoadMoreRunning =
      false; // Used to display loading indicators when _loadMore function is running
  String headerType = BaseKey.TOPIC_KEY_MAGAZINE;

  @override
  void initState() {
    super.initState();
    isSelected = 0;
    getArchivelistApi();
  }

  void resetLoadMore() {
    _page = BaseKey.PAGINATION_KEY;
    _Firstpage = BaseKey.PAGINATION_KEY;
    _isFirstLoadRunning = false;
    _isLoadMoreRunning = false;
    _hasNextPage = true;
  }

  void buttonloadingstate(bool stateload) {
    setState(() {
      buttonLoading = stateload;
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
    VoidCallback voidcallback = () => {setException(null), getArchivelistApi()};
    return voidcallback;
  }

  getArchivelistApi({int pub_id = 0, String dateStr = ''}) {
    resetLoadMore();
    publicationid = pub_id;
    buttonloadingstate(true);

    HttpObj.instance
        .getClient()
        .archiveListing(publicationid, dateStr, _Firstpage, headerType)
        .then((value) => {
              print(value),
              buttonloadingstate(false),
              setState(() {
                listingResponseData = value;
                isSelected = isSelected;
                if (value.DATA != null) {
                  firstLoading(true);
                }
                if (publicationsList == null) {
                  publicationsList = value.DATA!.publications!;

                  // publicationsList =
                  // getPublicationslistApi();
                }

                setException(false);
              })
            })
        .catchError((Object obj) {
      print(obj);
      if (mounted) {
        buttonloadingstate(false);

        setException(true);
      }
      CommonException().exception(context, obj);
    });
  }

  void _loadMore({int pub_id = 0, String dateStr = ''}) async {
    _page = _page + 1;
    loadMoreData(true);
    HttpObj.instance
        .getClient()
        .archiveListing(publicationid, fdate, _page, headerType)
        .then((it) {
      if (mounted) {
        setState(() {
          if (it.DATA != null) {
            if (headerType == BaseKey.TOPIC_KEY_MAGAZINE) {
              final List<PaperDTO>? fetchedPosts = it.DATA!.magazines!.data;
              if (fetchedPosts != null && fetchedPosts.length > 0) {
                setState(() {
                  listingResponseData?.DATA!.magazines!.data!
                      .addAll(fetchedPosts);
                });
              } else {
                // This means there is no more data
                // and therefore, we will not send another GET request
                noDataLoadMore(false);
              }
            } else if (headerType == BaseKey.TOPIC_KEY_NEWSPAPER) {
              final List<PaperDTO>? fetchedPosts = it.DATA!.newspapers!.data;
              if (fetchedPosts != null && fetchedPosts.length > 0) {
                setState(() {
                  listingResponseData?.DATA!.newspapers!.data!
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

  _buildNewsList(BuildContext context) {
    if (listingResponseData == null) return Container();

    return SafeArea(
        child: Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          settingsListTile(),
          searchFilterRow(),
          SizedBox(
            height: 20.0,
          ),
          SubHeader(
              title: activeIndex == 0
                  ? BaseConstant.MAGAZINES
                  : BaseConstant.NEWSPAPERS),
          SizedBox(
            height: 16.0,
          ),
          //    Expanded(child: paperGrid(listingResponseData!)),

          Expanded(
              child: NotificationListener<ScrollNotification>(
            child: buttonLoading
                ? LoadingIndicator()
                : paperGrid(listingResponseData),
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
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
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
                  getArchivelistApi(
                      pub_id: int.parse("$value"), dateStr: fdate);
                  publicationid = int.parse("$value");
                  //getNewslistApi(pub_id: int.parse("$value"));
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
        firstDate: DateTime(1970, 1),
        lastDate: now);
    if (picked != null && picked != selectedDate) if (publicationid == 0) {
      UiUtil.showAlert(context, BaseConstant.APPNAME,
          BaseConstant.SELECT_PUBLICATION, null, true);
    } else {
      setState(() {
        selectedDate = picked;

        dateText.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        fdate = DateFormat('yyyy-MM-dd').format(selectedDate);
        getArchivelistApi(dateStr: fdate, pub_id: publicationid);

        print(dateText.text);
      });
    }
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
        appBar: HeaderWidget.appHeader(BaseConstant.ARCHIVE, context),
        body: buildHome(context));
  }

  buildHome(BuildContext context) {
    return CommonWidget(context).getObjWidget(listingResponseData, exception,
        _buildNewsList(context), retryCallback());
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

  void setHeader(int index) {
    if (index == 0) {
      headerType = BaseKey.TOPIC_KEY_MAGAZINE;
    } else if (index == 1) {
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
                            getArchivelistApi(
                                dateStr: fdate, pub_id: publicationid);
                            print(activeIndex);
                          });
                        },
                        child: Container(
                          height: 44.0,
                          width: MediaQuery.of(context).size.width / 2 - 20,
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

  Widget paperGrid(ArchivesDTO? newsListingResponse) {
    if (newsListingResponse == null) {
      return UiUtil.noDataFound();
    }
    if (activeIndex == 0) {
      if (newsListingResponse.DATA == null) {
        return UiUtil.noDataFound();
      } else if (newsListingResponse.DATA!.magazines == null) {
        return UiUtil.noDataFound();
      } else if (newsListingResponse.DATA!.magazines!.data == null) {
        return UiUtil.noDataFound();
      } else if (newsListingResponse.DATA!.magazines!.data!.length == 0) {
        return UiUtil.noDataFound();
      } else {
        return paperData(
            newsListingResponse.DATA!.magazines!.data, BaseKey.Publish_Magzine);
      }
    }
    if (activeIndex == 1) {
      if (newsListingResponse.DATA == null) {
        return UiUtil.noDataFound();
      } else if (newsListingResponse.DATA!.newspapers == null) {
        return UiUtil.noDataFound();
      } else if (newsListingResponse.DATA!.newspapers!.data == null) {
        return UiUtil.noDataFound();
      } else if (newsListingResponse.DATA!.newspapers!.data!.length == 0) {
        return UiUtil.noDataFound();
      } else {
        return paperData(newsListingResponse.DATA!.newspapers!.data,
            BaseKey.Publish_NewsPaper);
      }
    }
    return Container();
  }

  paperData(List<PaperDTO>? data, String _type) {
    return Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: ResponsiveGridList(
            desiredItemWidth: DataHolder.getHeightPaperCategory(context),
            minSpacing: 5,
            children: data!.map((newsDataObj) {
              return MagazineListItem(
                  title: newsDataObj.title ?? BaseConstant.EMPTY,
                  img: newsDataObj.cover_image ?? BaseConstant.EMPTY,
                  price: StringUtil.getPrice(
                      newsDataObj.currency, newsDataObj.price),
                  id: newsDataObj.id,
                  isArchive: true,
                  type: _type);
            }).toList()));
  }
}
