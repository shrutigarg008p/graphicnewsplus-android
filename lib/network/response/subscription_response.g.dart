// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionResponse _$SubscriptionResponseFromJson(
        Map<String, dynamic> json) =>
    SubscriptionResponse(
      DATA: (json['DATA'] as List<dynamic>?)
          ?.map((e) => SubscriptionData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$SubscriptionResponseToJson(
        SubscriptionResponse instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

SubscriptionData _$SubscriptionDataFromJson(Map<String, dynamic> json) =>
    SubscriptionData(
      key: json['key'] as int?,
      value: json['value'] as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      apple_product_id: json['apple_product_id'] as String?,
      apple_family_product_id: json['apple_family_product_id'] as String?,
      duration: json['duration'] == null
          ? null
          : Duration.fromJson(json['duration'] as Map<String, dynamic>),
      amount: json['amount'] as String?,
      family: json['family'] as bool?,
      referral_code: json['referral_code'] as String?,
      via_referral_code: json['via_referral_code'] as String?,
      members: json['members'] == null
          ? null
          : Members.fromJson(json['members'] as Map<String, dynamic>),
      subscribed: json['subscribed'] as String?,
      expired: json['expired'] as String?,
      payment_method: json['payment_method'] as String?,
      currency: json['currency'] as String?,
      cancel_description: json['cancel_description'] as String?,
      cancel_status: json['cancel_status'] as bool?,
      via_referral: json['via_referral'] as bool?,
      reference_id: json['reference_id'] as int?,
      renew: json['renew'] as int?,
    );

Map<String, dynamic> _$SubscriptionDataToJson(SubscriptionData instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'type': instance.type,
      'description': instance.description,
      'apple_product_id': instance.apple_product_id,
      'apple_family_product_id': instance.apple_family_product_id,
      'duration': instance.duration,
      'amount': instance.amount,
      'family': instance.family,
      'referral_code': instance.referral_code,
      'via_referral_code': instance.via_referral_code,
      'members': instance.members,
      'subscribed': instance.subscribed,
      'expired': instance.expired,
      'payment_method': instance.payment_method,
      'currency': instance.currency,
      'cancel_description': instance.cancel_description,
      'cancel_status': instance.cancel_status,
      'via_referral': instance.via_referral,
      'reference_id': instance.reference_id,
      'renew': instance.renew
    };

Duration _$DurationFromJson(Map<String, dynamic> json) => Duration(
      key: json['key'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$DurationToJson(Duration instance) => <String, dynamic>{
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
