// ignore_for_file: empty_constructor_bodies

class LogoutResponse {
  int? sTATUS;
  String? mESSAGE;

  LogoutResponse({this.sTATUS, this.mESSAGE});
  LogoutResponse.fromJson(Map<String, dynamic> json) {
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
