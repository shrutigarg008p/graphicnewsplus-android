// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grid_collection_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GridCollectionResponse _$GridCollectionResponseFromJson(
        Map<String, dynamic> json) =>
    GridCollectionResponse(
      DATA: json['DATA'] == null
          ? null
          : GridCollectionData.fromJson(json['DATA'] as Map<String, dynamic>),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$GridCollectionResponseToJson(
        GridCollectionResponse instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

GridCollectionData _$GridCollectionDataFromJson(Map<String, dynamic> json) =>
    GridCollectionData(
      slides: (json['slides'] as List<dynamic>?)
          ?.map((e) => GridCollectionSlides.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GridCollectionDataToJson(GridCollectionData instance) =>
    <String, dynamic>{
      'slides': instance.slides,
    };

GridCollectionSlides _$GridCollectionSlidesFromJson(
        Map<String, dynamic> json) =>
    GridCollectionSlides(
      slide: json['slide'] as int?,
      grids: (json['grids'] as List<dynamic>?)
          ?.map((e) => GridCollectionGrid.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GridCollectionSlidesToJson(
        GridCollectionSlides instance) =>
    <String, dynamic>{
      'slide': instance.slide,
      'grids': instance.grids,
    };

GridCollectionGrid _$GridCollectionGridFromJson(Map<String, dynamic> json) =>
    GridCollectionGrid(
      content_type: json['content_type'] as String?,
      thumbnail_image: json['thumbnail_image'] as String?,
      cover_image: json['cover_image'] as String?,
      title: json['title'] as String?,
      short_description: json['short_description'] as String?,
      description: json['description'] as String?,
      crossAxisCount: json['crossAxisCount'] as int?,
      mainAxisCount: json['mainAxisCount'] as int?,
      slide: json['slide'] as int?,
    );

Map<String, dynamic> _$GridCollectionGridToJson(GridCollectionGrid instance) =>
    <String, dynamic>{
      'content_type': instance.content_type,
      'thumbnail_image': instance.thumbnail_image,
      'cover_image': instance.cover_image,
      'title': instance.title,
      'short_description': instance.short_description,
      'description': instance.description,
      'crossAxisCount': instance.crossAxisCount,
      'mainAxisCount': instance.mainAxisCount,
      'slide': instance.slide,
    };
