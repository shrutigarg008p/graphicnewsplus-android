// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heard_from_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeardFromResponse _$HeardFromResponseFromJson(Map<String, dynamic> json) =>
    HeardFromResponse(
      DATA: (json['DATA'] as List<dynamic>?)?.map((e) => e as String).toList(),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$HeardFromResponseToJson(HeardFromResponse instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };
