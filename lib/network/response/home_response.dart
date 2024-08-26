import 'package:graphics_news/network/response/hompage/Ads.dart';
import 'package:graphics_news/network/response/hompage/slider_dto.dart';
import 'package:graphics_news/network/response/instagram_response.dart';

class HomeResponse {
  int? sTATUS;
  String? mESSAGE;
  HomeDATA? dATA;

  HomeResponse({this.sTATUS, this.mESSAGE, this.dATA});

  HomeResponse.fromJson(Map<String, dynamic> json) {
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
    dATA = json['DATA'] != null ? new HomeDATA.fromJson(json['DATA']) : null;
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

class HomeDATA {
  List<Positions>? positions;
  List<Galleries>? galleries;
  List<Albums>? albums;
  List<Podcasts>? podcasts;
  List<Videos>? videos;
  List<Categories>? categories;
  List<Categories>? unpopularCategories;
  List<Newspapers>? newspapers;
  List<Newspapers>? magazines;
  List<PopularContents>? popularContents;
  List<PopularContents>? topStories;
  List<Categories>? topics;
  Ads? ads;
  AdsScreens? adsScreens;
  List<SliderDTO>? slider;
  bool? subscribe;
  TrendingNews? trendingnews;
  List<InstagramListingDATA>? instagramData;

  HomeDATA(
      {this.positions,
      this.galleries,
      this.albums,
      this.podcasts,
      this.videos,
      this.categories,
      this.unpopularCategories,
      this.newspapers,
      this.magazines,
      this.popularContents,
      this.topStories,
      this.ads,
      this.adsScreens,
      this.topics,
      this.subscribe,
      this.trendingnews,
      this.instagramData});

  HomeDATA.fromJson(Map<String, dynamic> json) {
    if (json['trending_news'] != null) {
      trendingnews = TrendingNews.fromJson(json['trending_news']);
    }
    if (json['positions'] != null) {
      positions = [];
      json['positions'].forEach((v) {
        positions!.add(new Positions.fromJson(v));
      });
    }
    if (json['galleries'] != null) {
      galleries = [];
      json['galleries'].forEach((v) {
        galleries!.add(new Galleries.fromJson(v));
      });
    }
    if (json['albums'] != null) {
      albums = <Albums>[];
      json['albums'].forEach((v) {
        albums!.add(new Albums.fromJson(v));
      });
    }
    if (json['podcasts'] != null) {
      podcasts = [];
      json['podcasts'].forEach((v) {
        podcasts!.add(new Podcasts.fromJson(v));
      });
    }
    if (json['videos'] != null) {
      videos = [];
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    if (json['unpopular_categories'] != null) {
      unpopularCategories = [];
      json['unpopular_categories'].forEach((v) {
        unpopularCategories!.add(new Categories.fromJson(v));
      });
    }
    if (json['newspapers'] != null) {
      newspapers = [];
      json['newspapers'].forEach((v) {
        newspapers!.add(new Newspapers.fromJson(v));
      });
    }
    if (json['magazines'] != null) {
      magazines = [];
      json['magazines'].forEach((v) {
        magazines!.add(new Newspapers.fromJson(v));
      });
    }
    if (json['popular_contents'] != null) {
      popularContents = [];
      json['popular_contents'].forEach((v) {
        popularContents!.add(new PopularContents.fromJson(v));
      });
    }
    if (json['top_stories'] != null) {
      topStories = [];
      json['top_stories'].forEach((v) {
        topStories!.add(new PopularContents.fromJson(v));
      });
    }
    if (json['topics'] != null) {
      topics = [];
      json['topics'].forEach((v) {
        topics!.add(new Categories.fromJson(v));
      });
    }
    ads = json['ads'] != null ? new Ads.fromJson(json['ads']) : null;
    adsScreens = json['adsScreens'] != null
        ? new AdsScreens.fromJson(json['adsScreens'])
        : null;
    if (json['slider'] != null) {
      slider = [];
      json['slider'].forEach((v) {
        slider!.add(new SliderDTO.fromJson(v));
      });
    }

    if (json['instagramFeed'] != null) {
      instagramData = [];
      json['instagramFeed'].forEach((v) {
        instagramData!.add(new InstagramListingDATA.fromJson(v));
      });
    }
    subscribe = json['subscribe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.positions != null) {
      data['positions'] = this.positions!.map((v) => v.toJson()).toList();
    }
    if (this.trendingnews != null) {
      data['trending_news'] = this.trendingnews?.toJson();
    }
    if (this.galleries != null) {
      data['galleries'] = this.galleries!.map((v) => v.toJson()).toList();
    }
    if (this.albums != null) {
      data['albums'] = this.albums!.map((v) => v.toJson()).toList();
    }
    if (this.podcasts != null) {
      data['podcasts'] = this.podcasts!.map((v) => v.toJson()).toList();
    }
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.unpopularCategories != null) {
      data['unpopular_categories'] =
          this.unpopularCategories!.map((v) => v.toJson()).toList();
    }
    if (this.newspapers != null) {
      data['newspapers'] = this.newspapers!.map((v) => v.toJson()).toList();
    }
    if (this.magazines != null) {
      data['magazines'] = this.magazines!.map((v) => v.toJson()).toList();
    }
    if (this.popularContents != null) {
      data['popular_contents'] =
          this.popularContents!.map((v) => v.toJson()).toList();
    }
    if (this.topStories != null) {
      data['top_stories'] = this.topStories!.map((v) => v.toJson()).toList();
    }
    if (this.ads != null) {
      data['ads'] = this.ads!.toJson();
    }
    if (this.adsScreens != null) {
      data['adsScreens'] = this.adsScreens!.toJson();
    }
    if (this.topics != null) {
      data['topics'] = this.topics!.map((v) => v.toJson()).toList();
    }

    if (this.instagramData != null) {
      data['instagramFeed'] =
          this.instagramData!.map((v) => v.toJson()).toList();
      print("-------P-------");
      print(data['instagramFeed']);
    }

    data['subscribe'] = this.subscribe;
    return data;
  }
}

class Albums {
  int? id;
  String? title;
  String? description;
  int? status;
  String? image;
  String? date;
  String? dateReadable;
  int? imageCount;

  Albums(
      {this.id,
      this.title,
      this.description,
      this.status,
      this.image,
      this.date,
      this.dateReadable,
      this.imageCount});

  Albums.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    image = json['image'];
    date = json['date'];
    dateReadable = json['date_readable'];
    imageCount = json['image_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['image'] = this.image;
    data['date'] = this.date;
    data['date_readable'] = this.dateReadable;
    data['image_count'] = this.imageCount;
    return data;
  }
}

class AdsScreens {
  List<String>? mediumads;
  List<String>? fullads;
  List<String>? bannerads;

  AdsScreens({this.mediumads,this.fullads, this.bannerads});

  AdsScreens.fromJson(Map<String, dynamic> json) {
    mediumads = json['mediumads'].cast<String>();
    fullads = json['fullads'].cast<String>();
    bannerads = json['bannerads'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediumads'] = this.mediumads;
    data['fullads'] = this.fullads;
    data['bannerads'] = this.bannerads;
    return data;
  }
}

class Positions {
  int? id;
  String? section;
  String? position;
  String? createdAt;
  String? updatedAt;

  Positions(
      {this.id, this.section, this.position, this.createdAt, this.updatedAt});

  Positions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    section = json['section'];
    position = json['position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['section'] = this.section;
    data['position'] = this.position;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Galleries {
  int? id;
  String? title;
  String? image;
  String? link;

  Galleries({this.id, this.title, this.image, this.link});

  Galleries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['link'] = this.link;
    return data;
  }
}

class Podcasts {
  int? id;
  String? title;
  String? thumbnailImage;
  String? podcastFile;
  String? date;
  String? dateReadable;

  Podcasts(
      {this.id,
      this.title,
      this.thumbnailImage,
      this.podcastFile,
      this.date,
      this.dateReadable});

  Podcasts.fromJson(Map<String, dynamic> json) {
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

class Videos {
  int? id;
  String? title;
  String? thumbnailImage;
  String? videoFile;
  String? videoLink;
  String? date;
  String? dateReadable;

  Videos(
      {this.id,
      this.title,
      this.thumbnailImage,
      this.videoFile,
      this.videoLink,
      this.date,
      this.dateReadable});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    thumbnailImage = json['thumbnail_image'];
    videoFile = json['video_file'];
    videoLink = json['video_link'];
    date = json['date'];
    dateReadable = json['date_readable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['thumbnail_image'] = this.thumbnailImage;
    data['video_file'] = this.videoFile;
    data['video_link'] = this.videoLink;
    data['date'] = this.date;
    data['date_readable'] = this.dateReadable;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? slug;

  Categories({this.id, this.name, this.slug});

  Categories.fromJson(Map<String, dynamic> json) {
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

class Newspapers {
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

  Newspapers(
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

  Newspapers.fromJson(Map<String, dynamic> json) {
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

class PopularContents {
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
  Categories? blogCategory;
  List<Categories>? tags;
  String? date;
  String? dateReadable;
  String? type;

  PopularContents(
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
      this.type});

  PopularContents.fromJson(Map<String, dynamic> json) {
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
        ? new Categories.fromJson(json['blog_category'])
        : null;
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags!.add(new Categories.fromJson(v));
      });
    }
    date = json['date'];
    dateReadable = json['date_readable'];
    type = json['type'];
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
    data['type'] = this.type;
    return data;
  }
}

class TrendingNews {
  String? title;

  TrendingNews(this.title);

  TrendingNews.fromJson(Map<String, dynamic> json) {
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    return data;
  }
}
