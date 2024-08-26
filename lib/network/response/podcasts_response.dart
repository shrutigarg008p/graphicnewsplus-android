class PodCastsResponse {
  int ?sTATUS;
  String? mESSAGE;
  PodCastsDATA ?dATA;

  PodCastsResponse({this.sTATUS, this.mESSAGE, this.dATA});

  PodCastsResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
    dATA = json['DATA'] != null ? new PodCastsDATA.fromJson(json['DATA']) : null;
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

class PodCastsDATA {
  int ?currentPage;
  List<PodCastsListing> ?data;
  String ?firstPageUrl;
  int ?from;
  int ?lastPage;
  String? lastPageUrl;
  List<Links> ?links;
  String ? nextPageUrl;
  String ?path;
  int ?perPage;
  String ?prevPageUrl;
  int ?to;
  int ?total;

  PodCastsDATA(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  PodCastsDATA.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data =[];
      json['data'].forEach((v) {
        data!.add(new PodCastsListing.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = [];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class PodCastsListing {
  int ?id;
  String? title;
  String ?thumbnailImage;
  String ?podcastFile;
  String ?date;
  String ?dateReadable;

  PodCastsListing(
      {this.id,
        this.title,
        this.thumbnailImage,
        this.podcastFile,
        this.date,
        this.dateReadable});

  PodCastsListing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    thumbnailImage = json['thumbnail_image'];
    podcastFile = json['podcast_file'];
    date = json['date'];
    dateReadable = json['date_readable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['thumbnail_image'] = this.thumbnailImage;
    data['podcast_file'] = this.podcastFile;
    data['date'] = this.date;
    data['date_readable'] = this.dateReadable;
    return data;
  }
}

class Links {
  String ?url;
  String ?label;
  bool ?active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}