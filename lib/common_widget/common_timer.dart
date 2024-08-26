import 'dart:async';

import 'package:graphics_news/common_widget/ads_screen.dart';
import 'package:graphics_news/constant/base_key.dart';

class CommonTimer {
  static Timer? _timer;

  static subscribeTime({required void Function() update}) {
    print("subscribeTime");
    if (_timer != null) {
      unsubscribeTime();
    }
    _timer = new Timer(Duration(seconds: BaseKey.CUSTOM_ADS_TIMER_SECONDS), () {
      update();
    });
  }

  static unsubscribeTime() {
    if (_timer != null) {
      print("unsubscribeTime");
      _timer!.cancel();
      closeAds();
    }
    if (AdsScreen.mediumTimer != null) {
      print("unsubscribeTime");
      AdsScreen.mediumTimer!.cancel();
      closeAds();
    }
  }

  static void closeAds() {
    AdsScreen.bannerAdVisibility = false;
    AdsScreen.interstitialAdVisibility = false;
    AdsScreen.mediumAdVisibility = false;
    if (AdsScreen.anchoredBanner != null) {
      AdsScreen.anchoredBanner!.dispose();
    }
    if (AdsScreen.interstitialAd != null) {
      AdsScreen.interstitialAd!.dispose();
    }
  }
}
