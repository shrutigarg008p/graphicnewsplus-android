import 'package:graphics_news/network/common/common_dto.dart';
import 'package:json_annotation/json_annotation.dart';

/**
 * Created by Amit Rawat on 11/8/2021.
 */
part 'auth_dto.g.dart';

@JsonSerializable()
class AuthDTO extends CommonDTO {
  DataUser? DATA;

  AuthDTO(this.DATA);

  factory AuthDTO.fromJson(Map<String, dynamic> json) =>
      _$AuthDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AuthDTOToJson(this);
}

@JsonSerializable()
class DataUser {
  @JsonKey(name: "access_token")
  String? accessToken;

  @JsonKey(name: "token_type")
  String? tokenType;

  @JsonKey(name: "expires_in")
  int? expiresIn;

  @JsonKey(name: "user")
  User? user;


  @JsonKey(name: "push_enabled")
  bool? notification;

  String? dob_required;
  String? gender_required;

  DataUser(
      {this.accessToken,
      this.tokenType,
      this.expiresIn,
      this.user,
      this.notification});

  factory DataUser.fromJson(Map<String, dynamic> json) =>
      _$DataUserFromJson(json);

  Map<String, dynamic> toJson() => _$DataUserToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "first_name")
  String? firstName;

  @JsonKey(name: "last_name")
  String? lastName;

  @JsonKey(name: "role_name")
  String? roleName;

  @JsonKey(name: "phone")
  String? phone;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "dob")
  String? dob;

  @JsonKey(name: "country")
  String? country;

  @JsonKey(name: "email_verified_at")
  String? emailVerifiedAt;

  @JsonKey(name: "refer_code")
  String? referCode;

  @JsonKey(name: "gender")
  String? gender;

  @JsonKey(name: "social_login")
  bool? social_login;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.roleName,
      this.phone,
      this.email,
      this.dob,
      this.country,
      this.emailVerifiedAt,
      this.referCode,
      this.gender,
      this.social_login});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

