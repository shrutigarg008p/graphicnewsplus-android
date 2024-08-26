import 'package:graphics_news/network/response/category_listing_response.dart';

class PromotedDetailResponse {
  int? sTATUS;
  String? mESSAGE;
  PromotedDetailDATA? dATA;

  PromotedDetailResponse({this.sTATUS, this.mESSAGE, this.dATA});

  PromotedDetailResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
    dATA = json['DATA'] != null
        ? new PromotedDetailDATA.fromJson(json['DATA'])
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

class PromotedDetailDATA {
  List<String>? promoted_ids;
  PromotedContent? promotedContent;
  List<Related>? related;
  PromotedDetailDATA({this.promotedContent});

  PromotedDetailDATA.fromJson(Map<String, dynamic> json) {
    promotedContent = (json['promoted_content'] != null
        ? new PromotedContent.fromJson(json['promoted_content'])
        : null)!;
    if (json['related'] != null) {
      related = <Related>[];
      json['related'].forEach((v) {
        related!.add(new Related.fromJson(v));
      });
    }
    promoted_ids = json['promoted_ids'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.promotedContent != null) {
      data['promoted_content'] = this.promotedContent!.toJson();
    }
    if (this.related != null) {
      data['related'] = this.related!.map((v) => v.toJson()).toList();
    }
    data['promoted_ids'] = this.promoted_ids;
    return data;
  }
}

class PromotedContent {
  int? id;
  String? title;
  String? slug;
  int? blogCategoryId;
  String? thumbnailImage;
  String? contentImage;
  int? promoted;
  int? topStory;
  String? shortDescription;
  String? content;
  BlogCategory? blogCategory;
  List<Category>? tags;
  String? date;
  String? dateReadable;
  bool? bookmark;
  String? type;
  bool? needsSubscription;

  PromotedContent(
      {this.id,
      this.title,
      this.slug,
      this.blogCategoryId,
      this.thumbnailImage,
      this.contentImage,
      this.promoted,
      this.topStory,
      this.shortDescription,
      this.content,
      this.blogCategory,
      this.tags,
      this.date,
      this.dateReadable,
      this.bookmark,
      this.type,
      this.needsSubscription});

  PromotedContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    blogCategoryId = json['blog_category_id'];
    thumbnailImage = json['thumbnail_image'];
    contentImage = json['content_image'];
    promoted = json['promoted'];
    topStory = json['top_story'];
    shortDescription = json['short_description'];
    content = json['content'];
    blogCategory = json['blog_category'] != null
        ? new BlogCategory.fromJson(json['blog_category'])
        : null;
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags!.add(new Category.fromJson(v));
      });
    }
    date = json['date'];
    dateReadable = json['date_readable'];
    bookmark = json['bookmark'];
    type = json['type'];
    needsSubscription = json['needs_subscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['blog_category_id'] = this.blogCategoryId;
    data['thumbnail_image'] = this.thumbnailImage;
    data['content_image'] = this.contentImage;
    data['promoted'] = this.promoted;
    data['top_story'] = this.topStory;
    data['short_description'] = this.shortDescription;
    data['content'] = this.content;
    if (this.blogCategory != null) {
      data['blog_category'] = this.blogCategory!.toJson();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    data['date'] = this.date;
    data['date_readable'] = this.dateReadable;
    data['bookmark'] = this.bookmark;
    data['type'] = this.type;
    data['needs_subscription'] = this.needsSubscription;
    
    return data;
  }
}

class BlogCategory {
  int? id;
  String? name;
  String? slug;

  BlogCategory({this.id, this.name, this.slug});

  BlogCategory.fromJson(Map<String, dynamic> json) {
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

class Related {
  int? id;
  String? title;
  String? slug;
  int? blogCategoryId;
  String? thumbnailImage;
  String? contentImage;
  int? promoted;
  int? topStory;
  String? shortDescription;
  String? content;
  BlogCategory? blogCategory;
  List<Category>? tags;
  String? date;
  String? dateReadable;

  Related(
      {this.id,
      this.title,
      this.slug,
      this.blogCategoryId,
      this.thumbnailImage,
      this.contentImage,
      this.promoted,
      this.topStory,
      this.shortDescription,
      this.content,
      this.blogCategory,
      this.tags,
      this.date,
      this.dateReadable});

  Related.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    blogCategoryId = json['blog_category_id'];
    thumbnailImage = json['thumbnail_image'];
    contentImage = json['content_image'];
    promoted = json['promoted'];
    topStory = json['top_story'];
    shortDescription = json['short_description'];
    content = json['content'];
    blogCategory = json['blog_category'] != null
        ? new BlogCategory.fromJson(json['blog_category'])
        : null;
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags!.add(new Category.fromJson(v));
      });
    }
    date = json['date'];
    dateReadable = json['date_readable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['blog_category_id'] = this.blogCategoryId;
    data['thumbnail_image'] = this.thumbnailImage;
    data['content_image'] = this.contentImage;
    data['promoted'] = this.promoted;
    data['top_story'] = this.topStory;
    data['short_description'] = this.shortDescription;
    data['content'] = this.content;
    if (this.blogCategory != null) {
      data['blog_category'] = this.blogCategory!.toJson();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    data['date'] = this.date;
    data['date_readable'] = this.dateReadable;
    return data;
  }
}
