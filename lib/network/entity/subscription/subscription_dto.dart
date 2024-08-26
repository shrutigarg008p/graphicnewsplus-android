import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

/**
 * Created by Amit Rawat on 11/30/2021.
 */
part 'subscription_dto.g.dart';

@JsonSerializable()
class SubscriptionDTO extends CommonDTO {
  Data? DATA;

  SubscriptionDTO({
    this.DATA,
  });

  factory SubscriptionDTO.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionDTOToJson(this);
}

@JsonSerializable()
class Data {
  String? currency;
  List<Plans>? plans;

  Data({this.plans, this.currency});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Plans {
  String? key;
  String? value;
  String? description;
  List<Period>? period;
  List<Packages>? packages;

  Plans({
    this.key,
    this.value,
    this.description,
    this.period,
    this.packages,
  });

  factory Plans.fromJson(Map<String, dynamic> json) => _$PlansFromJson(json);

  Map<String, dynamic> toJson() => _$PlansToJson(this);
}

@JsonSerializable()
class Period {
  String? key;
  String? name;
  bool? selected;
  bool? defaultSelect;

  Period({this.key, this.name, this.selected, this.defaultSelect});

  factory Period.fromJson(Map<String, dynamic> json) => _$PeriodFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodToJson(this);
}

@JsonSerializable()
class Packages {
  int? key;
  String? value;
  String? description;
  bool? selected;
  bool? defaultSelect;
  bool? ischecked;
  List<Duration>? duration;

  Packages({
    this.key,
    this.value,
    this.description,
    this.duration,
    this.defaultSelect,
    this.ischecked,
  });

  factory Packages.fromJson(Map<String, dynamic> json) =>
      _$PackagesFromJson(json);

  Map<String, dynamic> toJson() => _$PackagesToJson(this);
}

@JsonSerializable()
class Duration {
  String? key;
  String? value;
  String? price;
  String? discount;
  String? apple_family_product_id;
  String? apple_product_id;
  String? family_price;
  String? currency;
  List<FamilyPrice>? family_price_arr;

  Duration(
      {this.key,
      this.value,
      this.price,
      this.discount,
      this.apple_family_product_id,
      this.apple_product_id,
      this.family_price,
      this.currency,
      this.family_price_arr});

  factory Duration.fromJson(Map<String, dynamic> json) =>
      _$DurationFromJson(json);

  Map<String, dynamic> toJson() => _$DurationToJson(this);

  @override
  String toString() {
    return 'Duration{key: $key, value: $value, price: $price, discount: $discount, apple_family_product_id: $apple_family_product_id, apple_product_id: $apple_product_id, family_price: $family_price, currency: $currency, family_price_arr: $family_price_arr}';
  }
}

@JsonSerializable()
class FamilyPrice {
  int? member;
  String? amount;
  FamilyPrice({this.member, this.amount});

  factory FamilyPrice.fromJson(Map<String, dynamic> json) =>
      _$FamilyPriceFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyPriceToJson(this);

  @override
  String toString() {
    return 'FamilyPrice{member: $member, amount: $amount}';
  }
}
