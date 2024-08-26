// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paystack_init.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayStackInit _$PayStackInitFromJson(Map<String, dynamic> json) => PayStackInit(
      json['DATA'] == null
          ? null
          : PayData.fromJson(json['DATA'] as Map<String, dynamic>),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$PayStackInitToJson(PayStackInit instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

PayData _$PayDataFromJson(Map<String, dynamic> json) => PayData(
      amount: json['amount'] as String?,
      currency: json['currency'] as String?,
      paystack: json['paystack'] == null
          ? null
          : Paystack.fromJson(json['paystack'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PayDataToJson(PayData instance) => <String, dynamic>{
      'amount': instance.amount,
      'currency': instance.currency,
      'paystack': instance.paystack,
    };

Paystack _$PaystackFromJson(Map<String, dynamic> json) => Paystack(
      authorization_url: json['authorization_url'] as String?,
      access_code: json['access_code'] as String?,
      reference: json['reference'] as String?,
    );

Map<String, dynamic> _$PaystackToJson(Paystack instance) => <String, dynamic>{
      'authorization_url': instance.authorization_url,
      'access_code': instance.access_code,
      'reference': instance.reference,
    };
