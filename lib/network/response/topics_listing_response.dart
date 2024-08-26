class TopicsListingResponse {
  int ?sTATUS;
  String? mESSAGE;
  TopicsDATA ?dATA;

  TopicsListingResponse({this.sTATUS, this.mESSAGE, this.dATA});

  TopicsListingResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
    dATA = json['DATA'] != null ? new TopicsDATA.fromJson(json['DATA']) : null;
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

class TopicsDATA {
  List<Magazines>? magazines;
  List<Magazines> ?newspapers;

  TopicsDATA({this.magazines, this.newspapers});

  TopicsDATA.fromJson(Map<String, dynamic> json) {
    if (json['magazines'] != null) {
      magazines = [];
      json['magazines'].forEach((v) {
        magazines!.add(new Magazines.fromJson(v));
      });
    }
    if (json['newspapers'] != null) {
      newspapers = [];
      json['newspapers'].forEach((v) {
        newspapers!.add(new Magazines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.magazines != null) {
      data['magazines'] = this.magazines!.map((v) => v.toJson()).toList();
    }
    if (this.newspapers != null) {
      data['newspapers'] = this.newspapers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Magazines {
  int ?id;
  String? title;
  String ?shortDescription;
  String ?description;
  String ?price;
  String ?currency;
  String ?coverImage;
  String ?thumbnailImage;
  Category ?category;
  List<Category>? tags;
  String ?publishedDate;
  String ?publishedDateReadable;

  Magazines(
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

  Magazines.fromJson(Map<String, dynamic> json) {
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
  int ?id;
  String? name;
  String ?slug;

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