import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:graphics_news/common_widget/ads_screen.dart';
import 'package:graphics_news/network/response/hompage/Ads.dart';

class SectionAdsBanner extends StatelessWidget {
  Ads? ads;
  String dataKey;
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

  SectionAdsBanner({Key? key, required this.ads, required this.dataKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ads == null) {
      return Container();
    }

    return AdsScreen.anchoredBanner != null
        ? Visibility(
            visible: AdsScreen.bannerAdVisibility,
            child: Container(
              width: AdsScreen.anchoredBanner!.size.width.toDouble(),
              height: AdsScreen.anchoredBanner!.size.height.toDouble(),
              child: AdWidget(ad: AdsScreen.anchoredBanner!),
            ))
        // : Visibility(
        //     visible: AdsScreen.bannerAdVisibility,
        //     child: AdsScreen.showCustomBannerAd(context));
        : Container(
            width: AdsScreen.anchoredBanner!.size.width.toDouble(),
            height: AdsScreen.anchoredBanner!.size.height.toDouble(),
            child: AdWidget(ad: AdsScreen.anchoredBanner!),
          );
  }
}
