import 'package:graphics_news/network/response/home_response.dart';

class NewsListingResponse {
  int? sTATUS;
  String? mESSAGE;
  NewsListingDATA? dATA;

  NewsListingResponse({this.sTATUS, this.mESSAGE, this.dATA});

  NewsListingResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];

    dATA = json['DATA'] != null
        ? new NewsListingDATA.fromJson(json['DATA'])
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

class NewsListingDATA {
  List<NewsData>? data;
  List<CategoryListing>? categoryList;
  List<PublicationsList>? publications;

  NewsListingDATA({this.data, this.categoryList, this.publications});

  NewsListingDATA.fromJson(Map<String, dynamic> json) {
    if (json['newspaperdata'] != null) {
      data = [];
      json['newspaperdata'].forEach((v) {
        data!.add(new NewsData.fromJson(v));
      });
    }
    if (json['all_category'] != null || json['all_category'] != []) {
      categoryList = [];
      json['all_category'].forEach((v) {
        categoryList!.add(new CategoryListing.fromJson(v));
      });
    }
    if (json['all_publications'] != null || json['all_publications'] != []) {
      publications = [];
      json['all_publications'].forEach((v) {
        publications!.add(new PublicationsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['newspaperdata'] = this.data!.map((v) => v.toJson()).toList();
    }

    if (this.categoryList != null) {
      data['all_category'] = this.categoryList!.map((v) => v.toJson()).toList();
    }
    if (this.publications != null) {
      data['all_publications'] =
          this.publications!.map((v) => v.toJson()).toList();
    }

    // data['first_page_url'] = this.firstPageUrl;
    // data['from'] = this.from;
    // data['last_page'] = this.lastPage;
    // data['last_page_url'] = this.lastPageUrl;
    // // if (this.links != null) {
    // //   data['links'] = this.links!.map((v) => v.toJson()).toList();
    // // }
    // data['next_page_url'] = this.nextPageUrl;
    // data['path'] = this.path;
    // data['per_page'] = this.perPage;
    // data['prev_page_url'] = this.prevPageUrl;
    // data['to'] = this.to;
    // data['total'] = this.total;
    return data;
  }
}

class NewsData {
  int? id;
  String? title;
  String? shortDescription;
  String? description;
  String? price;
  String? currency;
  String? coverImage;
  String? thumbnailImage;
  Categories? category;
  List<Categories>? tags;
  String? publishedDate;
  String? publishedDateReadable;
  bool? bookmark;
  String? type;

  NewsData(json,
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
      this.publishedDateReadable,
      this.bookmark,
      this.type});

  NewsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shortDescription = json['short_description'];
    description = json['description'];
    price = json['price'];
    currency = json['currency'];
    coverImage = json['cover_image'];
    thumbnailImage = json['thumbnail_image'];
    category = json['category'] != null
        ? new Categories.fromJson(json['category'])
        : null;
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags!.add(new Categories.fromJson(v));
      });
    }
    publishedDate = json['published_date'];
    publishedDateReadable = json['published_date_readable'];
    bookmark = json['bookmark'];
    type = json['type'];
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
    data['bookmark'] = this.bookmark;
    data['type'] = this.type;

    return data;
  }
}

class CategoryListing {
  int? id;
  String? name;
  String? slug;
  // bool isSelected = false;
  CategoryListing({this.id, this.name, this.slug});

  CategoryListing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class PublicationsList {
  int? id;
  String? name;
  String? type;
  int? status;

  PublicationsList({this.id, this.name, this.type, this.status});

  PublicationsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['slug'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.name;
    data['type'] = this.type;
    data['status'] = this.status;
    return data;
  }
}
