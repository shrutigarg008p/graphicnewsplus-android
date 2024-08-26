/// Created by Amit Rawat on 1/19/2022.
import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'album_listing.g.dart';

@JsonSerializable()
class AlbumListingDTO extends CommonDTO {
  List<AlbumData>? DATA;

  AlbumListingDTO(this.DATA);

  factory AlbumListingDTO.fromJson(Map<String, dynamic> json) =>
      _$AlbumListingDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumListingDTOToJson(this);
}

@JsonSerializable()
class AlbumData {
  int? id;
  String? title;
  String? description;
  String? image;
  String? date;
  int? image_count;

  AlbumData({this.id, this.title, this.description, this.image,this.date,this.image_count});

  factory AlbumData.fromJson(Map<String, dynamic> json) => _$AlbumDataFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumDataToJson(this);

}


