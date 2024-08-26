import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/sub_header.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/search_response.dart';
import 'package:graphics_news/screens/Home/paper/magazines/Magazine_details.dart';
import 'package:graphics_news/screens/Home/paper/newPaper/news_details.dart';

/// Created by Amit Rawat on 2/1/2022.

class GridNewsMagSearchWidget extends StatefulWidget {
  List<Newspaper>? paperData;
  String? type;

  GridNewsMagSearchWidget({Key? key, this.paperData, this.type})
      : super(key: key);

  @override
  State<GridNewsMagSearchWidget> createState() =>
      _GridNewsMagSearchWidgetState();
}

class _GridNewsMagSearchWidgetState extends State<GridNewsMagSearchWidget> {
  dynamic mediaQueryData;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    if (widget.paperData == null) {
      return Container();
    } else if (widget.paperData!.isEmpty) {
      return Container();
    } else if (widget.paperData!.length == 0) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.only(left: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubHeader(
              isPadding: true,
              title: widget.type == BaseKey.TYPE_NEWSPAPER
                  ? BaseConstant.NEWSPAPERS
                  : BaseConstant.MAGAZINES),
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(widget.paperData!.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      navigate(widget.type, widget.paperData![index].id,
                          widget.paperData![index].title);

                      fireItemViewevent(widget.paperData![index].id.toString(),
                          widget.paperData![index].title, widget.type);
                    },
                    child: Container(
                      width: 140,
                      // height: 240,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: UiUtil.setImageNetwork(
                                    widget.paperData![index].coverImage,
                                    132.0,
                                    158.0,
                                    border: true),
                              ),
                            ]),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              height: data.size.shortestSide < 600 ? 38 : 58,
                              child: Text(
                                widget.paperData![index].title!,
                                style: FontUtil.style(FontSizeUtil.Medium,
                                    SizeWeight.SemiBold, context),
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  navigate(String? type, int? id, String? title) {
    if (type == BaseKey.TYPE_NEWSPAPER) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewsDetails(
                    newsId: id,
                    title: title,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MagazineDetails(
                    magazineId: id,
                    title: title,
                  )));
    }
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
