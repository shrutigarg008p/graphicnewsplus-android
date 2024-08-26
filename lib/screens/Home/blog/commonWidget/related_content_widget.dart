import 'package:flutter/material.dart';
import 'package:graphics_news/Assets/home_calander_icon_icons.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/subtitle_header.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/promoted_detail_response.dart';
import 'package:graphics_news/screens/Home/blog/promoted/promoted_content_details.dart';
import 'package:graphics_news/screens/Home/blog/topStory/top_stories_details.dart';

class RelatedContentWidget extends StatelessWidget {
  final PromotedDetailResponse? promotedDetailResponse;
  final String? type;

  RelatedContentWidget({Key? key, this.promotedDetailResponse, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      height: 250.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubTitleHeader(
            title: type == BaseKey.TYPE_TOP_STORY
                ? 'Related Top Stories'
                : "Related Promoted Content",
          ),
          SizedBox(
            height: 15.0,
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      promotedDetailResponse!.dATA!.related!.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        if (type == BaseKey.TYPE_TOP_STORY) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TopStoriesDetails(
                                        id: promotedDetailResponse!
                                            .dATA!.related![index].id,
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PromotedContentDetails(
                                        promotedId: promotedDetailResponse!
                                            .dATA!.related![index].id,
                                      )));
                        }
                      },
                      child: Container(
                        width: 200.0,
                        height: 200.0,
                        child: Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: AspectRatio(
                                    aspectRatio: 200 / 125,
                                    child: UiUtil.setImageNetwork(
                                        promotedDetailResponse!
                                            .dATA!.related![index].contentImage,
                                        null,
                                        null,
                                        border: true)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 3.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                      Text(
                                        promotedDetailResponse!
                                            .dATA!
                                            .related![index]
                                            .blogCategory!
                                            .name!,
                                        style: FontUtil.style(
                                            FontSizeUtil.xsmall,
                                            SizeWeight.Regular,
                                            context,
                                            WidgetColors.primaryColor),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                      Text(
                                        promotedDetailResponse!
                                            .dATA!.related![index].title!,
                                        style: FontUtil.style(
                                            FontSizeUtil.xsmall,
                                            SizeWeight.Bold,
                                            context),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              HomeCalanderIcon.home_calender,
                                              color: Colors.grey,
                                              size: 10.0,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Expanded(
                                                child: Text(
                                              promotedDetailResponse!
                                                  .dATA!.related![index].date!,
                                              style: FontUtil.style(
                                                  FontSizeUtil.xsmall,
                                                  SizeWeight.Regular,
                                                  context,
                                                  Colors.grey,
                                                  1.6),
                                            ))
                                          ],
                                        ),
                                      )
                                    ]),
                              )
                            ],
                          ),
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
}
