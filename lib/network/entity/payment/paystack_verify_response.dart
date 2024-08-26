import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paystack_verify_response.g.dart';

@JsonSerializable()
class PayStackVerifyResponse extends CommonDTO {
  PayStackVerifyData DATA;
  PayStackVerifyResponse(this.DATA);

  factory PayStackVerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$PayStackVerifyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PayStackVerifyResponseToJson(this);
}

@JsonSerializable()
class PayStackVerifyData {
  int? key;
  String? value;
  String? type;
  String? description;
  TimeDuration? duration;
  String? amount;
  bool? family;
  String? referral_code;
  Members? members;
  String? subscribed;
  String? expired;
  String? paymentMethod;
  PayStackVerifyData(
      {this.key,
      this.value,
      this.type,
      this.description,
      this.duration,
      this.amount,
      this.family,
      this.referral_code,
      this.members,
      this.subscribed,
      this.expired,
      this.paymentMethod});
  factory PayStackVerifyData.fromJson(Map<String, dynamic> json) =>
      _$PayStackVerifyDataFromJson(json);

  Map<String, dynamic> toJson() => _$PayStackVerifyDataToJson(this);
}

@JsonSerializable()
class TimeDuration {
  String? key;
  String? value;

  TimeDuration({this.key, this.value});
  factory TimeDuration.fromJson(Map<String, dynamic> json) =>
      _$TimeDurationFromJson(json);

  Map<String, dynamic> toJson() => _$TimeDurationToJson(this);
}

@JsonSerializable()
class Members {
  int? total;
  List<String>? emails;

  Members({
    this.total,
    this.emails,
  });

  factory Members.fromJson(Map<String, dynamic> json) =>
      _$MembersFromJson(json);

  Map<String, dynamic> toJson() => _$MembersToJson(this);
}
