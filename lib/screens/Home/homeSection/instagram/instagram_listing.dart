import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/instagram_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:url_launcher/url_launcher.dart';

class InstagramListing extends StatefulWidget {
  @override
  _GallerylistingState createState() => _GallerylistingState();
}

class _GallerylistingState extends State<InstagramListing> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var fallbackUrl = "";
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  dynamic mediaQueryData;
  InstagramResponse? instagramListingResponse;

  bool? exception;

  @override
  void initState() {
    super.initState();
    getInstagram();
  }

  getInstagram() {
    HttpObj.instance.getClient().instagramList().then((it) {
      setState(() {
        setException(false);
        instagramListingResponse = it;

        print("Instagram Data $instagramListingResponse");

        print(instagramListingResponse!.dATA!.length);
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
    VoidCallback voidcallback = () => {setException(null), getInstagram()};
    return voidcallback;
  }

  _buildGalleryList(BuildContext context, InstagramResponse? listingResponse) {
    if (listingResponse == null) {
      return Container();
    }
    return SafeArea(
      child: Container(
        child: galleryGrid(listingResponse),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        key: scaffoldKey,
        appBar: HeaderWidget.appHeader(BaseConstant.INSTAGRAM, context),
        body: _buildBody(context));
  }

  _buildBody(BuildContext context) {
    return CommonWidget(context).getObjWidget(
        instagramListingResponse,
        exception,
        _buildGalleryList(context, instagramListingResponse),
        retryCallback());
  }

  Widget galleryGrid(InstagramResponse instagramresponse) {
    if (instagramresponse.dATA == null || instagramresponse.dATA!.isEmpty) {
      return Container();
    }

    return Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ResponsiveGridList(
            desiredItemWidth:
            UiRatio.getHeightGrid(context: context, height: 100),
            minSpacing: 10,
            children: instagramresponse.dATA!.map((instagramData) {
              return GestureDetector(
                onTap: () {
                  openUrl(instagramData.permalink!);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiUtil.setImageNetwork(
                        instagramData.media_type == "IMAGE"
                            ? instagramData.media_url
                            : instagramData.thumbnailUrl,
                        148.0,
                        150.0),
                    Text(
                      "",
                      style: FontUtil.style(14, SizeWeight.SemiBold, context),
                    ),
                  ],
                ),
              );
            }).toList()));
  }

  void openUrl(String socialUrl) async {
    try {
      bool launched = await launch(socialUrl, forceSafariVC: false);

      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }
}
