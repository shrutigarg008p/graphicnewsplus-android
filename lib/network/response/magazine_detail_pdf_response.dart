class MagazineDetailPdfResponse {
  int? sTATUS;
  String? mESSAGE;
  MagazineDetailPdfDATA? dATA;

  MagazineDetailPdfResponse({this.sTATUS, this.mESSAGE, this.dATA});

  MagazineDetailPdfResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
    dATA = json['DATA'] != null
        ? new MagazineDetailPdfDATA.fromJson(json['DATA'])
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

class MagazineDetailPdfDATA {
  Posts? post;
  List<Related>? related;
  List<TopStories>? topStories;
  String? flipData;
  Pdf? pdf;
  int? pdfcount;
  bool? isold;
  String? weburl;

  MagazineDetailPdfDATA(
      {this.post,
      this.related,
      this.topStories,
      this.flipData,
      this.pdf,
      this.pdfcount,
      this.isold,
      this.weburl});

  MagazineDetailPdfDATA.fromJson(Map<String, dynamic> json) {
    post = json['post'] != null ? new Posts.fromJson(json['post']) : null;
    if (json['related'] != null) {
      related = [];
      json['related'].forEach((v) {
        related!.add(new Related.fromJson(v));
      });
    }
    if (json['top_stories'] != null) {
      topStories = [];
      json['top_stories'].forEach((v) {
        topStories!.add(new TopStories.fromJson(v));
      });
    }
    flipData = json['Flip Data'];
    pdf = json['Pdf'] != null ? new Pdf.fromJson(json['Pdf']) : null;

    pdfcount = json['PdfCount'];
    isold = json['is_old'];
    weburl = json['web_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.post != null) {
      data['post'] = this.post!.toJson();
    }
    if (this.related != null) {
      data['related'] = this.related!.map((v) => v.toJson()).toList();
    }
    if (this.topStories != null) {
      data['top_stories'] = this.topStories!.map((v) => v.toJson()).toList();
    }
    data['Flip Data'] = this.flipData;
    if (this.pdf != null) {
      data['Pdf'] = this.pdf!.toJson();
    }
    data['is_old'] = this.isold;

    data['PdfCount'] = this.pdfcount;
    data['web_url'] = this.weburl;

    return data;
  }
}

class Posts {
  int? id;
  int? uId;
  String? title;
  String? shortDescription;
  String? description;
  String? price;
  String? coverImage;
  String? thumbnailImage;
  String? coverImageLink;
  String? thumbnailImageLink;
  Category? category;
  Publication? publication;
  List<Category>? tags;
  String? publishedDate;
  String? publishedDateReadable;
  int? totalDownloads;
  int? todaysDownloads;
  String? currency;
  bool? subscribed;
  bool? bookmark;
  bool? gridView;
  String? type;
  String? apple_product_id;
  bool? isfreeplanenabled;
  Posts(
      {this.id,
      this.uId,
      this.title,
      this.shortDescription,
      this.description,
      this.price,
      this.coverImage,
      this.thumbnailImage,
      this.thumbnailImageLink,
      this.coverImageLink,
      this.category,
      this.publication,
      this.tags,
      this.publishedDate,
      this.publishedDateReadable,
      this.totalDownloads,
      this.todaysDownloads,
      this.currency,
      this.subscribed,
      this.bookmark,
      this.gridView,
      this.type,
      this.apple_product_id,
      this.isfreeplanenabled});

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uId = json['u_id'];
    title = json['title'];
    apple_product_id = json['apple_product_id'];
    shortDescription = json['short_description'];
    description = json['description'];
    price = json['price'];
    coverImage = json['cover_image'];
    thumbnailImage = json['thumbnail_image'];
    isfreeplanenabled = json['free_plan_enable'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    publication = json['publication'] != null
        ? new Publication.fromJson(json['publication'])
        : null;
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags!.add(new Category.fromJson(v));
      });
    }
    publishedDate = json['published_date'];
    publishedDateReadable = json['published_date_readable'];
    totalDownloads = json['total_downloads'];
    todaysDownloads = json['todays_downloads'];
    currency = json['currency'];
    subscribed = json['subscribed'];
    coverImageLink = json['cover_image_link'];
    thumbnailImageLink = json['thumbnail_image_link'];
    bookmark = json['bookmark'];
    gridView = json['grid_view'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['u_id'] = this.uId;
    data['title'] = this.title;
    data['apple_product_id'] = this.apple_product_id;
    data['short_description'] = this.shortDescription;
    data['description'] = this.description;
    data['price'] = this.price;
    data['cover_image'] = this.coverImage;
    data['thumbnail_image'] = this.thumbnailImage;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.publication != null) {
      data['publication'] = this.publication!.toJson();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    data['published_date'] = this.publishedDate;
    data['published_date_readable'] = this.publishedDateReadable;
    data['total_downloads'] = this.totalDownloads;
    data['todays_downloads'] = this.todaysDownloads;
    data['currency'] = this.currency;
    data['subscribed'] = this.subscribed;
    data['cover_image_link'] = this.coverImageLink;
    data['thumbnail_image_link'] = this.thumbnailImageLink;
    data['bookmark'] = this.bookmark;
    data['grid_view'] = this.gridView;
    data['type'] = this.type;
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

class Publication {
  int? id;
  String? name;
  String? type;
  int? status;

  Publication({this.id, this.name, this.type, this.status});

  Publication.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['status'] = this.status;
    return data;
  }
}

class Related {
  int? id;
  int? uId;
  String? title;
  String? shortDescription;
  String? description;
  String? price;
  String? coverImage;
  String? thumbnailImage;
  Category? category;
  Publication? publication;
  List<Category>? tags;
  String? publishedDate;
  String? publishedDateReadable;
  String? currency;
  Related(
      {this.id,
      this.uId,
      this.title,
      this.shortDescription,
      this.description,
      this.price,
      this.coverImage,
      this.thumbnailImage,
      this.category,
      this.publication,
      this.tags,
      this.publishedDate,
      this.publishedDateReadable});

  Related.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uId = json['u_id'];
    title = json['title'];
    shortDescription = json['short_description'];
    description = json['description'];
    price = json['price'];
    coverImage = json['cover_image'];
    thumbnailImage = json['thumbnail_image'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    publication = json['publication'] != null
        ? new Publication.fromJson(json['publication'])
        : null;
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags!.add(new Category.fromJson(v));
      });
    }
    publishedDate = json['published_date'];
    publishedDateReadable = json['published_date_readable'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['u_id'] = this.uId;
    data['title'] = this.title;
    data['short_description'] = this.shortDescription;
    data['description'] = this.description;
    data['price'] = this.price;
    data['cover_image'] = this.coverImage;
    data['thumbnail_image'] = this.thumbnailImage;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.publication != null) {
      data['publication'] = this.publication!.toJson();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    data['published_date'] = this.publishedDate;
    data['published_date_readable'] = this.publishedDateReadable;
    data['currency'] = this.currency;
    return data;
  }
}

class TopStories {
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
  Category? blogCategory;
  List<Category>? tags;
  String? date;
  String? dateReadable;

  TopStories(
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

  TopStories.fromJson(Map<String, dynamic> json) {
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
        ? new Category.fromJson(json['blog_category'])
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

class Pdf {
  int? id;
  String? title;
  String? file;
  String? fileType;

  Pdf({this.id, this.title, this.file, this.fileType});

  Pdf.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    file = json['file'];
    fileType = json['file_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['file'] = this.file;
    data['file_type'] = this.fileType;
    return data;
  }
}
