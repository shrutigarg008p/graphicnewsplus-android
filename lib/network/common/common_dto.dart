import 'package:json_annotation/json_annotation.dart';

/**
 * Created by Amit Rawat on 11/22/2021.
 */
part 'common_dto.g.dart';
@JsonSerializable()
class CommonDTO {
  @JsonKey(name: "STATUS")
  int? sTATUS;
  String? MESSAGE;


  CommonDTO({this.sTATUS, this.MESSAGE});

  factory CommonDTO.fromJson(Map<String, dynamic> json) =>
      _$CommonDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CommonDTOToJson(this);
}