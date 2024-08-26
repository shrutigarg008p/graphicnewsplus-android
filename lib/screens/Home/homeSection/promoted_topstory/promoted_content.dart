import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/network/response/home_response.dart';
import 'package:graphics_news/screens/Home/blog/promoted/promoted_content_listing.dart';
import 'package:graphics_news/screens/Home/homeSection/promoted_topstory/gridview_promoted_story_widget.dart';

/*Popular content*/
class SectionPromotedContent extends StatefulWidget {
  List<PopularContents>? popularContents;
  String dataKey;

  SectionPromotedContent(
      {Key? key, required this.popularContents, required this.dataKey})
      : super(key: key);

  @override
  State<SectionPromotedContent> createState() => _SectionPromotedContentState();
}

class _SectionPromotedContentState extends State<SectionPromotedContent> {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  @override
  Widget build(BuildContext context) {
    if (widget.popularContents == null || widget.popularContents!.isEmpty) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(left: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget.subHeader(BaseConstant.PROMOTED_CONTENT, context,
              onTap: () {
            redirect(context);
          }),
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: GridViewPromotedStoryWidget(
              popularContents: widget.popularContents!,
              type: BaseKey.TYPE_POPULAR_CONTENT,
            ),
          )
        ],
      ),
    );
  }

  void redirect(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PromotedContentListing()));
  }
}
