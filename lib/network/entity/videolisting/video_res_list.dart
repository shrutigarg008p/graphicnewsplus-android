import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

/**
 * Created by Amit Rawat on 12/14/2021.
 */
part 'video_res_list.g.dart';

@JsonSerializable()
class VideoResponseList extends CommonDTO {
  VideoData? DATA;

  VideoResponseList(this.DATA);

  factory VideoResponseList.fromJson(Map<String, dynamic> json) =>
      _$VideoResponseListFromJson(json);

  Map<String, dynamic> toJson() => _$VideoResponseListToJson(this);
}

@JsonSerializable()
class VideoData {
  int? current_page;
  List<Video>? data;
  String? first_page_url;
  int? from;
  int? last_page;
  String? last_page_url;
  List<Links>? links;
  dynamic? next_page_url;
  String? path;
  int? per_page;
  dynamic? prev_page_url;
  int? to;
  int? total;

  VideoData(
      this.current_page,
      this.data,
      this.first_page_url,
      this.from,
      this.last_page,
      this.last_page_url,
      this.links,
      this.next_page_url,
      this.path,
      this.per_page,
      this.prev_page_url,
      this.to,
      this.total);

  factory VideoData.fromJson(Map<String, dynamic> json) =>
      _$VideoDataFromJson(json);

  Map<String, dynamic> toJson() => _$VideoDataToJson(this);
}

@JsonSerializable()
class Video {
  int? id;
  String? title;
  String? thumbnail_image;
  String? video_file;
  String? video_link;
  String? date;
  String? date_readable;

  Video(this.id, this.title, this.thumbnail_image, this.video_file,
      this.video_link, this.date, this.date_readable);

  factory Video.fromJson(Map<String, dynamic> json) =>
      _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

@JsonSerializable()
class Links {
  String? url;
  String? label;
  bool? active;

  Links(this.url, this.label, this.active);

  factory Links.fromJson(Map<String, dynamic> json) =>
      _$LinksFromJson(json);

  Map<String, dynamic> toJson() => _$LinksToJson(this);
}
