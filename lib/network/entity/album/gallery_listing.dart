/// Created by Amit Rawat on 1/19/2022.
import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gallery_listing.g.dart';

@JsonSerializable()
class GalleryListingDTO extends CommonDTO {
  List<GalleryData>? DATA;

  GalleryListingDTO(this.DATA);

  factory GalleryListingDTO.fromJson(Map<String, dynamic> json) =>
      _$GalleryListingDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryListingDTOToJson(this);
}

@JsonSerializable()
class GalleryData {
  int? id;
  String? title;
  String? shor_description;
  String? image;


  GalleryData({this.id, this.title, this.shor_description,this.image});

  factory GalleryData.fromJson(Map<String, dynamic> json) => _$GalleryDataFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryDataToJson(this);

}


