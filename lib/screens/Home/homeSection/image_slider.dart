/// Created by Amit Rawat on 11/10/2021.
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/size_util.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/hompage/slider_dto.dart';
import 'package:graphics_news/screens/Home/blog/promoted/promoted_content_details.dart';
import 'package:graphics_news/screens/Home/blog/topStory/top_stories_details.dart';

class SectionImageSlider extends StatefulWidget {
  List<SliderDTO>? sliderData;
  String dataKey;

  SectionImageSlider(
      {Key? key, required this.sliderData, required this.dataKey})
      : super(key: key);

  @override
  ImageSlider createState() => new ImageSlider();
}

class ImageSlider extends State<SectionImageSlider> {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  double _currentIndexSlider = 0;

  @override
  Widget build(BuildContext context) {
    List<SliderDTO>? slideData = widget.sliderData;
    if (slideData == null) {
      return Container();
    } else if (slideData.isEmpty) {
      return Container();
    }

    var mheight = SizeUtil.getSliderHeight(context);

    return GestureDetector(
      onTap: () {
        try {
          nav(slideData[_currentIndexSlider.toInt()]);
          fireItemViewevent(
              slideData[_currentIndexSlider.toInt()].id.toString(),
              slideData[_currentIndexSlider.toInt()].title,
              "from_top_banner");
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CarouselSlider.builder(
                itemCount: slideData.length,
                itemBuilder: (BuildContext context, int itemIndex, int item) =>
                    GestureDetector(
                        child: Stack(
                          children: [
                            UiUtil.setImageNetwork(
                                slideData[itemIndex].content_image,
                                SizeUtil.getWidhtInfinity(),
                                mheight,
                                border: true),
                            Container(
                              height: mheight,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  gradient: LinearGradient(
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      colors: [
                                        Color.fromRGBO(0, 0, 0, 0),
                                        Color.fromRGBO(0, 0, 0, 0.80),
                                      ],
                                      stops: [
                                        0.5,
                                        1.0
                                      ])),
                            ),
                          ],
                        ),
                        onTap: () {
                          try {
                            nav(slideData[_currentIndexSlider.toInt()]);
                            fireItemViewevent(
                                slideData[_currentIndexSlider.toInt()]
                                    .id
                                    .toString(),
                                slideData[_currentIndexSlider.toInt()].title,
                                "from_top_banner");
                          } catch (e) {
                            print(e);
                          }
                        }),
                options: CarouselOptions(
                    height: mheight,
                    enlargeCenterPage: false,
                    autoPlay: true,
                    viewportFraction: 1,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndexSlider = index.toDouble();
                      });
                    })),
            Positioned(
                bottom: 0.0,
                child: GestureDetector(
                  onTap: () {
                    try {
                      nav(slideData[_currentIndexSlider.toInt()]);
                      fireItemViewevent(
                          slideData[_currentIndexSlider.toInt()].id.toString(),
                          slideData[_currentIndexSlider.toInt()].title,
                          "from_top_banner");
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300.0,
                        child: Text(
                          slideData[_currentIndexSlider.toInt()].title!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: false,
                          style: FontUtil.style(
                            12,
                            SizeWeight.Regular,
                            context,
                            Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.0,
                        child: new DotsIndicator(
                          dotsCount: slideData.length,
                          position: _currentIndexSlider,
                          decorator: DotsDecorator(
                            color: Colors.grey,
                            activeColor: Colors.white,
                            size: const Size.square(6.0),
                            activeSize: const Size(10.0, 8.0),
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void nav(SliderDTO slideData) {
    int promoted = slideData.promoted ?? 0;
    int topStories = slideData.top_story ?? 0;
    int idContent = slideData.id ?? 0;
    if (promoted == 1 && topStories == 1) {
/*default promoted */
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PromotedContentDetails(
                    promotedId: idContent,
                  )));
    } else if (promoted == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PromotedContentDetails(
                    promotedId: idContent,
                  )));
    } else if (topStories == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TopStoriesDetails(
                    id: idContent,
                  )));
    } else {
      print("unexpected content");
    }
  }

  fireItemViewevent(String? id, String? name, String type) async {
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
