class ForgetResponse {
  int ?sTATUS;
  String? mESSAGE;

  ForgetResponse({this.sTATUS, this.mESSAGE});

  ForgetResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATUS'] = this.sTATUS;
    data['MESSAGE'] = this.mESSAGE;
    return data;
  }
}

