import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookmark_new_response.g.dart';

@JsonSerializable()
class BookMarkNewResponse extends CommonDTO {
  List<BookMarkNewData>? DATA;

  BookMarkNewResponse({this.DATA});

  factory BookMarkNewResponse.fromJson(Map<String, dynamic> json) =>
      _$BookMarkNewResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookMarkNewResponseToJson(this);
}

@JsonSerializable()
class BookMarkNewData {
  String? name;
  String? key;
  bool? rss_content;
  List<BookMarkNewSubData>? data;

  BookMarkNewData({
    this.name,
    this.key,
    this.rss_content,
    this.data,
  });

  factory BookMarkNewData.fromJson(Map<String, dynamic> json) =>
      _$BookMarkNewDataFromJson(json);

  Map<String, dynamic> toJson() => _$BookMarkNewDataToJson(this);
}

@JsonSerializable()
class BookMarkNewSubData {
  int? id;
  String? title;
  String? price;
  String? cover_image;
  String? currency;
  String? content_image;
  List<BlogCategory>? blog_category;
  String? date;
  String? bookmark_type;

  BookMarkNewSubData(
      {this.id,
      this.title,
      this.price,
      this.cover_image,
      this.currency,
      this.content_image,
      this.blog_category,
      this.date,
      this.bookmark_type});

  factory BookMarkNewSubData.fromJson(Map<String, dynamic> json) =>
      _$BookMarkNewSubDataFromJson(json);

  Map<String, dynamic> toJson() => _$BookMarkNewSubDataToJson(this);
}

@JsonSerializable()
class BlogCategory {
  int? id;
  String? name;
  String? slug;

  BlogCategory({this.id, this.name, this.slug});
  factory BlogCategory.fromJson(Map<String, dynamic> json) =>
      _$BlogCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$BlogCategoryToJson(this);
}
