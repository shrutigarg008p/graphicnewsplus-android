class ContactUsResponse {
  int? sTATUS;
  String? MESSAGE;

  ContactUsResponse({this.sTATUS, this.MESSAGE});

  ContactUsResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    MESSAGE = json['MESSAGE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATUS'] = this.sTATUS;
    data['MESSAGE'] = this.MESSAGE;
    return data;
  }
}
