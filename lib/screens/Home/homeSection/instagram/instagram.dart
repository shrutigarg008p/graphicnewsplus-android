import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/network/response/home_response.dart';
import 'package:graphics_news/screens/Home/homeSection/instagram/instagram_listing.dart';
import 'package:url_launcher/url_launcher.dart';

/*instagram section */
class SectionInstagram extends StatelessWidget {
  HomeDATA homeDATA;
  String dataKey;
  String fallbackUrl = 'https://www.facebook.com/page_name';

  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  SectionInstagram({Key? key, required this.homeDATA, required this.dataKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 18.0),
      height: 150.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget.subHeader(BaseConstant.INSTAGRAM, context, onTap: () {
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      List.generate(homeDATA.instagramData!.length, (index) {
                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                child: GestureDetector(
                                    onTap: () {
                                      openUrl(homeDATA
                                          .instagramData![index].permalink!);
                                    },
                                    child: UiUtil.setImageNetwork(
                                        homeDATA.instagramData![index]
                                                    .media_type ==
                                                "IMAGE"
                                            ? homeDATA
                                                .instagramData![index].media_url
                                            : homeDATA.instagramData![index]
                                                .thumbnailUrl,
                                        106.0,
                                        116.0,
                                        border: true)),
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

  void redirect(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => InstagramListing()));
  }
}
