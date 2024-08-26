// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadHistory _$DownloadHistoryFromJson(Map<String, dynamic> json) =>
    DownloadHistory(
      DATA: (json['DATA'] as List<dynamic>?)
          ?.map((e) => History.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$DownloadHistoryToJson(DownloadHistory instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

History _$HistoryFromJson(Map<String, dynamic> json) => History(
      id: json['id'] as int?,
      u_id: json['u_id'] as int?,
      title: json['title'] as String?,
      thumbnail_image: json['thumbnail_image'] as String?,
      file: json['file'] as String?,
      type: json['type'] as String?,
      downloaded_at: json['downloaded_at'] as String?,
      offlinePdfPath: json['offlinePdfPath'] as String?,
      grid_view: json['grid_view'] as int?,
    );

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'id': instance.id,
      'u_id': instance.u_id,
      'title': instance.title,
      'thumbnail_image': instance.thumbnail_image,
      'file': instance.file,
      'type': instance.type,
      'downloaded_at': instance.downloaded_at,
      'offlinePdfPath': instance.offlinePdfPath,
      'grid_view': instance.grid_view,
    };
