import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/common_response.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/network/response/grid_collection_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/gridView/common_detail_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class CommonGridLayout extends StatefulWidget {
  final int? id;
  final String? type;

  const CommonGridLayout({Key? key, this.id, this.type}) : super(key: key);

  @override
  State<CommonGridLayout> createState() => _CommonGridLayoutState();
}

class _CommonGridLayoutState extends State<CommonGridLayout> {
  final CarouselController _controller = CarouselController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPos = 0;
  bool? exception;
  dynamic mediaQueryData;
  GridCollectionResponse? gridCollectionResponse;

  @override
  void initState() {
    super.initState();
    getGridData();
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  }

  void getGridData() {
    HttpObj.instance
        .getClient()
        .gridCollection(widget.id!, widget.type!)
        .then((it) {
      if (mounted) {
        setState(() {
          gridCollectionResponse = it;
          setException(false);
        });
      }
    }).catchError((Object obj) {
      if (mounted) {
        setException(true);
      }

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
    VoidCallback voidcallback = () => {setException(null), getGridData()};
    return voidcallback;
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: HeaderWidget.appHeader(BaseConstant.APPNAME, context),
      body: buildGrid(context),
    );
  }

  buildGrid(BuildContext context) {
    return CommonWidget(context).getObjWidget(gridCollectionResponse, exception,
        myLayoutWidget(context, gridCollectionResponse), retryCallback());
  }

  Widget myLayoutWidget(
      BuildContext context, GridCollectionResponse? gridCollectionResponse) {
    final double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Container(
            height: height,
            child:
                gridCollectionResponse != null ? gridContainer() : Container()),
      ),
    );
  }

  openDescriptionPage(
    int index,
    List<GridCollectionGrid>? grids,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CommonDetailPage(grids![index].title!,
              grids[index].cover_image!, grids[index].description!)),
    );
  }

  gridContainer() {
    if (gridCollectionResponse!.DATA == null) {
      return Container();
    }
    return Column(
      children: [
        Expanded(
          child: Container(
            child: CarouselSlider(
              options: CarouselOptions(
                  height: double.infinity,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentPos = index;
                    });
                  }
                  // autoPlay: false,
                  ),
              items: gridCollectionResponse!.DATA!.slides!
                  .map((item) => Column(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: StaggeredGridView.countBuilder(
                                  shrinkWrap: true,
                                  crossAxisCount: 4,
                                  itemCount: item.grids!.length,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: <Widget>[
                                        ImageTile(
                                            index: index,
                                            width: item.grids![index]
                                                    .crossAxisCount! *
                                                100,
                                            height: item.grids![index]
                                                    .mainAxisCount! *
                                                100,
                                            item: item.grids!),
                                        Positioned.fill(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor:
                                                  Colors.black.withOpacity(0.5),
                                              onTap: () {
                                                if (item.grids![index].title !=
                                                    null) {
                                                  openDescriptionPage(
                                                      index, item.grids);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  staggeredTileBuilder: (index) =>
                                      StaggeredTile.count(
                                          item.grids![index].crossAxisCount!,
                                          item.grids![index].mainAxisCount!
                                              .toDouble())),
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: gridCollectionResponse!.DATA!.slides!.map((item) {
              int index = gridCollectionResponse!.DATA!.slides!.indexOf(item);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPos == index
                      ? Theme.of(context).brightness == Brightness.dark
                          ? WidgetColors.greyColor
                          : Color.fromRGBO(0, 0, 0, 0.9)
                      : Theme.of(context).brightness == Brightness.dark
                          ? WidgetColors.greyColorLight
                          : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ImageTile extends StatelessWidget {
  const ImageTile({
    Key? key,
    required this.index,
    required this.width,
    required this.height,
    required this.item,
  }) : super(key: key);

  final int index;
  final int width;
  final int height;
  final List<GridCollectionGrid> item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: FittedBox(
        child: UiUtil.setImageNetwork(
            item[index].thumbnail_image!, width.toDouble(), height.toDouble(),
            border: true),
        fit: BoxFit.fill,
      ),
    );
  }
}

class GridTile {
  const GridTile(this.crossAxisCount, this.mainAxisCount);

  final int crossAxisCount;
  final int mainAxisCount;
}
