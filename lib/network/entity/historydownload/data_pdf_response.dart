import 'package:graphics_news/network/common/common_dto.dart';
import 'package:graphics_news/network/entity/historydownload/data_pdf.dart';
import 'package:json_annotation/json_annotation.dart';

/**
 * Created by Amit Rawat on 11/8/2021.
 */
part 'data_pdf_response.g.dart';

@JsonSerializable()
class DataPdfResponse extends CommonDTO {
  DataPdf? DATA;

  DataPdfResponse({this.DATA});

  factory DataPdfResponse.fromJson(Map<String, dynamic> json) =>
      _$DataPdfResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DataPdfResponseToJson(this);
}
