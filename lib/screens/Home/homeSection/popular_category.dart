import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_ratio.dart';
import 'package:graphics_news/constant/base_color.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/home_response.dart';
import 'package:graphics_news/screens/Home/topic_to_follow_listing.dart';

/*popular categories*/
class SectionPopularCategory extends StatelessWidget {
  List<Categories>? categories;
  String dataKey;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  SectionPopularCategory(
      {Key? key, required this.categories, required this.dataKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categories == null || categories!.isEmpty) {
      return Container();
    }
    List colorList = BaseColor().popularCategoryTextCardColors;
    return Container(
      padding: EdgeInsets.only(left: 18.0),
      child: Column(
        children: [
          HeaderWidget.subHeader(BaseConstant.TOPIC_TO_FOLLOW, context,
              onTap: () {
            redirect(context);
          }),
          SizedBox(
            height: 16.0,
          ),
          Column(
            children: [
              GestureDetector(
                onPanUpdate: (details) {
                  // Swiping in left direction.
                  if (details.delta.dx < 0) {
                    redirect(context);
                  }
                },
                child: Container(
                    padding: EdgeInsets.only(left: 0.0, right: 8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: categories!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: data.size.shortestSide < 600
                            ? UiRatio.isPotrait(context)
                                ? 3
                                : 6
                            : UiRatio.isPotrait(context)
                                ? 6
                                : 8,
                        childAspectRatio: 1.5,
                      ),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TopicToFollowListing(
                                        categoryId: categories![index].id,
                                        categoryName: categories![index].name,
                                      ))),
                          fireItemViewevent(categories![index].id!.toString(),
                              categories![index].name!)
                        },
                        child: Container(
                          height: 62.0,
                          width: 106.0,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            elevation: 1.0,
                            color: colorList[index],
                            child: Center(
                              child: Text(
                                categories![index].name!,
                                style: FontUtil.style(
                                  FontSizeUtil.small,
                                  SizeWeight.SemiBold,
                                  context,
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  void redirect(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TopicToFollowListing()));
  }

  fireItemViewevent(String? id, String? name) async {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });
    print(
        "newspaper id is" + " " + id.toString() + "name is " + name.toString());
    await FirebaseAnalytics.instance.logEvent(
      name: "view_item",
      parameters: {
        "item_id": id,
        "item_name": name,
        "item_category": "Topics to Follow"
      },
    );
  }
}
