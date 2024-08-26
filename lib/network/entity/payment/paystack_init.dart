import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

/**
 * Created by Amit Rawat on 12/7/2021.
 */
part 'paystack_init.g.dart';

@JsonSerializable()
class PayStackInit extends CommonDTO {
  PayData? DATA;

  PayStackInit(this.DATA);

  factory PayStackInit.fromJson(Map<String, dynamic> json) =>
      _$PayStackInitFromJson(json);

  Map<String, dynamic> toJson() => _$PayStackInitToJson(this);
}

@JsonSerializable()
class PayData {
  String? amount;
  String? currency;
  Paystack? paystack;

  PayData({this.amount, this.currency, this.paystack});


  factory PayData.fromJson(Map<String, dynamic> json) =>
      _$PayDataFromJson(json);

  Map<String, dynamic> toJson() => _$PayDataToJson(this);
}

@JsonSerializable()
class Paystack {
  String? authorization_url;
  String? access_code;
  String? reference;

  Paystack({this.authorization_url, this.access_code, this.reference});


  factory Paystack.fromJson(Map<String, dynamic> json) =>
      _$PaystackFromJson(json);

  Map<String, dynamic> toJson() => _$PaystackToJson(this);
}
