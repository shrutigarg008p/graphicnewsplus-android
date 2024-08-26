import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphics_news/common_widget/ads_screen.dart';
import 'package:graphics_news/common_widget/save_ads_data.dart';
import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';

class ShowAds {
  static setFullAds(BuildContext context, String type) {
    if (context == null) {
      return;
    }
    if (SaveAdsData.sharedInstance.subscription == false) {
      if (SaveAdsData.sharedInstance.isAdEnable == "1") {
        if (SaveAdsData.sharedInstance.fullAdsScreenList!.isNotEmpty &&
            SaveAdsData.sharedInstance.fullAdsScreenList!.contains(type)) {
          if (SaveAdsData.sharedInstance.adType!.toLowerCase() ==
              BaseKey.GOOGLE) {
            AdsScreen.createInterstitialAd(context);
          } else {
            AdsScreen.openCustomInterstitialAd(context);
          }
        }
      }
    }
  }

  static String setBannerAds(BuildContext context, String type) {
    if (context == null) {
      return BaseConstant.EMPTY;
    }
    String adUnitIdValue = BaseConstant.EMPTY;
    if (SaveAdsData.sharedInstance.subscription == false) {
      if (SaveAdsData.sharedInstance.isAdEnable == "1") {
        if (SaveAdsData.sharedInstance.bannerAdsScreenList!.isNotEmpty &&
            SaveAdsData.sharedInstance.bannerAdsScreenList!.contains(type)) {
          if (SaveAdsData.sharedInstance.adType!.toLowerCase() ==
              BaseKey.GOOGLE) {
            AdsScreen.createBannerAds(context);
          } else {
            adUnitIdValue = SaveAdsData.sharedInstance.bannerAdValue!;
            AdsScreen.openCustomBannerAd(context);
          }
        }
      }
    }
    return adUnitIdValue;
  }

  static setNativeAds(BuildContext context, String type) {
    if (SaveAdsData.sharedInstance.subscription == false) {
      if (SaveAdsData.sharedInstance.isAdEnable == "1") {
        if (SaveAdsData.sharedInstance.mediumAdsScreenList!.isNotEmpty &&
            SaveAdsData.sharedInstance.mediumAdsScreenList!.contains(type)) {
          if (SaveAdsData.sharedInstance.adType!.toLowerCase() !=
              BaseKey.GOOGLE) {
            return AdsScreen.showCustomNativeAd(context);
          }
        }
      }
    }
    return Container();
  }
}
