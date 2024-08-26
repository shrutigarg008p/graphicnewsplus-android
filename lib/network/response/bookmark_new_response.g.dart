// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_new_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookMarkNewResponse _$BookMarkNewResponseFromJson(Map<String, dynamic> json) =>
    BookMarkNewResponse(
      DATA: (json['DATA'] as List<dynamic>?)
          ?.map((e) => BookMarkNewData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$BookMarkNewResponseToJson(
        BookMarkNewResponse instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

BookMarkNewData _$BookMarkNewDataFromJson(Map<String, dynamic> json) =>
    BookMarkNewData(
      name: json['name'] as String?,
      key: json['key'] as String?,
      rss_content: json['rss_content'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BookMarkNewSubData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookMarkNewDataToJson(BookMarkNewData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'key': instance.key,
      'rss_content': instance.rss_content,
      'data': instance.data,
    };

BookMarkNewSubData _$BookMarkNewSubDataFromJson(Map<String, dynamic> json) =>
    BookMarkNewSubData(
      id: json['id'] as int?,
      title: json['title'] as String?,
      price: json['price'] as String?,
      cover_image: json['cover_image'] as String?,
      currency: json['currency'] as String?,
      content_image: json['content_image'] as String?,
      blog_category: (json['blog_category'] as List<dynamic>?)
          ?.map((e) => BlogCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: json['date'] as String?,
      bookmark_type: json['bookmark_type'] as String?,
    );

Map<String, dynamic> _$BookMarkNewSubDataToJson(BookMarkNewSubData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'cover_image': instance.cover_image,
      'currency': instance.currency,
      'content_image': instance.content_image,
      'blog_category': instance.blog_category,
      'date': instance.date,
      'bookmark_type': instance.bookmark_type,
    };

BlogCategory _$BlogCategoryFromJson(Map<String, dynamic> json) => BlogCategory(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
    );

Map<String, dynamic> _$BlogCategoryToJson(BlogCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };
