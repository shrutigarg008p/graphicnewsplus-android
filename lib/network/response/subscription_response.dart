import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_response.g.dart';

@JsonSerializable()
class SubscriptionResponse extends CommonDTO {
  List<SubscriptionData>? DATA;

  SubscriptionResponse({this.DATA});

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionResponseToJson(this);
}

@JsonSerializable()
class SubscriptionData {
  int? key;
  String? value;
  String? type;
  String? description;
  String? apple_product_id;
  String? apple_family_product_id;
  Duration? duration;
  String? amount;
  bool? family;
  String? referral_code;
  String? via_referral_code;
  Members? members;
  String? subscribed;
  String? expired;
  String? payment_method;
  String? currency;
  String? cancel_description;
  bool? cancel_status;
  bool? via_referral;
  int? reference_id;
  int? renew;
  SubscriptionData(
      {this.key,
      this.value,
      this.type,
      this.description,
      this.apple_product_id,
      this.apple_family_product_id,
      this.duration,
      this.amount,
      this.family,
      this.referral_code,
      this.via_referral_code,
      this.members,
      this.subscribed,
      this.expired,
      this.payment_method,
      this.currency,
      this.cancel_description,
      this.cancel_status,
      this.via_referral,
      this.reference_id,
      this.renew});

  factory SubscriptionData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDataFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionDataToJson(this);
}

@JsonSerializable()
class Duration {
  String? key;
  String? value;

  Duration({this.key, this.value});

  Duration.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
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
