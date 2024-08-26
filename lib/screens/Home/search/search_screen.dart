import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/search_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/search/gridview_news_mag_widget.dart';
import 'package:graphics_news/screens/Home/search/gridview_promoted_story_widget.dart';
import 'package:graphics_news/util/LoadingIndicator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _seachController = TextEditingController();
  var search;
  bool buttonLoading = false;
  SearchResponse? listingResponse1;
  bool? exception;
  String lastInputValue = BaseConstant.EMPTY;

  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  void buttonloadingstate(bool stateload) {
    setState(() {
      buttonLoading = stateload;
    });
    fireScreenViewevent();
  }

  getDataFromlistApi({String searchValue = ""}) {
    search = searchValue;

    buttonloadingstate(true);

    print("testing");
    HttpObj.instance
        .getClient()
        .homeSearch(search)
        .then((value) => {
              buttonloadingstate(false),
              setState(() {
                listingResponse1 = value;
                setException(false);
              })
            })
        .catchError((Object obj) {
      setState(() {
        listingResponse1 = null;
      });
      listingResponse1 = null;
      if (mounted) {
        buttonloadingstate(false);

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

  Widget newsPaperGrid(SearchResponse? response) {
    if (listingResponse1!.dATA!.newspaper!.length == 0 &&
        listingResponse1!.dATA!.magazines!.length == 0 &&
        listingResponse1!.dATA!.topStory!.length == 0 &&
        listingResponse1!.dATA!.popularContent!.length == 0) {
      return buttonLoading
          ? Expanded(child: Center(child: LoadingIndicator()))
          : Expanded(
              child: Center(
              child: Text(
                "No Result Found",
                style: FontUtil.style(
                    FontSizeUtil.XXXXLarge, SizeWeight.SemiBold, context),
              ),
            ));
    }
    return buttonLoading
        ? Expanded(child: Center(child: LoadingIndicator()))
        : Expanded(
            child: Container(
                margin: EdgeInsets.only(top: 30),
                child: SingleChildScrollView(
                    child: Column(children: [
                  GridNewsMagSearchWidget(
                    paperData: response!.dATA!.newspaper,
                    type: BaseKey.TYPE_NEWSPAPER,
                  ),
                  GridNewsMagSearchWidget(
                    paperData: response.dATA!.magazines,
                    type: BaseKey.TYPE_MAGAZINES,
                  ),
                  GridPromotedStorySearchWidget(
                    popularContents: response.dATA!.topStory,
                    type: BaseKey.TYPE_TOP_STORY,
                  ),
                  GridPromotedStorySearchWidget(
                    popularContents: response.dATA!.popularContent,
                    type: BaseKey.TYPE_POPULAR_CONTENT,
                  )
                ]))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          HeaderWidget.appHeader(BaseConstant.SEARCH, context, border: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Material(
              borderRadius: BorderRadius.circular(5.0),
              elevation: 1.0,
              child: TextFormField(
                  controller: _seachController,
                  keyboardType: TextInputType.name,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(15),
                  ],
                  cursorColor: WidgetColors.primaryColor,
                  style: FontUtil.style(FontSizeUtil.Medium, SizeWeight.Regular,
                      context, ModeTheme.getDefault(context)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: search != null
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                listingResponse1 = null;
                                _seachController.clear();
                              });
                            },
                            child: Icon(Icons.close))
                        : null,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    hintText: "Search",
                    hintStyle: FontUtil.style(
                        FontSizeUtil.Large,
                        SizeWeight.Regular,
                        context,
                        ModeTheme.whiteGrey(context)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: WidgetColors.primaryColor),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (input) {
                    search = input;

                    if (input.length >= 3) {
                      if (lastInputValue != input) {
                        lastInputValue = input;
                        getDataFromlistApi(searchValue: search);
                      }
                    } else if (input.length <= 2) {
                      clear();
                    }
                  },
                  onFieldSubmitted: (input) {
                    search = input;
                    if (input.length >= 3) {
                      getDataFromlistApi(searchValue: search);
                    } else if (input.length <= 2) {
                      clear();
                    }
                  }),
            ),
          ),
          listingResponse1 == null || _seachController.text == ""
              ? buttonLoading
                  ? Center(child: LoadingIndicator())
                  : Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 40,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "What are you\nsearching for?",
                            style: FontUtil.style(
                                26, SizeWeight.SemiBold, context),
                          ),
                        ],
                      ),
                    )
              : newsPaperGrid(listingResponse1!)
        ],
      ),
    );
  }

  void clear() {
    if (mounted) {
      setState(() {
        listingResponse1 = null;
      });
    }
  }

  fireScreenViewevent() async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
    await FirebaseAnalytics.instance.logEvent(
      name: "screen_view",
      parameters: {
        "screen_name": "SearchScreen",
      },
    );
  }
}
