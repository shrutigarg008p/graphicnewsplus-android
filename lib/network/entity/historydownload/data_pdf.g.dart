// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_pdf.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataPdf _$DataPdfFromJson(Map<String, dynamic> json) => DataPdf(
      id: json['id'] as int?,
      req_id: json['req_id'] as int?,
      uId: json['uId'] as int?,
      type: json['type'] as String?,
      grid_view: json['grid_view'] as int?,
      tempId: json['tempId'] as int?,
      title: json['title'] as String?,
      file: json['file'] as String?,
      file_type: json['file_type'] as String?,
      filepath: json['filepath'] as String?,
      ImageUrl: json['ImageUrl'] as String?,
    );

Map<String, dynamic> _$DataPdfToJson(DataPdf instance) => <String, dynamic>{
      'id': instance.id,
      'req_id': instance.req_id,
      'uId': instance.uId,
      'type': instance.type,
      'grid_view': instance.grid_view,
      'tempId': instance.tempId,
      'title': instance.title,
      'file': instance.file,
      'file_type': instance.file_type,
      'filepath': instance.filepath,
      'ImageUrl': instance.ImageUrl,
    };
