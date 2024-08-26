// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_res_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoResponseList _$VideoResponseListFromJson(Map<String, dynamic> json) =>
    VideoResponseList(
      json['DATA'] == null
          ? null
          : VideoData.fromJson(json['DATA'] as Map<String, dynamic>),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$VideoResponseListToJson(VideoResponseList instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

VideoData _$VideoDataFromJson(Map<String, dynamic> json) => VideoData(
      json['current_page'] as int?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => Video.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['first_page_url'] as String?,
      json['from'] as int?,
      json['last_page'] as int?,
      json['last_page_url'] as String?,
      (json['links'] as List<dynamic>?)
          ?.map((e) => Links.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['next_page_url'],
      json['path'] as String?,
      json['per_page'] as int?,
      json['prev_page_url'],
      json['to'] as int?,
      json['total'] as int?,
    );

Map<String, dynamic> _$VideoDataToJson(VideoData instance) => <String, dynamic>{
      'current_page': instance.current_page,
      'data': instance.data,
      'first_page_url': instance.first_page_url,
      'from': instance.from,
      'last_page': instance.last_page,
      'last_page_url': instance.last_page_url,
      'links': instance.links,
      'next_page_url': instance.next_page_url,
      'path': instance.path,
      'per_page': instance.per_page,
      'prev_page_url': instance.prev_page_url,
      'to': instance.to,
      'total': instance.total,
    };

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      json['id'] as int?,
      json['title'] as String?,
      json['thumbnail_image'] as String?,
      json['video_file'] as String?,
      json['video_link'] as String?,
      json['date'] as String?,
      json['date_readable'] as String?,
    );

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbnail_image': instance.thumbnail_image,
      'video_file': instance.video_file,
      'video_link': instance.video_link,
      'date': instance.date,
      'date_readable': instance.date_readable,
    };

Links _$LinksFromJson(Map<String, dynamic> json) => Links(
      json['url'] as String?,
      json['label'] as String?,
      json['active'] as bool?,
    );

Map<String, dynamic> _$LinksToJson(Links instance) => <String, dynamic>{
      'url': instance.url,
      'label': instance.label,
      'active': instance.active,
    };
