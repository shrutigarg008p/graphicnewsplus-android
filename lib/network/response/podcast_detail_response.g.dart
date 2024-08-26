// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PodcastDetailResponse _$PodcastDetailResponseFromJson(
        Map<String, dynamic> json) =>
    PodcastDetailResponse(
      DATA: json['DATA'] == null
          ? null
          : PodcastDetailData.fromJson(json['DATA'] as Map<String, dynamic>),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$PodcastDetailResponseToJson(
        PodcastDetailResponse instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

PodcastDetailData _$PodcastDetailDataFromJson(Map<String, dynamic> json) =>
    PodcastDetailData(
      id: json['id'] as int?,
      title: json['title'] as String?,
      thumbnail_image: json['thumbnail_image'] as String?,
      podcast_file: json['podcast_file'] as String?,
      date: json['date'] as String?,
      date_readable: json['date_readable'] as String?,
    );

Map<String, dynamic> _$PodcastDetailDataToJson(PodcastDetailData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbnail_image': instance.thumbnail_image,
      'podcast_file': instance.podcast_file,
      'date': instance.date,
      'date_readable': instance.date_readable,
    };
