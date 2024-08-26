import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'grid_collection_response.g.dart';

@JsonSerializable()
class GridCollectionResponse extends CommonDTO {
  GridCollectionData? DATA;
  GridCollectionResponse({this.DATA});

  factory GridCollectionResponse.fromJson(Map<String, dynamic> json) =>
      _$GridCollectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GridCollectionResponseToJson(this);
}

@JsonSerializable()
class GridCollectionData {
  List<GridCollectionSlides>? slides;
  GridCollectionData({this.slides});

  factory GridCollectionData.fromJson(Map<String, dynamic> json) =>
      _$GridCollectionDataFromJson(json);

  Map<String, dynamic> toJson() => _$GridCollectionDataToJson(this);
}

@JsonSerializable()
class GridCollectionSlides {
  int? slide;
  List<GridCollectionGrid>? grids;

  GridCollectionSlides({this.slide, this.grids});

  factory GridCollectionSlides.fromJson(Map<String, dynamic> json) =>
      _$GridCollectionSlidesFromJson(json);

  Map<String, dynamic> toJson() => _$GridCollectionSlidesToJson(this);
}

@JsonSerializable()
class GridCollectionGrid {
  String? content_type;
  String? thumbnail_image;
  String? cover_image;
  String? title;
  String? short_description;
  String? description;
  int? crossAxisCount;
  int? mainAxisCount;
  int? slide;

  GridCollectionGrid(
      {this.content_type,
      this.thumbnail_image,
      this.cover_image,
      this.title,
      this.short_description,
      this.description,
      this.crossAxisCount,
      this.mainAxisCount,
      this.slide});

  factory GridCollectionGrid.fromJson(Map<String, dynamic> json) =>
      _$GridCollectionGridFromJson(json);

  Map<String, dynamic> toJson() => _$GridCollectionGridToJson(this);
}
