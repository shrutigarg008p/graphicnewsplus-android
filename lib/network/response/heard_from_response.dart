import 'package:json_annotation/json_annotation.dart';

import '../common/common_dto.dart';

part 'heard_from_response.g.dart';

@JsonSerializable()
class HeardFromResponse extends CommonDTO {
  List<String>? DATA;

  HeardFromResponse({this.DATA});

  factory HeardFromResponse.fromJson(Map<String, dynamic> json) =>
      _$HeardFromResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HeardFromResponseToJson(this);
}


