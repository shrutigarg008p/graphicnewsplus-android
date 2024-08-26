import 'package:flutter/material.dart';
import 'package:graphics_news/Utility/mode_theme.dart';
import 'package:graphics_news/Utility/ui_util.dart';
import 'package:graphics_news/network/response/home_response.dart';

class CommonPodCastPlayer {
  static void podcastPlayer(
      List<Podcasts> podcasts, int index, BuildContext context, bool isPlaying,
      {OnTap}) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.75),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return WillPopScope(
          onWillPop: () async => true,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.27
                  : MediaQuery.of(context).size.width * 0.27,
              width: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width * 0.75
                  : MediaQuery.of(context).size.height * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          UiUtil.setImageNetwork(
                              podcasts[index].thumbnailImage, null, null,
                              border: true),
                          InkWell(
                            onTap: OnTap,
                            child: Container(
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
                      )
                    ],
                  )
                ],
              ),
              margin: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: ModeTheme.greyOrWhite(context),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        );
      },
      // transitionBuilder: (_, anim, __, child) {
      //   return SlideTransition(
      //     position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
      //     child: child,
      //   );
      // },
    );
  }

  // static Future<bool> onBackPressed() {
  //   return true;
  //   //  if (audioPlayer != null) {
  //   //   audioPlayer.stop();
  //   // }
  // }

  static getBody() {}
}
