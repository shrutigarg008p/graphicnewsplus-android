import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphics_news/Assets/speaker_icon_icons.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:graphics_news/network/response/home_response.dart';

/*treading news section */
class SectionTreadingNews extends StatefulWidget {
  HomeDATA homeDATA;
  String dataKey;

  SectionTreadingNews({Key? key, required this.homeDATA, required this.dataKey})
      : super(key: key);

  @override
  State<SectionTreadingNews> createState() => _SectionTreadingNewsState();
}

class _SectionTreadingNewsState extends State<SectionTreadingNews> {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18, top: 18.0),
      child: Container(
        decoration: BoxDecoration(
            color: ModeTheme.blackOrWhite(context),
            border: Border.all(color: ModeTheme.blackOrGrey(context)),
            borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(SpeakerIcon.loudspeaker_icon,
                  size: 17, color: Color(0xFFCBCBCB)),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: RichText(
                    text: TextSpan(
                        text: (BaseConstant.TRENDING_NEWS),
                        style: FontUtil.style(
                            FontSizeUtil.Medium,
                            SizeWeight.SemiBold,
                            context,
                            WidgetColors.primaryColor),
                        children: [
                      TextSpan(
                        text: (widget.homeDATA.trendingnews!.title),
                        style: FontUtil.style(
                          FontSizeUtil.Medium,
                          SizeWeight.Regular,
                          context,
                          ModeTheme.getDefault(context),
                        ),
                      )
                    ])),
              )
            ],
          ),
        ),
      ),
    );
  }
}
