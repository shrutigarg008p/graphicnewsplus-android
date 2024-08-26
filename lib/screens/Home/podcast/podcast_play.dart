import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/Colors/colors.dart';
import 'package:graphics_news/Utility/header_widget.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/style_util.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/common_widget/LifeCycleManager.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/font_size.dart';
import 'package:graphics_news/constant/rest_path.dart';
import 'package:graphics_news/constant/size_weight.dart';
import 'package:share_plus/share_plus.dart';

class PodCastPlay extends StatefulWidget {
  int podcastsId;
  String podcastsImage;
  String podcastFile;

  PodCastPlay(
      {required this.podcastsId,
      required this.podcastsImage,
      required this.podcastFile})
      : super();

  @override
  _PodCastPlayState createState() => _PodCastPlayState();
}

class _PodCastPlayState extends State<PodCastPlay> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context),
        ),
        audioPlayerTxt: StopPlaying);
  }

  getHeader() {
    return Scaffold(
        appBar: HeaderWidget.appHeader(BaseConstant.POD_CAST_HEADER, context),
        body: contentBox(context));
  }

  void getAudio(String? podcastFile) async {
    if (isPlaying) {
      var res = await audioPlayer.pause();
      if (res == 1) {
        setState(() {
          isPlaying = false;
        });
      }
    } else {
      var res = await audioPlayer.play(podcastFile!);
      if (res == 1) {
        setState(() {
          isPlaying = true;
        });
      }
    }
  }

  StopPlaying() {
    if (mounted) {
      setState(() {
        isPlaying = false;
      });
      audioPlayer.stop();
    }
  }

  getBody() {
    var height = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.height * 0.27
        : MediaQuery.of(context).size.width * 0.27;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 5,
            child: Stack(
              children: [
                UiUtil.setImageNetwork(
                    widget.podcastsImage, double.infinity, height,
                    border: true),
                InkWell(
                  onTap: () {
                    getAudio(widget.podcastFile);
                  },
                  child: Container(
                      height: height,
                      alignment: Alignment.center,
                      child: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.white,
                        size: 50.0,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  contentBox(BuildContext context) {
    var height = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.height * 0.30
        : MediaQuery.of(context).size.width * 0.30;
    var width = MediaQuery.of(context).orientation == Orientation.portrait
        ? MediaQuery.of(context).size.width * 0.75
        : MediaQuery.of(context).size.height * 0.75;
    return WillPopScope(
      onWillPop: () async => true,
      child: Align(
          alignment: Alignment.center,
          child: Wrap(
            children: [
              Container(
                color: ModeTheme.blackOrWhite(context),
                padding: EdgeInsets.all(10),
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: UiUtil.setImageNetwork(
                                  widget.podcastsImage,
                                  double.infinity,
                                  double.infinity,
                                  border: true),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              getAudio(widget.podcastFile);
                            },
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                  height: 100,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Icon(
                                            isPlaying
                                                ? Icons.pause_circle_filled
                                                : Icons.play_circle_fill,
                                            color: Colors.white,
                                            size: 35.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    alertButtons(context)
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void shareOption() async {
    var id = widget.podcastsId;
    final Size size = MediaQuery.of(context).size;

    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
        BaseConstant.SHARING_MSG +
            RestPath.BASE_URL2 +
            "getstory?t=podcast&tid=$id",
        sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2));
  }

  alertButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: UiUtil.borderDecorationBlackBorder(context),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(BaseConstant.CANCEL,
                      style: FontUtil.style(
                        FontSizeUtil.Large,
                        SizeWeight.Medium,
                        context,
                        Theme.of(context).brightness == Brightness.dark
                            ? WidgetColors.greyColorLight
                            : WidgetColors.greyColor,
                      )),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                shareOption();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: UiUtil.borderDecorationFillRed(),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(BaseConstant.SHARE.toUpperCase(),
                      style: FontUtil.style(FontSizeUtil.Large,
                          SizeWeight.Medium, context, Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
