// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preference_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerferenceDTO _$PerferenceDTOFromJson(Map<String, dynamic> json) =>
    PerferenceDTO(
      (json['DATA'] as List<dynamic>?)
          ?.map((e) => Topics.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$PerferenceDTOToJson(PerferenceDTO instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

Topics _$TopicsFromJson(Map<String, dynamic> json) => Topics(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      selected: json['selected'] as bool?,
    );

Map<String, dynamic> _$TopicsToJson(Topics instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'selected': instance.selected,
    };
