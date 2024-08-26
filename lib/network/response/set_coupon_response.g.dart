// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_coupon_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetCouponResponse _$SetCouponResponseFromJson(Map<String, dynamic> json) =>
    SetCouponResponse(
      DATA: json['DATA'] == null
          ? null
          : SetCouponData.fromJson(json['DATA'] as Map<String, dynamic>),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$SetCouponResponseToJson(SetCouponResponse instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

SetCouponData _$SetCouponDataFromJson(Map<String, dynamic> json) =>
    SetCouponData(
      amount: json['amount'] as String?,
    );

Map<String, dynamic> _$SetCouponDataToJson(SetCouponData instance) =>
    <String, dynamic>{
      'amount': instance.amount,
    };
