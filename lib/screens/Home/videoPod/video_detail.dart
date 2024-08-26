import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/commonException.dart';
import 'package:graphics_news/common_widget/common_deeplinking.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/rest_path.dart';
import 'package:graphics_news/network/response/home_response.dart';
import 'package:graphics_news/network/services/http_client.dart';
import 'package:graphics_news/screens/Home/Splash_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetail extends StatefulWidget {
  final int? videoId;

  VideoDetail({Key? key, this.videoId}) : super(key: key);

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  late YoutubePlayerController _controller;
  bool? exception;
  Videos? data;

  @override
  void initState() {
    getVideo_detail(widget.videoId!);
    super.initState();
  }

  void getVideo_detail(int id) {
    HttpObj.instance.getClient().getVideo_detail(id).then((it) {
      data = it.dATA!;
      setData();
      setState(() {
        setException(false);
      });
    }).catchError((Object obj) {
      setException(true);
      CommonException().exception(context, obj);
    });
  }

  void setData() {
    print("Video Link is" + data!.videoLink!.split("/").last.toString());

    // https//www.youtube.com/embed/exdLpGkO09o youtube videoLink
    _controller = YoutubePlayerController(
      initialVideoId: data!.videoLink!.split("/").last.toString(),
      /*
      data!.videoLink!.split("=").last,*/
      flags: YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: true,
          loop: false,
          enableCaption: false),
    );
  }

  setException(bool? value) {
    if (mounted) {
      setState(() {
        exception = value;
      });
    }
  }

  void shareOption() async {
    var id = widget.videoId!;
    final Size size = MediaQuery.of(context).size;
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
        BaseConstant.SHARING_MSG +
            RestPath.BASE_URL2 +
            "getstory?t=video&tid=$id",
        sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2));
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Container();
    }

    return WillPopScope(
        onWillPop: () => CommonDeepLinking.onBackPressed(
            SplashScreen.deeplinkingType, SplashScreen.deeplinkingId, context),
        child: Scaffold(
          body: Stack(children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onEnded: (YoutubeMetaData youtubeMetaData) {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80, right: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    shareOption();
                  },
                  child: Icon(
                    Icons.share_sharp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80, right: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ]),
        ));
  }
}
