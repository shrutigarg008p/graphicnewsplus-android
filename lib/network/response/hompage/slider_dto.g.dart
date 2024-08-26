// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SliderDTO _$SliderDTOFromJson(Map<String, dynamic> json) => SliderDTO(
      json['id'] as int?,
      json['title'] as String?,
      json['content_image'] as String?,
      json['created_at'] as String?,
      json['updated_at'] as String?,
      json['thumbnail_image'] as String?,
      json['promoted'] as int?,
      json['top_story'] as int?,
      json['visit_count'] as int?,
      json['status'] as int?,
      json['short_description'] as String?,
      json['content'] as String?,
    );

Map<String, dynamic> _$SliderDTOToJson(SliderDTO instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content_image': instance.content_image,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'thumbnail_image': instance.thumbnail_image,
      'promoted': instance.promoted,
      'top_story': instance.top_story,
      'visit_count': instance.visit_count,
      'status': instance.status,
      'short_description': instance.short_description,
      'content': instance.content,
    };
