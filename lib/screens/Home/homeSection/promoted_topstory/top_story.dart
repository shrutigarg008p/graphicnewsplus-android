import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/network/response/home_response.dart';
import 'package:graphics_news/screens/Home/blog/topStory/top_stories_listing.dart';
import 'package:graphics_news/screens/Home/homeSection/promoted_topstory/gridview_promoted_story_widget.dart';

class SectionTopStories extends StatefulWidget {
  List<PopularContents>? topStories;
  String dataKey;

  SectionTopStories({Key? key, required this.topStories, required this.dataKey})
      : super(key: key);

  @override
  State<SectionTopStories> createState() => _SectionTopStoriesState();
}

class _SectionTopStoriesState extends State<SectionTopStories> {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  @override
  Widget build(BuildContext context) {
    if (widget.topStories == null || widget.topStories!.isEmpty) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(left: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget.subHeader(BaseConstant.TOP_STORIES, context, onTap: () {
            redirect(context);
          }),
          SizedBox(
            height: 16.0,
          ),
          GridViewPromotedStoryWidget(
            popularContents: widget.topStories,
            type: BaseKey.TYPE_TOP_STORY,
          )
        ],
      ),
    );
  }

  void redirect(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TopStoriesListing()));
  }
}
