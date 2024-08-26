import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookmark_response.g.dart';

@JsonSerializable()
class BookMarkResponse extends CommonDTO {
  List<BookMarkData>? DATA;

  BookMarkResponse({this.DATA});

  factory BookMarkResponse.fromJson(Map<String, dynamic> json) =>
      _$BookMarkResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookMarkResponseToJson(this);
}

@JsonSerializable()
class BookMarkData {
  int? id;
  String? title;
  String? price;
  String? thumbnail_image;
  String? cover_image;
  String? bookmark_type;
  String? currency;

  BookMarkData(
      {this.id,
      this.title,
      this.price,
      this.thumbnail_image,
      this.cover_image,
      this.bookmark_type,
      this.currency});

  factory BookMarkData.fromJson(Map<String, dynamic> json) =>
      _$BookMarkDataFromJson(json);

  Map<String, dynamic> toJson() => _$BookMarkDataToJson(this);
}
