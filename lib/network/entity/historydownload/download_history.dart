import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

/**
 * Created by Amit Rawat on 12/17/2021.
 */
part 'download_history.g.dart';

@JsonSerializable()
class DownloadHistory extends CommonDTO {
  List<History>? DATA;

  DownloadHistory({this.DATA});

  factory DownloadHistory.fromJson(Map<String, dynamic> json) =>
      _$DownloadHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadHistoryToJson(this);
}

@JsonSerializable()
class History {
  int? id;
  int? u_id;
  String? title;
  String? thumbnail_image;
  String? file;
  String? type;
  String? downloaded_at;
  String? offlinePdfPath;
  int? grid_view; //gridview 0 and 1

  History(
      {this.id,
      this.u_id,
      this.title,
      this.thumbnail_image,
      this.file,
      this.type,
      this.downloaded_at,
        this.offlinePdfPath,this.grid_view});

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}
