import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:graphics_news/common_widget/common_set_event.dart';
import 'package:graphics_news/common_widget/save_ads_data.dart';
import 'package:graphics_news/constant/rest_path.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utility/size_util.dart';
import '../Utility/ui_util.dart';

class AdsScreen {
  static BannerAd? anchoredBanner;
  static bool bannerAdVisibility = false;
  static bool interstitialAdVisibility = false;
  static bool mediumAdVisibility = false;
  static InterstitialAd? interstitialAd;
  static bool crossButtonPressed = false;
  static Timer? mediumTimer;

  static AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  static String fallbackUrl = RestPath.BASE_URL2;

  // method for Banner Ads
  static createBannerAds(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: request,
      adUnitId: Platform.isAndroid
          ? SaveAdsData.sharedInstance.bannerAdValue
          : SaveAdsData.sharedInstance.bannerAdsIosValue,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          bannerAdVisibility = true;
          anchoredBanner = ad as BannerAd?;
          print('$BannerAd loaded.');
          (context as Element).markNeedsBuild();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          bannerAdVisibility = false;
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }

// method to create Interstitial Ads
  static createInterstitialAd(BuildContext context) async {
    int _numInterstitialLoadAttempts = 0;
    final int maxFailedLoadAttempts = 3;
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? SaveAdsData.sharedInstance.fullAdsValue
            : SaveAdsData.sharedInstance.fullAdsIosValue,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            (context as Element).markNeedsBuild();
            interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            interstitialAd!.setImmersiveMode(true);
            showInterstitialAd(context);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              createInterstitialAd(context);
            }
          },
        ));
  }

// method to show Interstitial Ads
  static showInterstitialAd(BuildContext context) async {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
      print('ad onAdShowedFullScreenContent.');
    }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
    }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      createInterstitialAd(context);
    }, onAdImpression: (InterstitialAd ad) {
      print('$ad impression occurred.');
    });
    interstitialAd!.show();
    interstitialAd = null;
  }

  // open custom banner ads
  static openCustomBannerAd(BuildContext context) async {
    bannerAdVisibility = true;
    (context as Element).markNeedsBuild();
  }

  static showCustomBannerAd(BuildContext context, String adUnitIdValue) {
    // Timer(Duration(seconds: 10), () {
    //   bannerAdVisibility = false;
    // });

    return Container(
        child: AspectRatio(
      aspectRatio: (MediaQuery.of(context).orientation == Orientation.portrait)
          ? 32 / 5
          : 32 / 5,
      child: new Image.network(
        SaveAdsData.sharedInstance.bannerAdValue,
        fit: BoxFit.fill,
      ),
    ));
  }

  // open custom interstitial ads
  static openCustomInterstitialAd(BuildContext context) {
    interstitialAdVisibility = true;
    (context as Element).markNeedsBuild();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return new Scaffold(
              body: SafeArea(
            child: InkWell(
              onTap: () {
                openUrl(SaveAdsData.sharedInstance.fullAdsUrl, "full_banner");
              },
              child: Visibility(
                visible: interstitialAdVisibility,
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                            image: NetworkImage(
                                SaveAdsData.sharedInstance.fullAdsValue),
                            fit: BoxFit.fitWidth)),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: new IconButton(
                            icon: Icon(
                              Icons.cancel,
                              size: 30,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              crossButtonPressed = true;
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Navigator.pop(context);
                              });
                            }),
                      ),
                    )),
              ),
            ),
          ));
        },
        fullscreenDialog: true,
      ));
    });
  }

  static showCustomNativeAd(BuildContext context) {
    if (mediumTimer != null) {
      mediumTimer!.cancel();
      mediumAdVisibility = false;
    }

    mediumTimer = new Timer(Duration(seconds: 60), () {
      mediumAdVisibility = true;
      (context as Element).markNeedsBuild();
    });

    return InkWell(
      onTap: () {
        openUrl(SaveAdsData.sharedInstance.mediumAdsUrl, "medium_banner");
      },
      child: Visibility(
        visible: mediumAdVisibility,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              UiUtil.setImageNetwork(SaveAdsData.sharedInstance.mediumAdsValue,
                  double.infinity, SizeUtil.getadsHeight(context),
                  border: true),
              SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static openUrl(String url, String type) async {
    try {
      CommonSetEvent.setEvent("ads", type);
      bool launched = await launch(url, forceSafariVC: false);

      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      print(e.toString());
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }
}
