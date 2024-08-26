import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

/**
 * Created by Amit Rawat on 11/18/2021.
 */
part 'mark_download_resp.g.dart';

@JsonSerializable()
class MarkDownloadResponse extends CommonDTO {
  DataDownload DATA;

  MarkDownloadResponse(this.DATA);

  factory MarkDownloadResponse.fromJson(Map<String, dynamic> json) =>
      _$MarkDownloadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MarkDownloadResponseToJson(this);
}

@JsonSerializable()
class DataDownload {
  int? download_counter;
  int? total_allowed_limit;
  FileAdded? file_added;

  DataDownload({this.download_counter, this.total_allowed_limit, this.file_added});


  factory DataDownload.fromJson(Map<String, dynamic> json) =>
      _$DataDownloadFromJson(json);

  Map<String, dynamic> toJson() => _$DataDownloadToJson(this);
}


@JsonSerializable()
class FileAdded {
  int? id;
  String? title;

  FileAdded({this.id, this.title});

  factory FileAdded.fromJson(Map<String, dynamic> json) =>
      _$FileAddedFromJson(json);

  Map<String, dynamic> toJson() => _$FileAddedToJson(this);
}
