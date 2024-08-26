class AboutUsResponse {
  int ?sTATUS;
  String? mESSAGE;
  String ?dATA;

  AboutUsResponse({this.sTATUS, this.mESSAGE, this.dATA});

  AboutUsResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
    dATA = json['DATA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATUS'] = this.sTATUS;
    data['MESSAGE'] = this.mESSAGE;
    data['DATA'] = this.dATA;
    return data;
  }
}
