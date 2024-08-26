class MagazineListingResponse {
  int? sTATUS;
  String? mESSAGE;
  MagazineListingDATA? dATA;

  MagazineListingResponse({this.sTATUS, this.mESSAGE, this.dATA});

  MagazineListingResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
    dATA = json['DATA'] != null
        ? new MagazineListingDATA.fromJson(json['DATA'])
        : null;
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

class MagazineListingDATA {
  int? currentPage;
  List<MagazineData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  MagazineListingDATA(
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

  MagazineListingDATA.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new MagazineData.fromJson(v));
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

class MagazineData {
  int? id;
  String? title;
  String? shortDescription;
  String? description;
  String? price;
  String? currency;
  String? coverImage;
  String? thumbnailImage;
  Category? category;
  List<Category>? tags;
  String? publishedDate;
  String? publishedDateReadable;

  MagazineData(
      {this.id,
      this.title,
      this.shortDescription,
      this.description,
      this.price,
      this.currency,
      this.coverImage,
      this.thumbnailImage,
      this.category,
      this.tags,
      this.publishedDate,
      this.publishedDateReadable});

  MagazineData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shortDescription = json['short_description'];
    description = json['description'];
    price = json['price'];
    currency = json['currency'];
    coverImage = json['cover_image'];
    thumbnailImage = json['thumbnail_image'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags!.add(new Category.fromJson(v));
      });
    }
    publishedDate = json['published_date'];
    publishedDateReadable = json['published_date_readable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['short_description'] = this.shortDescription;
    data['description'] = this.description;
    data['price'] = this.price;
    data['currency'] = this.currency;
    data['cover_image'] = this.coverImage;
    data['thumbnail_image'] = this.thumbnailImage;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    data['published_date'] = this.publishedDate;
    data['published_date_readable'] = this.publishedDateReadable;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? slug;

  Category({this.id, this.name, this.slug});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

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
