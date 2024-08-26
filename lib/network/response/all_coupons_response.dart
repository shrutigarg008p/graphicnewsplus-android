import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'all_coupons_response.g.dart';

@JsonSerializable()
class AllCouponsResponse extends CommonDTO {
  List<AllCouponsData>? DATA;

  AllCouponsResponse({this.DATA});

  factory AllCouponsResponse.fromJson(Map<String, dynamic> json) =>
      _$AllCouponsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllCouponsResponseToJson(this);
}

@JsonSerializable()
class AllCouponsData {
  int? id;
  dynamic? user_id;
  String? code;
  String? type;
  String? status;
  String? title;
  dynamic? description;
  String? discount;
  int? used_times;
  int? valid_for;
  String? created_at;
  String? updated_at;

  AllCouponsData(
      {this.id,
      this.user_id,
      this.code,
      this.type,
      this.status,
      this.title,
      this.description,
      this.discount,
      this.used_times,
      this.valid_for,
      this.created_at,
      this.updated_at});
  factory AllCouponsData.fromJson(Map<String, dynamic> json) =>
      _$AllCouponsDataFromJson(json);

  Map<String, dynamic> toJson() => _$AllCouponsDataToJson(this);
}
