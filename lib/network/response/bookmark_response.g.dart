// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookMarkResponse _$BookMarkResponseFromJson(Map<String, dynamic> json) =>
    BookMarkResponse(
      DATA: (json['DATA'] as List<dynamic>?)
          ?.map((e) => BookMarkData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$BookMarkResponseToJson(BookMarkResponse instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

BookMarkData _$BookMarkDataFromJson(Map<String, dynamic> json) => BookMarkData(
      id: json['id'] as int?,
      title: json['title'] as String?,
      price: json['price'] as String?,
      thumbnail_image: json['thumbnail_image'] as String?,
      cover_image: json['cover_image'] as String?,
      bookmark_type: json['bookmark_type'] as String?,
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$BookMarkDataToJson(BookMarkData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'thumbnail_image': instance.thumbnail_image,
      'cover_image': instance.cover_image,
      'bookmark_type': instance.bookmark_type,
      'currency': instance.currency,
    };
