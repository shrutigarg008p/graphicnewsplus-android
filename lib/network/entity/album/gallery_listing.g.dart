// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalleryListingDTO _$GalleryListingDTOFromJson(Map<String, dynamic> json) =>
    GalleryListingDTO(
      (json['DATA'] as List<dynamic>?)
          ?.map((e) => GalleryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$GalleryListingDTOToJson(GalleryListingDTO instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

GalleryData _$GalleryDataFromJson(Map<String, dynamic> json) => GalleryData(
      id: json['id'] as int?,
      title: json['title'] as String?,
      shor_description: json['shor_description'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$GalleryDataToJson(GalleryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'shor_description': instance.shor_description,
      'image': instance.image,
    };
