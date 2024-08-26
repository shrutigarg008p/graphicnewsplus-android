// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_download_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkDownloadResponse _$MarkDownloadResponseFromJson(
        Map<String, dynamic> json) =>
    MarkDownloadResponse(
      DataDownload.fromJson(json['DATA'] as Map<String, dynamic>),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$MarkDownloadResponseToJson(
        MarkDownloadResponse instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

DataDownload _$DataDownloadFromJson(Map<String, dynamic> json) => DataDownload(
      download_counter: json['download_counter'] as int?,
      total_allowed_limit: json['total_allowed_limit'] as int?,
      file_added: json['file_added'] == null
          ? null
          : FileAdded.fromJson(json['file_added'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataDownloadToJson(DataDownload instance) =>
    <String, dynamic>{
      'download_counter': instance.download_counter,
      'total_allowed_limit': instance.total_allowed_limit,
      'file_added': instance.file_added,
    };

FileAdded _$FileAddedFromJson(Map<String, dynamic> json) => FileAdded(
      id: json['id'] as int?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$FileAddedToJson(FileAdded instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };
