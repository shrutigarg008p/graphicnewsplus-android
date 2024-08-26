/// Created by Amit Rawat on 11/10/2021.
import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/internet_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/network/response/home_response.dart';
import 'package:graphics_news/screens/Home/homeSection/gallery/album_listing.dart';
import 'package:graphics_news/screens/Home/homeSection/gallery/gallery_listing_id.dart';

class SectionGallery extends StatelessWidget {
  List<Albums>? albums;
  String dataKey;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  SectionGallery({Key? key, required this.albums, required this.dataKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (albums == null || albums!.isEmpty) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(left: 18.0),
      height: 180.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget.subHeader(BaseConstant.Album, context, onTap: () {
            redirect(context);
          }),
          SizedBox(
            height: 16.0,
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(albums!.length, (index) {
                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                child: GestureDetector(
                                  child: UiUtil.setImageNetwork(
                                      albums![index].image, 106.0, 116.0,
                                      border: true),
                                  onTap: () {
                                    navigatePage(albums![index].id, context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void redirect(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AlbumlistingPage()));
  }

  void navigatePage(int? id, BuildContext context) {
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
