// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumListingDTO _$AlbumListingDTOFromJson(Map<String, dynamic> json) =>
    AlbumListingDTO(
      (json['DATA'] as List<dynamic>?)
          ?.map((e) => AlbumData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$AlbumListingDTOToJson(AlbumListingDTO instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

AlbumData _$AlbumDataFromJson(Map<String, dynamic> json) => AlbumData(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      date: json['date'] as String?,
      image_count: json['image_count'] as int?,
    );

Map<String, dynamic> _$AlbumDataToJson(AlbumData instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'date': instance.date,
      'image_count': instance.image_count,
    };
