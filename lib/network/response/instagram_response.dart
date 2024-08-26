//import 'package:graphics_news/network/response/home_response.dart';

class InstagramResponse {
  int? sTATUS;
  String? mESSAGE;
  List<InstagramListingDATA>? dATA;

  InstagramResponse({this.sTATUS, this.mESSAGE, this.dATA});

  InstagramResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
    if (json['DATA'] != null) {
      dATA = [];
      json['DATA'].forEach((v) {
        dATA!.add(new InstagramListingDATA.fromJson(v));
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

class InstagramListingDATA {
  String? id;
  String? caption;
  String? media_type;
  String? media_url;
  String? permalink;
  String? thumbnailUrl;
  String? username;
  String? timestamp;

  InstagramListingDATA(
      {this.id,
      this.caption,
      this.media_type,
      this.media_url,
      this.permalink,
      this.thumbnailUrl,
      this.username,
      this.timestamp});

  InstagramListingDATA.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    caption = json['caption'];
    media_type = json['media_type'];
    media_url = json['media_url'];
    permalink = json['permalink'];
    thumbnailUrl = json['thumbnail_url'];
    timestamp = json['timestamp'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['caption'] = this.caption;
    print("---------Testing Json--------5");

    data['media_type'] = this.media_type;
    data['media_url'] = this.media_url;
    data['permalink'] = this.permalink;
    data['thumbnail_url'] = this.thumbnailUrl;
    // data['timestamp'] = this.timestamp;
    data['username'] = this.username;
    return data;
  }
}
