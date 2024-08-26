// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_coupons_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllCouponsResponse _$AllCouponsResponseFromJson(Map<String, dynamic> json) =>
    AllCouponsResponse(
      DATA: (json['DATA'] as List<dynamic>?)
          ?.map((e) => AllCouponsData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$AllCouponsResponseToJson(AllCouponsResponse instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

AllCouponsData _$AllCouponsDataFromJson(Map<String, dynamic> json) =>
    AllCouponsData(
      id: json['id'] as int?,
      user_id: json['user_id'] as int?,
      code: json['code'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      discount: json['discount'] as String?,
      used_times: json['used_times'] as int?,
      valid_for: json['valid_for'] as int?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );

Map<String, dynamic> _$AllCouponsDataToJson(AllCouponsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'code': instance.code,
      'type': instance.type,
      'status': instance.status,
      'title': instance.title,
      'description': instance.description,
      'discount': instance.discount,
      'used_times': instance.used_times,
      'valid_for': instance.valid_for,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
