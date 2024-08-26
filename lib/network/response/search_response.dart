class SearchResponse {
  int? sTATUS;
  String? mESSAGE;
  DATA? dATA;

  SearchResponse({this.sTATUS, this.mESSAGE, this.dATA});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
    dATA = json['DATA'] != null ? new DATA.fromJson(json['DATA']) : null;
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

class DATA {
  List<Newspaper>? magazines;
  List<Newspaper>? newspaper;
  List<PopularContent>? popularContent;
  List<PopularContent>? topStory;

  DATA({this.magazines, this.newspaper, this.popularContent, this.topStory});

  DATA.fromJson(Map<String, dynamic> json) {
    if (json['magazines'] != null) {
      magazines = <Newspaper>[];
      json['magazines'].forEach((v) {
        magazines!.add(new Newspaper.fromJson(v));
      });
    }
    if (json['newspaper'] != null) {
      newspaper = <Newspaper>[];
      json['newspaper'].forEach((v) {
        newspaper!.add(new Newspaper.fromJson(v));
      });
    }
    if (json['popular_content'] != null) {
      popularContent = <PopularContent>[];
      json['popular_content'].forEach((v) {
        popularContent!.add(new PopularContent.fromJson(v));
      });
    }
    if (json['top_story'] != null) {
      topStory = <PopularContent>[];
      json['top_story'].forEach((v) {
        topStory!.add(new PopularContent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.magazines != null) {
      data['magazines'] = this.magazines!.map((v) => v.toJson()).toList();
    }
    if (this.newspaper != null) {
      data['newspaper'] = this.newspaper!.map((v) => v.toJson()).toList();
    }
    if (this.popularContent != null) {
      data['popular_content'] =
          this.popularContent!.map((v) => v.toJson()).toList();
    }
    if (this.topStory != null) {
      data['top_story'] = this.topStory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Newspaper {
  int? id;
  String? title;
  String? price;
  String? thumbnailImage;
  String? coverImage;
  String? currency;
  String? type;

  Newspaper(
      {this.id,
        this.title,
        this.price,
        this.thumbnailImage,
        this.coverImage,
        this.currency,
        this.type});

  Newspaper.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    thumbnailImage = json['thumbnail_image'];
    coverImage = json['cover_image'];
    currency = json['currency'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['thumbnail_image'] = this.thumbnailImage;
    data['cover_image'] = this.coverImage;
    data['currency'] = this.currency;
    data['type'] = this.type;
    return data;
  }
}

class PopularContent {
  int? id;
  String? title;
  String? slug;
  int? blogCategoryId;
  Null? thumbnailImage;
  String? sliderImage;
  String? contentImage;
  int? promoted;
  int? topStory;
  int? bannerSlider;
  String? shortDescription;
  String? content;
  int? visitCount;
  int? status;
  int? rssFeedId;
  String? rssUstamp;
  int? isPremium;
  String? createdAt;
  String? updatedAt;
  BlogCategory? blogCategory;
  String? date;
  String? currency;
  String? type;

  PopularContent(
      {this.id,
        this.title,
        this.slug,
        this.blogCategoryId,
        this.thumbnailImage,
        this.sliderImage,
        this.contentImage,
        this.promoted,
        this.topStory,
        this.bannerSlider,
        this.shortDescription,
        this.content,
        this.visitCount,
        this.status,
        this.rssFeedId,
        this.rssUstamp,
        this.isPremium,
        this.createdAt,
        this.updatedAt,
        this.blogCategory,
        this.date,
        this.currency,
        this.type});

  PopularContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    blogCategoryId = json['blog_category_id'];
    thumbnailImage = json['thumbnail_image'];
    sliderImage = json['slider_image'];
    contentImage = json['content_image'];
    promoted = json['promoted'];
    topStory = json['top_story'];
    bannerSlider = json['banner_slider'];
    shortDescription = json['short_description'];
    content = json['content'];
    visitCount = json['visit_count'];
    status = json['status'];
    rssFeedId = json['rss_feed_id'];
    rssUstamp = json['rss_ustamp'];
    isPremium = json['is_premium'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    blogCategory = json['blog_category'] != null
        ? new BlogCategory.fromJson(json['blog_category'])
        : null;
    date = json['date'];
    currency = json['currency'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['blog_category_id'] = this.blogCategoryId;
    data['thumbnail_image'] = this.thumbnailImage;
    data['slider_image'] = this.sliderImage;
    data['content_image'] = this.contentImage;
    data['promoted'] = this.promoted;
    data['top_story'] = this.topStory;
    data['banner_slider'] = this.bannerSlider;
    data['short_description'] = this.shortDescription;
    data['content'] = this.content;
    data['visit_count'] = this.visitCount;
    data['status'] = this.status;
    data['rss_feed_id'] = this.rssFeedId;
    data['rss_ustamp'] = this.rssUstamp;
    data['is_premium'] = this.isPremium;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.blogCategory != null) {
      data['blog_category'] = this.blogCategory!.toJson();
    }
    data['date'] = this.date;
    data['currency'] = this.currency;
    data['type'] = this.type;
    return data;
  }
}

class BlogCategory {
  int? id;
  String? name;
  String? slug;
  int? status;
  String? createdAt;
  String? updatedAt;

  BlogCategory(
      {this.id,
        this.name,
        this.slug,
        this.status,
        this.createdAt,
        this.updatedAt});

  BlogCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}