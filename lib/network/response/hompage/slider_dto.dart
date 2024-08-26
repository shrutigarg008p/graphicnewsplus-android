import 'package:json_annotation/json_annotation.dart';

/**
 * Created by Amit Rawat on 11/12/2021.
 */
part 'slider_dto.g.dart';

@JsonSerializable()
class SliderDTO {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "content_image")
  String? content_image;

  @JsonKey(name: "created_at")
  String? created_at;

  @JsonKey(name: "updated_at")
  String? updated_at;

  @JsonKey(name: "thumbnail_image")
  String? thumbnail_image;

  @JsonKey(name: "promoted")
  int? promoted;

  @JsonKey(name: "top_story")
  int? top_story;

  @JsonKey(name: "visit_count")
  int? visit_count;

  @JsonKey(name: "status")
  int? status;

  @JsonKey(name: "short_description")
  String? short_description;

  @JsonKey(name: "content")
  String? content;

  SliderDTO(
      this.id,
      this.title,
      this.content_image,
      this.created_at,
      this.updated_at,
      this.thumbnail_image,
      this.promoted,
      this.top_story,
      this.visit_count,
      this.status,
      this.short_description,
      this.content);

  factory SliderDTO.fromJson(Map<String, dynamic> json) =>
      _$SliderDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SliderDTOToJson(this);
}
