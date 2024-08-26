import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/album/gallery_listing.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/homeSection/gallery/gallery_util.dart';
import 'package:responsive_grid/responsive_grid.dart';

import 'gallery_full_screen_slider.dart';

class GallerylistingIDPage extends StatefulWidget {
  final int? id;

  const GallerylistingIDPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _GallerylistingIDPageState createState() => _GallerylistingIDPageState();
}

class _GallerylistingIDPageState extends State<GallerylistingIDPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  dynamic mediaQueryData;
  GalleryListingDTO? galleryListingDTO;

  bool? exception;
  int _page = BaseKey.PAGINATION_KEY; //next page
  int _Firstpage = BaseKey.PAGINATION_KEY;
  bool _hasNextPage = true; // There is next page or not
  bool _isFirstLoadRunning =
      false; // Used to display loading indicators when _firstLoad function is running
  bool _isLoadMoreRunning =
      false; // Used to display loading indicators when _loadMore function is running

  @override
  void initState() {
    super.initState();
    getapi();
  }

  getapi() {
    HttpObj.instance
        .getClient()
        .getGalleryById(widget.id!, _Firstpage)
        .then((it) {
      setState(() {
        setException(false);
        galleryListingDTO = it;
        if (galleryListingDTO != null && galleryListingDTO?.DATA != null) {
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
    HttpObj.instance.getClient().getGalleryById(widget.id!, _page).then((it) {
      if (mounted) {
        setState(() {
          final List<GalleryData>? fetchedPosts = it.DATA;
          if (fetchedPosts != null && fetchedPosts.length > 0) {
            setState(() {
              galleryListingDTO?.DATA?.addAll(fetchedPosts);
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
    VoidCallback voidcallback = () => {setException(null), getapi()};
    return voidcallback;
  }

  _buildGalleryList(
      BuildContext context, GalleryListingDTO? galleryListingDTO) {
    if (galleryListingDTO == null) {
      return Container();
    }
    return SafeArea(
      child: Column(
        children: [
          Expanded(
              child: NotificationListener<ScrollNotification>(
            child: galleryGrid(galleryListingDTO.DATA),
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
    return Scaffold(
        key: scaffoldKey,
        appBar: HeaderWidget.appHeader(BaseConstant.GALLERY, context),
        body: _buildBody(context));
  }

  _buildBody(BuildContext context) {
    return CommonWidget(context).getObjWidget(galleryListingDTO, exception,
        _buildGalleryList(context, galleryListingDTO), retryCallback());
  }

  Widget galleryGrid(List<GalleryData>? galleryData) {
    if (galleryData == null) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ResponsiveGridList(
          desiredItemWidth: GalleryUtil.getDesiredHeigth(context),
          minSpacing: 10,
          children: galleryData.map((galleryDataObject) {
            return Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      int index = galleryData.indexOf(galleryDataObject);
                      navigatePage(galleryData, index.toDouble());
                    },
                    child: UiUtil.setImageNetwork(galleryDataObject.image,
                        double.infinity, GalleryUtil.getImageHeight(context),
                        border: true)),
                SizedBox(
                  height: 4,
                ),
                Text(
                  galleryDataObject.title ?? "",
                  style: FontUtil.style(
                      FontSizeUtil.Medium, SizeWeight.SemiBold, context),
                  maxLines: 1,
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ));
          }).toList()),
    );
  }

  void navigatePage(List<GalleryData>? galleryData, double index) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return GalleryFullScreenSlider(
        galleryData: galleryData,
        currentIndexSlider: index,
      );
    }));
  }
}
