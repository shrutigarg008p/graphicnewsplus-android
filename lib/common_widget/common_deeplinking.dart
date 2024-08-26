import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:graphics_news/screens/Home/blog/promoted/promoted_content_details.dart';
import 'package:graphics_news/screens/Home/blog/topStory/top_stories_details.dart';
import 'package:graphics_news/screens/Home/paper/magazines/Magazine_details.dart';
import 'package:graphics_news/screens/Home/paper/newPaper/news_details.dart';
import 'package:graphics_news/screens/Home/podcast/podcast_play.dart';
import 'package:graphics_news/screens/Home/videoPod/video_detail.dart';

class CommonDeepLinking {
  static void redirectDeeplinking(
      dynamic deeplinkingType, int? deeplinkingId, BuildContext context) {
    if (deeplinkingType.toString().toLowerCase() == BaseKey.TYPE_NEWSPAPER ||
        deeplinkingType.toString().toLowerCase() == BaseKey.KEY_NEWSPAPER) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewsDetails(
                    newsId: deeplinkingId,
                    title: '',
                  )));
    } else if (deeplinkingType.toString().toLowerCase() ==
        BaseKey.TYPE_MAGAZINES) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MagazineDetails(
                    magazineId: deeplinkingId,
                    title: '',
                  )));
    } else if (deeplinkingType.toString().toLowerCase() ==
        BaseKey.TYPE_POPULAR_CONTENT) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PromotedContentDetails(promotedId: deeplinkingId)));
    } else if (deeplinkingType.toString().toLowerCase() ==
        BaseKey.TYPE_TOP_STORY) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TopStoriesDetails(id: deeplinkingId)));
    } else if (deeplinkingType.toString().toLowerCase() ==
        BaseKey.Publish_Promoted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PromotedContentDetails(promotedId: deeplinkingId)));
    } else if (deeplinkingType.toString().toLowerCase() == BaseKey.KEY_VIDEO) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoDetail(videoId: deeplinkingId)));
    } else if (deeplinkingType.toString().toLowerCase() == "podcast") {
      HttpObj.instance.getClient().podcastDetail(deeplinkingId!).then((it) {
        String msg = BaseConstant.SERVER_ERROR;
        if (it.sTATUS == BaseKey.SUCCESS) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return PodCastPlay(
                    podcastsId: it.DATA!.id!,
                    podcastsImage: it.DATA!.thumbnail_image!,
                    podcastFile: it.DATA!.podcast_file!);
              }).then((value) => {});
        } else {
          UiUtil.toastPrint(BaseConstant.SOMETHING_WENT_WRONG);
        }
        // return it;
      }).catchError((Object obj) {
        print(obj);
        print('data fetched successfullyerror ');
        CommonException().showException(context, obj);
      });
    }
  }

  static Future<bool> onBackPressed(
      dynamic deeplinkingType, int? deeplinkingId, BuildContext context) {
    if (deeplinkingType != null) {
      SplashScreen.deeplinkingType = null;
      SplashScreen.deeplinkingId = null;
      return new Future(() => true);
    } else {
      return new Future(() => true);
    }
  }
}
