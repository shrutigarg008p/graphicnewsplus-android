import 'package:graphics_news/network/entity/subscription/subscription_dto.dart';

/// Created by Amit Rawat on 12/1/2021.
class SubscribeData {
  String? packagekey;
  String? currency;
  String? packagevalue;
  String? periods;
  String? familyReferralCode;
  String? couponCode;
  SinglePlan? bundleData;
  bool? familyPackageEnable;
  int? members;
  Map<int, SinglePlan>? multiplePlan; //not in used

  SubscribeData(
      {this.packagekey,
      this.currency,
      this.packagevalue,
      this.periods,
      this.familyReferralCode,
      this.couponCode,
      this.bundleData,
      this.multiplePlan,
      this.members,
      this.familyPackageEnable});

  @override
  String toString() {
    return 'SubscribeData{packagekey: $packagekey, currency: $currency, packagevalue: $packagevalue, periods: $periods, familyReferralCode: $familyReferralCode, couponCode: $couponCode, bundleData: $bundleData, familyPackageEnable: $familyPackageEnable, members: $members, multiplePlan: $multiplePlan}';
  }
}

class SinglePlan {
  int? planKey;
  String? planValue;
  String? amount;
  String? familyAmount;
  String? discount;
  String? Currency;
  String? appleProductId;
  String? appleFamilyProductId;
  List<FamilyPrice>? family_price_arr;
  List<Duration>? duration; //use for stack the duration in Weekly button

  SinglePlan(
      {this.planKey,
      this.planValue,
      this.amount,
      this.discount,
      this.familyAmount,
      this.appleProductId,
      this.appleFamilyProductId,
      this.duration,
      this.family_price_arr});

  @override
  String toString() {
    return 'SinglePlan{planKey: $planKey, planValue: $planValue, amount: $amount, familyAmount: $familyAmount, discount: $discount, Currency: $Currency, appleId: $appleProductId, appleIdFamily: $appleFamilyProductId, family_price_arr: $family_price_arr, duration: $duration}';
  }
}
