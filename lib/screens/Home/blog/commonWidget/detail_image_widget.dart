import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_overlay_loader.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/network/response/promoted_detail_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';

class DetailImageWidget extends StatefulWidget {
  final PromotedContent? promotedContent;
  final String? type;

  DetailImageWidget({Key? key, this.promotedContent, this.type})
      : super(key: key);

  @override
  State<DetailImageWidget> createState() => _DetailImageWidgetState();
}

class _DetailImageWidgetState extends State<DetailImageWidget> {
  dynamic mediaQueryData;

  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Container(
      height: UiRatio.getAspectHeight(context, 220),
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          ClipRRect(
            child: AspectRatio(
                aspectRatio: UiRatio.getAspectRatio(context, 220),
                child: UiUtil.setImageNetwork2(
                    widget.promotedContent!.contentImage, null, null,
                    border: false)),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                bookmark(widget.promotedContent!.id,
                    widget.promotedContent!.type, context);
              },
              child: Container(
                padding: EdgeInsets.only(right: 10),
                alignment: Alignment.topRight,
                height: 40,
                width: 80,
                child: Image(
                  width: 26,
                  height: 26,
                  image: AssetImage(
                    widget.type == BaseKey.TYPE_TOP_STORY
                        ? SplashScreen.bookMarkTopStories.contains(
                            widget.promotedContent!.id,
                          )
                            ? 'images/bookmark.png'
                            : 'images/bookmark_white.png'
                        : SplashScreen.bookMarkPromotedContent.contains(
                            widget.promotedContent!.id,
                          )
                            ? 'images/bookmark.png'
                            : 'images/bookmark_white.png',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

  setdata(int? id, String? type) {
    if (type == BaseKey.TYPE_TOP_STORY) {
      if (SplashScreen.bookMarkTopStories.contains(id)) {
        SplashScreen.bookMarkTopStories.remove(id);
      } else {
        SplashScreen.bookMarkTopStories.add(id!);
      }
    } else {
      if (SplashScreen.bookMarkPromotedContent.contains(id)) {
        SplashScreen.bookMarkPromotedContent.remove(id);
      } else {
        SplashScreen.bookMarkPromotedContent.add(id!);
      }
    }
  }
}
