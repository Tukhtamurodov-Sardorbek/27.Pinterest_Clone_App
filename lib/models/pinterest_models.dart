import 'dart:convert';

Pinterest postFromJson(String str) => Pinterest.fromJson(json.decode(str));

String postToJson(Pinterest data) => json.encode(data.toJson());


class Pinterest {
  Pinterest({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.promotedAt,
    required this.width,
    required this.height,
    required this.color,
    required this.blurHash,
    this.description,
    required this.altDescription,
    required this.urls,
    required this.links,
    required this.categories,
    required this.likes,
    required this.likedByUser,
    required this.currentUserCollections,
    this.sponsorship,
    required this.topicSubmissions,
    required this.user,
    // required this.tags
  });

  String id;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? promotedAt;
  int width;
  int height;
  String color;
  String? blurHash;
  String? description;
  dynamic altDescription;
  Urls urls;
  PinterestLinks links;
  List<dynamic> categories;
  int likes;
  bool likedByUser;
  List<dynamic> currentUserCollections;
  Sponsorship? sponsorship;
  TopicSubmissions topicSubmissions;
  User user;
  // List<Tag> tags;

  factory Pinterest.fromJson(Map<String, dynamic> json) => Pinterest(
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    promotedAt: json["promoted_at"] == null
        ? null
        : DateTime.parse(json["promoted_at"]),
    width: json["width"],
    height: json["height"],
    color: json["color"],
    blurHash: json["blur_hash"],
    description: json["description"],
    altDescription: json["alt_description"],
    urls: Urls.fromJson(json["urls"]),
    links: PinterestLinks.fromJson(json["links"]),
    categories: List<dynamic>.from(json["categories"].map((x) => x)),
    likes: json["likes"],
    likedByUser: json["liked_by_user"],
    currentUserCollections:
    List<dynamic>.from(json["current_user_collections"].map((x) => x)),
    sponsorship: json["sponsorship"] == null
        ? null
        : Sponsorship.fromJson(json["sponsorship"]),
    topicSubmissions: TopicSubmissions.fromJson(json["topic_submissions"]),
    user: User.fromJson(json["user"]),
    // tags: List<Tag>.from(json["tags"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "promoted_at":
    promotedAt == null ? null : promotedAt!.toIso8601String(),
    "width": width,
    "height": height,
    "color": color,
    "blur_hash": blurHash,
    "description": description,
    "alt_description": altDescription,
    "urls": urls.toJson(),
    "links": links.toJson(),
    "categories": List<dynamic>.from(categories.map((x) => x)),
    "likes": likes,
    "liked_by_user": likedByUser,
    "current_user_collections":
    List<dynamic>.from(currentUserCollections.map((x) => x)),
    "sponsorship": sponsorship == null ? null : sponsorship!.toJson(),
    "topic_submissions": topicSubmissions.toJson(),
    "user": user.toJson(),
    // 'tags':  List<dynamic>.from(tags.map((x) => x)),
  };

  static  List<Pinterest> pinterestFromJson(String str) =>
      List<Pinterest>.from(json.decode(str).map((x) => Pinterest.fromJson(x)));

  static String pinterestToJson(List<Pinterest> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

}

class PinterestLinks {
  late String self;
  late String html;
  late String download;
  late String downloadLocation;

  PinterestLinks({
    required this.self,
    required this.html,
    required this.download,
    required this.downloadLocation,
  });

  factory PinterestLinks.fromJson(Map<String, dynamic> json) => PinterestLinks(
    self: json["self"],
    html: json["html"],
    download: json["download"],
    downloadLocation: json["download_location"],
  );

  Map<String, dynamic> toJson() => {
    "self": self,
    "html": html,
    "download": download,
    "download_location": downloadLocation,
  };
}

class Sponsorship {
  late List<String> impressionUrls;
  late String? tagline;
  late String? taglineUrl;
  late User sponsor;

  Sponsorship({
    required this.impressionUrls,
    this.tagline,
    this.taglineUrl,
    required this.sponsor,
  });

  factory Sponsorship.fromJson(Map<String, dynamic> json) => Sponsorship(
    impressionUrls:
    List<String>.from(json["impression_urls"].map((x) => x)),
    tagline: json["tagline"],
    taglineUrl: json["tagline_url"],
    sponsor: User.fromJson(json["sponsor"]),
  );

  Map<String, dynamic> toJson() => {
    "impression_urls": List<dynamic>.from(impressionUrls.map((x) => x)),
    "tagline": tagline,
    "tagline_url": taglineUrl,
    "sponsor": sponsor.toJson(),
  };
}

class User {
  User({
    required this.id,
    required this.updatedAt,
    required this.username,
    required this.name,
    required this.firstName,
    this.lastName,
    this.twitterUsername,
    this.portfolioUrl,
    this.bio,
    this.location,
    required this.links,
    required this.profileImage,
    this.instagramUsername,
    required this.totalCollections,
    required this.totalLikes,
    required this.totalPhotos,
    required this.acceptedTos,
    required this.forHire,
    required this.social,
  });

  late String id;
  late DateTime updatedAt;
  late String username;
  late String name;
  late String firstName;
  String? lastName;
  String? twitterUsername;
  String? portfolioUrl;
  String? bio;
  String? location;
  late UserLinks links;
  late ProfileImage profileImage;
  String? instagramUsername;
  late int totalCollections;
  late int totalLikes;
  late int totalPhotos;
  late bool acceptedTos;
  late bool forHire;
  late Social social;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    updatedAt: DateTime.parse(json["updated_at"]),
    username: json["username"],
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    twitterUsername: json["twitter_username"],
    portfolioUrl: json["portfolio_url"],
    bio: json["bio"],
    location: json["location"],
    links: UserLinks.fromJson(json["links"]),
    profileImage: ProfileImage.fromJson(json["profile_image"]),
    instagramUsername: json["instagram_username"],
    totalCollections: json["total_collections"],
    totalLikes: json["total_likes"],
    totalPhotos: json["total_photos"],
    acceptedTos: json["accepted_tos"],
    forHire: json["for_hire"],
    social: Social.fromJson(json["social"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "updated_at": updatedAt.toIso8601String(),
    "username": username,
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "twitter_username": twitterUsername,
    "portfolio_url": portfolioUrl,
    "bio": bio,
    "location": location,
    "links": links.toJson(),
    "profile_image": profileImage.toJson(),
    "instagram_username": instagramUsername,
    "total_collections": totalCollections,
    "total_likes": totalLikes,
    "total_photos": totalPhotos,
    "accepted_tos": acceptedTos,
    "for_hire": forHire,
    "social": social.toJson(),
  };
}

// class Tag{
//   String title;
//   Tag({required this.title});
//
//   factory Tag.fromJson(Map<String, dynamic> json) => Tag(
//     title: json["title"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     'title' : title
//   };
// }

class UserLinks {
  late String self;
  late String html;
  late String photos;
  late String likes;
  late String portfolio;
  late String following;
  late String followers;

  UserLinks({
    required this.self,
    required this.html,
    required this.photos,
    required this.likes,
    required this.portfolio,
    required this.following,
    required this.followers,
  });

  factory UserLinks.fromJson(Map<String, dynamic> json) => UserLinks(
    self: json["self"],
    html: json["html"],
    photos: json["photos"],
    likes: json["likes"],
    portfolio: json["portfolio"],
    following: json["following"],
    followers: json["followers"],
  );

  Map<String, dynamic> toJson() => {
    "self": self,
    "html": html,
    "photos": photos,
    "likes": likes,
    "portfolio": portfolio,
    "following": following,
    "followers": followers,
  };
}

class ProfileImage {
  late String small;
  late String medium;
  late String large;

  ProfileImage({
    required this.small,
    required this.medium,
    required this.large,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
    small: json["small"],
    medium: json["medium"],
    large: json["large"],
  );

  Map<String, dynamic> toJson() => {
    "small": small,
    "medium": medium,
    "large": large,
  };
}

class Social {
  String? instagramUsername;
  String? portfolioUrl;
  String? twitterUsername;
  dynamic paypalEmail;

  Social({
    this.instagramUsername,
    this.portfolioUrl,
    this.twitterUsername,
    this.paypalEmail,
  });

  factory Social.fromJson(Map<String, dynamic> json) => Social(
    instagramUsername: json["instagram_username"],
    portfolioUrl: json["portfolio_url"],
    twitterUsername: json["twitter_username"],
    paypalEmail: json["paypal_email"],
  );

  Map<String, dynamic> toJson() => {
    "instagram_username": instagramUsername,
    "portfolio_url": portfolioUrl,
    "twitter_username": twitterUsername,
    "paypal_email": paypalEmail,
  };
}

class TopicSubmissions {
  Health? people;
  ArtsCulture? fashion;
  Health? health;
  ArtsCulture? film;
  ArtsCulture? spirituality;
  ArtsCulture? artsCulture;

  TopicSubmissions({
    this.people,
    this.fashion,
    this.health,
    this.film,
    this.spirituality,
    this.artsCulture,
  });

  factory TopicSubmissions.fromJson(Map<String, dynamic> json) =>
      TopicSubmissions(
        people: json["people"] == null ? null : Health.fromJson(json["people"]),
        fashion: json["fashion"] == null
            ? null
            : ArtsCulture.fromJson(json["fashion"]),
        health: json["health"] == null ? null : Health.fromJson(json["health"]),
        film: json["film"] == null ? null : ArtsCulture.fromJson(json["film"]),
        spirituality: json["spirituality"] == null
            ? null
            : ArtsCulture.fromJson(json["spirituality"]),
        artsCulture: json["arts-culture"] == null
            ? null
            : ArtsCulture.fromJson(json["arts-culture"]),
      );

  Map<String, dynamic> toJson() => {
    "people": people == null ? null : people!.toJson(),
    "fashion": fashion == null ? null : fashion!.toJson(),
    "health": health == null ? null : health!.toJson(),
    "film": film == null ? null : film!.toJson(),
    "spirituality": spirituality == null ? null : spirituality!.toJson(),
    "arts-culture": artsCulture == null ? null : artsCulture!.toJson(),
  };
}

class ArtsCulture {
  late String status;

  ArtsCulture({
    required this.status,
  });

  factory ArtsCulture.fromJson(Map<String, dynamic> json) => ArtsCulture(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}

class Health {
  late String status;
  DateTime? approvedOn;

  Health({
    required this.status,
    this.approvedOn,
  });


  factory Health.fromJson(Map<String, dynamic> json) => Health(
    status: json["status"],
    approvedOn: json["approved_on"] == null
        ? null
        : DateTime.parse(json["approved_on"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "approved_on":
    approvedOn == null ? null : approvedOn!.toIso8601String(),
  };
}

class Urls {
  late String raw;
  late String full;
  late String regular;
  late String small;
  late String thumb;
  late String smallS3;

  Urls({
    required this.raw,
    required this.full,
    required this.regular,
    required this.small,
    required this.thumb,
    required this.smallS3,
  });

  factory Urls.fromJson(Map<String, dynamic> json) => Urls(
    raw: json["raw"],
    full: json["full"],
    regular: json["regular"],
    small: json["small"],
    thumb: json["thumb"],
    smallS3: json["small_s3"],
  );

  Map<String, dynamic> toJson() => {
    "raw": raw,
    "full": full,
    "regular": regular,
    "small": small,
    "thumb": thumb,
    "small_s3": smallS3,
  };
}