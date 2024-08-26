import 'package:json_annotation/json_annotation.dart';

/**
 * Created by Amit Rawat on 11/18/2021.
 */
part 'data_pdf.g.dart';

@JsonSerializable()
class DataPdf {
  int? id; //auto generate id
  int? req_id; // news and mag id
  int? uId; //unquie id
  String? type; //type magazine or newspaper
  int? grid_view; //gridview 0 and 1
  int? tempId; //TEMP id
  String? title;
  String? file;
  String? file_type;
  String? filepath; //pdf path
  String? ImageUrl; //thumbnail path

  static final columns = [
    "id",
    "req_id",
    "uId",
    "type",
    "grid_view",
    "tempId",
    "title",
    "file",
    "file_type",
    "Imagepath",
    "ImageUrl"
  ];

  @override
  String toString() {
    return 'DataPdf{id: $id, pdfId: $req_id, uId: $uId,  type: $type,  grid_view: $grid_view, tempId: $tempId, title: $title, file: $file, file_type: $file_type, filepath: $filepath, ImageUrl: $ImageUrl}';
  }

  DataPdf(
      {this.id,
      this.req_id,
      this.uId,
      this.type,
      this.grid_view,
      this.tempId,
      this.title,
      this.file,
      this.file_type,
      this.filepath,
      this.ImageUrl});

  factory DataPdf.fromJson(Map<String, dynamic> json) =>
      _$DataPdfFromJson(json);

  Map<String, dynamic> toJson() => _$DataPdfToJson(this);
}
