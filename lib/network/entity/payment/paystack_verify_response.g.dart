// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paystack_verify_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayStackVerifyResponse _$PayStackVerifyResponseFromJson(
        Map<String, dynamic> json) =>
    PayStackVerifyResponse(
      PayStackVerifyData.fromJson(json['DATA'] as Map<String, dynamic>),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$PayStackVerifyResponseToJson(
        PayStackVerifyResponse instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

PayStackVerifyData _$PayStackVerifyDataFromJson(Map<String, dynamic> json) =>
    PayStackVerifyData(
      key: json['key'] as int?,
      value: json['value'] as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      duration: json['duration'] == null
          ? null
          : TimeDuration.fromJson(json['duration'] as Map<String, dynamic>),
      amount: json['amount'] as String?,
      family: json['family'] as bool?,
      referral_code: json['referral_code'] as String?,
      members: json['members'] == null
          ? null
          : Members.fromJson(json['members'] as Map<String, dynamic>),
      subscribed: json['subscribed'] as String?,
      expired: json['expired'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
    );

Map<String, dynamic> _$PayStackVerifyDataToJson(PayStackVerifyData instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'type': instance.type,
      'description': instance.description,
      'duration': instance.duration,
      'amount': instance.amount,
      'family': instance.family,
      'referral_code': instance.referral_code,
      'members': instance.members,
      'subscribed': instance.subscribed,
      'expired': instance.expired,
      'paymentMethod': instance.paymentMethod,
    };

TimeDuration _$TimeDurationFromJson(Map<String, dynamic> json) => TimeDuration(
      key: json['key'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$TimeDurationToJson(TimeDuration instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };

Members _$MembersFromJson(Map<String, dynamic> json) => Members(
      total: json['total'] as int?,
      emails:
          (json['emails'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MembersToJson(Members instance) => <String, dynamic>{
      'total': instance.total,
      'emails': instance.emails,
    };
