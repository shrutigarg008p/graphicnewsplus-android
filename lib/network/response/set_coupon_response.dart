import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'set_coupon_response.g.dart';

@JsonSerializable()
class SetCouponResponse extends CommonDTO {
  SetCouponData? DATA;

  SetCouponResponse({this.DATA});

  factory SetCouponResponse.fromJson(Map<String, dynamic> json) =>
      _$SetCouponResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SetCouponResponseToJson(this);
}

@JsonSerializable()
class SetCouponData {
  String? amount;
  SetCouponData({this.amount});
  factory SetCouponData.fromJson(Map<String, dynamic> json) =>
      _$SetCouponDataFromJson(json);

  Map<String, dynamic> toJson() => _$SetCouponDataToJson(this);
}
