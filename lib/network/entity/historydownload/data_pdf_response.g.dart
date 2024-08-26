// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_pdf_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataPdfResponse _$DataPdfResponseFromJson(Map<String, dynamic> json) =>
    DataPdfResponse(
      DATA: json['DATA'] == null
          ? null
          : DataPdf.fromJson(json['DATA'] as Map<String, dynamic>),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$DataPdfResponseToJson(DataPdfResponse instance) =>
    <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };
