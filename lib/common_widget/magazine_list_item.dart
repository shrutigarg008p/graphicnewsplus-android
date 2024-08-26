import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_overlay_loader.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Home/paper/magazines/Magazine_details.dart';
import 'package:graphics_news/screens/Home/paper/newPaper/news_details.dart';

class MagazineListItem extends StatefulWidget {
  final String? img;
  final String? title;
  final String? price;
  final int? id;
  final String? type;
  final bool? isArchive;

  MagazineListItem(
      {Key? key,
      this.title,
      this.img,
      this.price,
      this.id,
      this.type,
      this.isArchive})
      : super(key: key);

  @override
  State<MagazineListItem> createState() => _MagazineListItemState();
}

class _MagazineListItemState extends State<MagazineListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => widget.type == BaseKey.Publish_NewsPaper
                    ? NewsDetails(
                        newsId: widget.id!,
                        title: widget.title!,
                      )
                    : MagazineDetails(
                        magazineId: widget.id!,
                        title: widget.title,
                      ))),
        fireItemViewevent(widget.id!.toString(), widget.title!, widget.type)
      },
      child: Container(
        height: UiRatio.isPotrait(context)
            ? UiRatio.getHeight(200, 50)
            : UiRatio.getHeight(270, 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  child: UiUtil.setImageNetwork(
                      widget.img,
                      double.infinity,
                      UiRatio.isPotrait(context)
                          ? UiRatio.getHeight(140, 50)
                          : UiRatio.getHeight(200, 50),
                      border: true),
                ),
                if (widget.isArchive == null) bookmarkwidget()
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 5),
              child: Text(
                widget.title!,
                maxLines: 1,
                style: FontUtil.style(
                    FontSizeUtil.Medium, SizeWeight.SemiBold, context),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  widget.price!,
                  style: FontUtil.style(
                      FontSizeUtil.Medium, SizeWeight.Regular, context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bookmarkwidget() {
    return Visibility(
      visible: false,
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            bookmark(widget.id, widget.type, context);
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
                widget.type == BaseKey.Publish_NewsPaper
                    ? SplashScreen.bookMarkNewsPaper.contains(widget.id)
                        ? 'images/bookmark.png'
                        : 'images/bookmark_white.png'
                    : SplashScreen.bookMarkMagazines.contains(widget.id)
                        ? 'images/bookmark.png'
                        : 'images/bookmark_white.png',
              ),
            ),
          ),
        ),
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
        setState(() {
          if (widget.type == BaseKey.Publish_NewsPaper) {
            if (SplashScreen.bookMarkNewsPaper.contains(id)) {
              SplashScreen.bookMarkNewsPaper.remove(id);
            } else {
              SplashScreen.bookMarkNewsPaper.add(id);
            }
          } else {
            if (SplashScreen.bookMarkMagazines.contains(id)) {
              SplashScreen.bookMarkMagazines.remove(id);
            } else {
              SplashScreen.bookMarkMagazines.add(id);
            }
          }
        });
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

  fireItemViewevent(String? id, String? name, String? type) async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
    print(
        "newspaper id is" + " " + id.toString() + "name is " + name.toString());
    await FirebaseAnalytics.instance.logEvent(
      name: "view_item",
      parameters: {"item_id": id, "item_name": name, "item_category": type},
    );
  }
}
