import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/StringUtil.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/size_util.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/entity/album/gallery_listing.dart';

class GalleryFullScreenSlider extends StatefulWidget {
  final List<GalleryData>? galleryData;
  final double? currentIndexSlider;

  const GalleryFullScreenSlider(
      {Key? key, required this.galleryData, this.currentIndexSlider})
      : super(key: key);

  @override
  _GalleryFullScreenSliderState createState() =>
      _GalleryFullScreenSliderState();
}

class _GalleryFullScreenSliderState extends State<GalleryFullScreenSlider> {
  double _currentIndexSlider = 0;

  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  @override
  void initState() {
    super.initState();
    _currentIndexSlider = widget.currentIndexSlider!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          HeaderWidget.appHeader(BaseConstant.GALLERY, context, border: true),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CarouselSlider.builder(
                        itemCount: widget.galleryData!.length,
                        itemBuilder:
                            (BuildContext context, int itemIndex, int item) =>
                                GestureDetector(
                                    child: Column(
                                      children: [
                                        UiUtil.setImageNetwork(
                                            widget
                                                .galleryData![
                                                    _currentIndexSlider.toInt()]
                                                .image,
                                            UiRatio.isPotrait(context)
                                                ? UiRatio.getwidth(context)
                                                : null,
                                            SizeUtil.getHeight(context),
                                            border: false),
                                      ],
                                    ),
                                    onTap: () {
                                      try {
                                        // nav(slideData[_currentIndexSlider.toInt()]);
                                      } catch (e) {
                                        print(e);
                                      }
                                    }),
                        options: CarouselOptions(
                            height: SizeUtil.getHeight(context),
                            enlargeCenterPage: false,
                            autoPlay: false,
                            viewportFraction: 1,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
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
                              //  nav(slideData[_currentIndexSlider.toInt()]);
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 30.0,
                                child: new DotsIndicator(
                                  dotsCount: widget.galleryData!.length,
                                  position: _currentIndexSlider,
                                  decorator: DotsDecorator(
                                    color: Colors.grey,
                                    activeColor: Colors.white,
                                    size: const Size.square(6.0),
                                    activeSize: const Size(10.0, 8.0),
                                    activeShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          StringUtil.getValue(widget
                              .galleryData![_currentIndexSlider.toInt()].title),
                          style: FontUtil.style(
                              FontSizeUtil.Large,
                              SizeWeight.SemiBold,
                              context,
                              ModeTheme.getDefault(context)),
                        ),
                        SizedBox(height: 10),
                        // Text(
                        //   StringUtil.getValue(widget
                        //       .galleryData![_currentIndexSlider.toInt()]
                        //       .shor_description),
                        //   style: FontUtil.style(
                        //       FontSizeUtil.Medium,
                        //       SizeWeight.Medium,
                        //       context,
                        //       ModeTheme.lightGreyOrDarkGrey(context)),
                        // ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
