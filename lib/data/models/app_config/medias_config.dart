class MediasSsConfig {
  MediasSsConfig({
    this.avatar,
    this.cover,
    this.post,
  });

  FileSsConfig? avatar;
  FileSsConfig? cover;
  PostSsConfig? post;

  factory MediasSsConfig.fromJson(Map<String, dynamic> json) => MediasSsConfig(
        avatar: FileSsConfig.fromJson(json["avatar"]),
        cover: FileSsConfig.fromJson(json["cover"]),
        post: PostSsConfig.fromJson(json["post"]),
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar?.toJson(),
        "cover": cover?.toJson(),
        "post": post?.toJson(),
      };
}

class PostSsConfig {
  PostSsConfig({
    this.image,
    this.video,
  });

  FileSsConfig? image;
  FileSsConfig? video;

  factory PostSsConfig.fromJson(Map<String, dynamic> json) => PostSsConfig(
        image: FileSsConfig.fromJson(json["image"]),
        video: FileSsConfig.fromJson(json["video"]),
      );

  Map<String, dynamic> toJson() => {
        "image": image?.toJson(),
        "video": video?.toJson(),
      };
}

class FileSsConfig {
  FileSsConfig({
    this.maxSize,
    this.allow = const [],
    this.maxWidth,
    this.maxHeight,
  });

  int? maxSize;
  List<String> allow;
  int? maxWidth;
  int? maxHeight;

  factory FileSsConfig.fromJson(Map<String, dynamic> json) => FileSsConfig(
        maxSize: json["max_size"],
        allow: json.containsKey('allow')
            ? List<String>.from(json["allow"].map((x) => x))
            : [],
        maxWidth: json["max_width"],
        maxHeight: json["max_height"],
      );

  Map<String, dynamic> toJson() => {
        "max_size": maxSize,
        "allow": List<dynamic>.from(allow.map((x) => x)),
        "max_width": maxWidth,
        "max_height": maxHeight,
      };
}
