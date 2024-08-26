import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/show_ads.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/common_timer.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/album/album_listing.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/homeSection/gallery/gallery_listing_id.dart';
import 'package:graphics_news/screens/Home/homeSection/gallery/gallery_util.dart';
import 'package:responsive_grid/responsive_grid.dart';

class AlbumlistingPage extends StatefulWidget {
  @override
  _AlbumlistingPageState createState() => _AlbumlistingPageState();
}

class _AlbumlistingPageState extends State<AlbumlistingPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  dynamic mediaQueryData;
  AlbumListingDTO? albumListingDTO;

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
    CommonTimer.subscribeTime(update: update);
    getapi();
  }

  void update() {
    ShowAds.setFullAds(context, BaseKey.GALLERY_LISTING);
  }

  @override
  void dispose() {
    CommonTimer.unsubscribeTime();
    super.dispose();
  }

  getapi() {
    HttpObj.instance.getClient().getAlbumList(_Firstpage).then((it) {
      if (mounted) {
        setState(() {
          setException(false);
          albumListingDTO = it;
          if (albumListingDTO != null && albumListingDTO?.DATA != null) {
            firstLoading(true);
          }
        });
      }
    }).catchError((Object obj) {
      setException(true);
      CommonException().exception(context, obj);
    });
  }

  void _loadMore() async {
    _page = _page + 1;
    loadMoreData(true);
    HttpObj.instance.getClient().getAlbumList(_page).then((it) {
      if (mounted) {
        setState(() {
          final List<AlbumData>? fetchedPosts = it.DATA;
          if (fetchedPosts != null && fetchedPosts.length > 0) {
            setState(() {
              albumListingDTO?.DATA?.addAll(fetchedPosts);
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

  _buildGalleryList(BuildContext context, AlbumListingDTO? albumListingDTO) {
    if (albumListingDTO == null) {
      return Container();
    }
    return SafeArea(
      child: Column(
        children: [
          Expanded(
              child: NotificationListener<ScrollNotification>(
            child: galleryGrid(albumListingDTO.DATA),
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
        appBar: HeaderWidget.appHeader(BaseConstant.Album, context),
        body: _buildBody(context));
  }

  _buildBody(BuildContext context) {
    return CommonWidget(context).getObjWidget(albumListingDTO, exception,
        _buildGalleryList(context, albumListingDTO), retryCallback());
  }

  Widget galleryGrid(List<AlbumData>? albumData) {
    if (albumData == null) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ResponsiveGridList(
          desiredItemWidth: GalleryUtil.getDesiredHeigth(context),
          minSpacing: 10,
          children: albumData.map((albumDataObject) {
            return Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    navigatePage(albumDataObject.id);
                  },
                  child: UiUtil.setImageNetwork(albumDataObject.image,
                      double.infinity, GalleryUtil.getImageHeight(context),
                      border: true),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  albumDataObject.title ?? "",
                  style: FontUtil.style(
                      FontSizeUtil.Medium, SizeWeight.SemiBold, context),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  albumDataObject.date ?? "",
                  style: FontUtil.style(
                      FontSizeUtil.small, SizeWeight.Medium, context),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ));
          }).toList()),
    );
  }

  void navigatePage(int? id) {
    InternetUtil.check().then((value) => {
          if (value)
            {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return GallerylistingIDPage(
                  id: id,
                );
              }))
            }
          else
            {InternetUtil.errorMsg(context)}
        });
  }
}
