class SocialLoginReq {
  String name;
  String email;
  String social_id;
  String platform;
  String device_id;
  String gender;
  String dob;
  String countryCode;
  String phone;
  String referCode;
  String referredFrom;

  SocialLoginReq(
      this.name,
      this.email,
      this.social_id,
      this.platform,
      this.device_id,
      this.dob,
      this.countryCode,
      this.gender,
      this.phone,
      this.referCode,
      this.referredFrom);
}
