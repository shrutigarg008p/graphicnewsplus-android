import 'package:graphics_news/constant/base_constant.dart';
import 'package:graphics_news/constant/base_key.dart';
import 'package:graphics_news/network/response/home_response.dart';

class SaveAdsData {
  static var sharedInstance = SaveAdsData();

  var subscription;
  var adType;
  var bannerAdValue;
  var bannerAdsIosValue;
  var mediumAdsValue;
  var fullAdsValue;
  var fullAdsIosValue;
  var isAdEnable;
  var fullAdsUrl;
  var bannerAdsUrl;
  var mediumAdsUrl;
  List<String>? fullAdsScreenList = [];
  List<String>? bannerAdsScreenList = [];
  List<String>? mediumAdsScreenList = [];

  SaveAdsData({
    this.subscription,
    this.adType,
    this.bannerAdValue,
    this.bannerAdsIosValue,
    this.mediumAdsValue,
    this.fullAdsValue,
    this.fullAdsIosValue,
    this.isAdEnable,
    this.bannerAdsUrl,
    this.fullAdsUrl,
    this.mediumAdsUrl,
    this.fullAdsScreenList,
    this.bannerAdsScreenList,
    this.mediumAdsScreenList,
  });

  saveData(HomeResponse? responseData) {
    print("saveData method called");
    print(responseData!.dATA!.ads!.mediumAds);
    subscription = responseData.dATA!.subscribe;
    adType = responseData.dATA!.ads!.type;
    bannerAdValue = responseData.dATA!.ads!.bannerAds;
    mediumAdsValue = responseData.dATA!.ads!.mediumAds;
    fullAdsValue = responseData.dATA!.ads!.fullAds;
    isAdEnable = responseData.dATA!.ads!.isEnable;
    bannerAdsUrl = responseData.dATA!.ads!.bannerAdsUrl;
    fullAdsUrl = responseData.dATA!.ads!.fullAdsUrl;
    mediumAdsUrl = responseData.dATA!.ads!.mediumAdsUrl;

    if (responseData.dATA!.ads!.type!.toLowerCase() == BaseKey.GOOGLE) {
      bannerAdsIosValue = responseData.dATA!.ads!.bannerAdsIos;
      fullAdsIosValue = responseData.dATA!.ads!.fullAdsIos;
    }

    // fullAdsScreenList?.clear();
    // bannerAdsScreenList?.clear();
    // mediumAdsScreenList?.clear();
    // fullAdsScreenList?.addAll(responseData.dATA!.adsScreens!.fullads!);
    fullAdsScreenList = responseData.dATA!.adsScreens!.fullads!;
    bannerAdsScreenList = responseData.dATA!.adsScreens!.bannerads!;
    mediumAdsScreenList = responseData.dATA!.adsScreens!.mediumads!;
    print(bannerAdsScreenList!.length);

    // bannerAdsScreenList?.addAll(responseData.dATA!.adsScreens!.bannerads!);
    // mediumAdsScreenList?.addAll(responseData.dATA!.adsScreens!.mediumads!);
  }

  clear() {
    String empty = BaseConstant.EMPTY;
    subscription = empty;
    adType = empty;
    bannerAdValue = empty;
    bannerAdsIosValue = empty;
    mediumAdsValue = empty;
    fullAdsValue = empty;
    fullAdsIosValue = empty;
    isAdEnable = empty;
    fullAdsUrl = empty;
    bannerAdsUrl = empty;
    mediumAdsUrl = empty;
    fullAdsScreenList = [];
    bannerAdsScreenList = [];
    mediumAdsScreenList = [];
  }
}
