// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionDTO _$SubscriptionDTOFromJson(Map<String, dynamic> json) =>
    SubscriptionDTO(
      DATA: json['DATA'] == null
          ? null
          : Data.fromJson(json['DATA'] as Map<String, dynamic>),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$SubscriptionDTOToJson(SubscriptionDTO instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      plans: (json['plans'] as List<dynamic>?)
          ?.map((e) => Plans.fromJson(e as Map<String, dynamic>))
          .toList(),
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'currency': instance.currency,
      'plans': instance.plans,
    };

Plans _$PlansFromJson(Map<String, dynamic> json) => Plans(
      key: json['key'] as String?,
      value: json['value'] as String?,
      description: json['description'] as String?,
      period: (json['period'] as List<dynamic>?)
          ?.map((e) => Period.fromJson(e as Map<String, dynamic>))
          .toList(),
      packages: (json['packages'] as List<dynamic>?)
          ?.map((e) => Packages.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlansToJson(Plans instance) => <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'description': instance.description,
      'period': instance.period,
      'packages': instance.packages,
    };

Period _$PeriodFromJson(Map<String, dynamic> json) => Period(
      key: json['key'] as String?,
      name: json['name'] as String?,
      selected: json['selected'] as bool?,
      defaultSelect: json['defaultSelect'] as bool?,
    );

Map<String, dynamic> _$PeriodToJson(Period instance) => <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'selected': instance.selected,
      'defaultSelect': instance.defaultSelect,
    };

Packages _$PackagesFromJson(Map<String, dynamic> json) => Packages(
      key: json['key'] as int?,
      value: json['value'] as String?,
      description: json['description'] as String?,
      duration: (json['duration'] as List<dynamic>?)
          ?.map((e) => Duration.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultSelect: json['defaultSelect'] as bool?,
      ischecked: json['ischecked'] as bool?,
    )..selected = json['selected'] as bool?;

Map<String, dynamic> _$PackagesToJson(Packages instance) => <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'description': instance.description,
      'selected': instance.selected,
      'defaultSelect': instance.defaultSelect,
      'ischecked': instance.ischecked,
      'duration': instance.duration,
    };

Duration _$DurationFromJson(Map<String, dynamic> json) => Duration(
      key: json['key'] as String?,
      value: json['value'] as String?,
      price: json['price'] as String?,
      discount: json['discount'] as String?,
      apple_family_product_id: json['apple_family_product_id'] as String?,
      apple_product_id: json['apple_product_id'] as String?,
      family_price: json['family_price'] as String?,
      currency: json['currency'] as String?,
      family_price_arr: (json['family_price_arr'] as List<dynamic>?)
          ?.map((e) => FamilyPrice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DurationToJson(Duration instance) => <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'price': instance.price,
      'discount': instance.discount,
      'apple_family_product_id': instance.apple_family_product_id,
      'apple_product_id': instance.apple_product_id,
      'family_price': instance.family_price,
      'currency': instance.currency,
      'family_price_arr': instance.family_price_arr,
    };

FamilyPrice _$FamilyPriceFromJson(Map<String, dynamic> json) => FamilyPrice(
      member: json['member'] as int?,
      amount: json['amount'] as String?,
    );

Map<String, dynamic> _$FamilyPriceToJson(FamilyPrice instance) =>
    <String, dynamic>{
      'member': instance.member,
      'amount': instance.amount,
    };
