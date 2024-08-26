// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthDTO _$AuthDTOFromJson(Map<String, dynamic> json) => AuthDTO(
      json['DATA'] == null
          ? null
          : DataUser.fromJson(json['DATA'] as Map<String, dynamic>),
    )
      ..sTATUS = json['STATUS'] as int?
      ..MESSAGE = json['MESSAGE'] as String?;

Map<String, dynamic> _$AuthDTOToJson(AuthDTO instance) => <String, dynamic>{
      'STATUS': instance.sTATUS,
      'MESSAGE': instance.MESSAGE,
      'DATA': instance.DATA,
    };

DataUser _$DataUserFromJson(Map<String, dynamic> json) => DataUser(
      accessToken: json['access_token'] as String?,
      tokenType: json['token_type'] as String?,
      expiresIn: json['expires_in'] as int?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      notification: json['push_enabled'] as bool?,
    )
      ..dob_required = json['dob_required'] as String?
      ..gender_required = json['gender_required'] as String?;

Map<String, dynamic> _$DataUserToJson(DataUser instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'user': instance.user,
      'push_enabled': instance.notification,
      'dob_required': instance.dob_required,
      'gender_required': instance.gender_required,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      roleName: json['role_name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      dob: json['dob'] as String?,
      country: json['country'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      referCode: json['refer_code'] as String?,
      gender: json['gender'] as String?,
      social_login: json['social_login'] as bool?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'role_name': instance.roleName,
      'phone': instance.phone,
      'email': instance.email,
      'dob': instance.dob,
      'country': instance.country,
      'email_verified_at': instance.emailVerifiedAt,
      'refer_code': instance.referCode,
      'gender': instance.gender,
      'social_login': instance.social_login,
    };
