
import 'package:graphics_news/network/response/home_response.dart';

class VideoDetailResponse {
  int? sTATUS;
  String? mESSAGE;
  Videos? dATA;

  VideoDetailResponse({this.sTATUS, this.mESSAGE, this.dATA});

  VideoDetailResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
    dATA = json['DATA'] != null ? new Videos.fromJson(json['DATA']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATUS'] = this.sTATUS;
    data['MESSAGE'] = this.mESSAGE;
    if (this.dATA != null) {
      data['DATA'] = this.dATA!.toJson();
    }
    return data;
  }
}