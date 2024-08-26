import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

/**
 * Created by Amit Rawat on 10/1/2022.
 */
part 'preference_dto.g.dart';

@JsonSerializable()
class PerferenceDTO extends CommonDTO {
  List<Topics>? DATA;

  PerferenceDTO(this.DATA);

  factory PerferenceDTO.fromJson(Map<String, dynamic> json) =>
      _$PerferenceDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PerferenceDTOToJson(this);
}

@JsonSerializable()
class Topics {
  int? id;
  String? name;
  String? slug;
  bool? selected;

  Topics({this.id, this.name, this.slug, this.selected});

  factory Topics.fromJson(Map<String, dynamic> json) => _$TopicsFromJson(json);

  Map<String, dynamic> toJson() => _$TopicsToJson(this);

  @override
  String toString() {
    return 'Topics{id: $id, name: $name, slug: $slug, selected: $selected}';
  }
}
