import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'podcast_detail_response.g.dart';

@JsonSerializable()
class PodcastDetailResponse extends CommonDTO {
  PodcastDetailData? DATA;

  PodcastDetailResponse({this.DATA});

  factory PodcastDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PodcastDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastDetailResponseToJson(this);
}

@JsonSerializable()
class PodcastDetailData {
  int? id;
  String? title;
  String? thumbnail_image;
  String? podcast_file;
  String? date;
  String? date_readable;

  PodcastDetailData(
      {this.id,
      this.title,
      this.thumbnail_image,
      this.podcast_file,
      this.date,
      this.date_readable});
  factory PodcastDetailData.fromJson(Map<String, dynamic> json) =>
      _$PodcastDetailDataFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastDetailDataToJson(this);
}
