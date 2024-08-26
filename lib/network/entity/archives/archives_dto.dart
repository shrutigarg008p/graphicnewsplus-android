import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

/**
 * Created by Amit Rawat on 1/28/2022.
 */
part 'archives_dto.g.dart';

@JsonSerializable()
class ArchivesDTO extends CommonDTO {
  ArchivesData? DATA;

  ArchivesDTO({this.DATA});

  factory ArchivesDTO.fromJson(Map<String, dynamic> json) =>
      _$ArchivesDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ArchivesDTOToJson(this);
}

@JsonSerializable()
class ArchivesData {
  Magazines? magazines;
  Magazines? newspapers;
  List<Publication>? publications;

  ArchivesData({this.magazines, this.newspapers, this.publications});

  factory ArchivesData.fromJson(Map<String, dynamic> json) =>
      _$ArchivesDataFromJson(json);

  Map<String, dynamic> toJson() => _$ArchivesDataToJson(this);
}

@JsonSerializable()
class Magazines {
  int? current_page;
  List<PaperDTO>? data;
  String? first_page_url;
  int? from;
  int? last_page;
  String? last_page_url;
  List<Links>? links;
  String? next_page_url;
  String? path;
  int? per_page;
  String? prev_page_url;
  int? to;
  int? total;

  Magazines(
      {this.current_page,
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
      this.total});

  factory Magazines.fromJson(Map<String, dynamic> json) =>
      _$MagazinesFromJson(json);

  Map<String, dynamic> toJson() => _$MagazinesToJson(this);
}

@JsonSerializable()
class PaperDTO {
  int? id;
  int? u_id;
  String? title;
  String? short_description;
  String? description;
  String? price;
  String? currency;
  String? cover_image;
  String? thumbnail_image;
  Category? category;
  Publication? publication;

  // List<Tags>? tags;
  String? published_date;
  String? published_date_readable;
  bool? bookmark;
  bool? grid_view;
  String? type;

  PaperDTO(
      {this.id,
      this.u_id,
      this.title,
      this.short_description,
      this.description,
      this.price,
      this.currency,
      this.cover_image,
      this.thumbnail_image,
      this.category,
      this.publication,
      this.published_date,
      this.published_date_readable,
      this.bookmark,
      this.grid_view,
      this.type});

  factory PaperDTO.fromJson(Map<String, dynamic> json) =>
      _$PaperDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PaperDTOToJson(this);
}

@JsonSerializable()
class Category {
  int? id;
  String? name;
  String? slug;

  Category({this.id, this.name, this.slug});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Publication {
  int? id;
  String? name;
  String? type;
  int? status;

  Publication({this.id, this.name, this.type, this.status});

  factory Publication.fromJson(Map<String, dynamic> json) =>
      _$PublicationFromJson(json);

  Map<String, dynamic> toJson() => _$PublicationToJson(this);
}

@JsonSerializable()
class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);

  Map<String, dynamic> toJson() => _$LinksToJson(this);
}
