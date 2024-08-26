import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/home_response.dart';
import 'package:graphics_news/screens/Home/unused/topic_follow/topic_follow_details.dart';
import 'package:graphics_news/screens/Home/unused/topic_follow/topic_follow_listing.dart';

/*Topics*/
class SectionTopics extends StatelessWidget {
  List<Categories>? topics;
  String dataKey;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  SectionTopics({Key? key, required this.topics, required this.dataKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (topics == null || topics!.isEmpty) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.only(left: 18.0),
      height: 250.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget.subHeader(BaseConstant.TOPIC_TO_FOLLOW, context,
              onTap: () {
            redirect(context);
          }),
          SizedBox(
            height: 16.0,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 15.0),
              child: SingleChildScrollView(
                //  scrollDirection: Axis.horizontal,
                child: Wrap(
                  children: List.generate(topics!.length, (index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TopicFollowDetails(
                                    topicId: topics![index].id,
                                    topicName: topics![index].name,
                                  ))),
                      child: Container(
                        height: 46.0,
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          topics![index].name!,
                          style:
                              FontUtil.style(13, SizeWeight.Regular, context),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void redirect(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TopicListing()));
  }
}
