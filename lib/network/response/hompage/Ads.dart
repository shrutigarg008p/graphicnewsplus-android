class Ads {
  int? id;
  String? type;
  String? bannerAds;
  String? mediumAds;
  String? fullAds;
  String? bannerAdsIos;
  String? mediumAdsIos;
  String? fullAdsIos;
  String? isEnable;
  String? bannerAdsUrl;
  String? mediumAdsUrl;
  String? fullAdsUrl;

  Ads(
      {this.id,
      this.type,
      this.bannerAds,
      this.mediumAds,
      this.fullAds,
      this.bannerAdsIos,
      this.mediumAdsIos,
      this.fullAdsIos,
      this.isEnable,
      this.bannerAdsUrl,
      this.fullAdsUrl,
      this.mediumAdsUrl});

  Ads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    bannerAds = json['banner_ads'];
    mediumAds = json['medium_ads'];
    fullAds = json['full_ads'];
    bannerAdsIos = json['banner_ads_ios'];
    mediumAdsIos = json['medium_ads_ios'];
    fullAdsIos = json['full_ads_ios'];
    isEnable = json['is_enable'];
    mediumAdsUrl = json['medium_ads_url'];
    bannerAdsUrl = json['banner_ads_url'];
    fullAdsUrl = json['full_ads_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['banner_ads'] = this.bannerAds;
    data['medium_ads'] = this.mediumAds;
    data['full_ads'] = this.fullAds;
    data['banner_ads_ios'] = this.bannerAdsIos;
    data['medium_ads_ios'] = this.mediumAdsIos;
    data['full_ads_ios'] = this.fullAdsIos;
    data['is_enable'] = this.isEnable;
    data['banner_ads_url'] = this.bannerAdsUrl;
    data['full_ads_url'] = this.fullAdsUrl;
    data['medium_ads_url'] = this.mediumAdsUrl;
    return data;
  }
}
