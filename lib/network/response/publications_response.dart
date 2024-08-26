import 'package:graphics_news/network/response/news_listing_response.dart';

class PublicationsResponse {
  int? sTATUS;
  String? mESSAGE;
  List<PublicationsList>? dATA;

  PublicationsResponse({this.sTATUS, this.mESSAGE, this.dATA});

  PublicationsResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
    if (json['DATA'] != null) {
      dATA = [];
      json['DATA'].forEach((v) {
        dATA!.add(new PublicationsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATUS'] = this.sTATUS;
    data['MESSAGE'] = this.mESSAGE;
    if (this.dATA != null) {
      data['DATA'] = this.dATA!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
